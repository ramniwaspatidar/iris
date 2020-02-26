//
//  ConnectionManager.m
//  Iris
//
//  Created by apptology on 28/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "Localization.h"
@implementation ConnectionManager

static ConnectionManager *connectionManagerSharedInstance = nil;

+(ConnectionManager *)sharedInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        connectionManagerSharedInstance = [[ConnectionManager alloc] init];
    });
    return connectionManagerSharedInstance;
}

/****************************
 * Function Name : - Start Loader
 * Create on : - 07th Sept 2017
 * Developed By : - Gurmandeep Singh
 * Description : - This method is used for hiding loader on screen.
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)ShowMBHUDLoader
{
    // Getting View from the last viewcontroller on window
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [[YBHud alloc]initWithHudType:16];
        hud.dimAmount = 0.7;
        [hud showInView:app.window animated:YES];
    });
}

- (void)ShowFileMBHUDLoader
{
    // Getting View from the last viewcontroller on window
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        if(hud != nil)
            [self hideMBHUDLoader];
        
        hud = [[YBHud alloc]initWithHudType:16];
        hud.dimAmount = 0.7;
        [hud showInViewWithUploading:app.window animated:YES];
    });
}

-(void)updateCompletionText:(long)currentUploading total:(long)totalUploading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud updateCompletionText:(long)currentUploading total:(long)totalUploading];
    });
}

/****************************
 * Function Name : - Hide Loader
 * Create on : - 07th Sept 2017
 * Developed By : - Gurmandeep Singh
 * Description : - This method is used for hiding loader on screen.
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/


- (void)hideMBHUDLoader
{
    // Getting View from the last viewcontroller on window
    //    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [hud dismissAnimated:YES];
    });
}


- (void)sendGETRequestForURL:(NSString *)strUrl withHeader:(NSString *)header timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    if (showHUD)
    {
        [self ShowMBHUDLoader];
    }
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"GET";
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(header)
        [urlRequest setValue:header forHTTPHeaderField:@"token"];
    
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler: ^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                  {
                                      if (showHUD)
                                          [self hideMBHUDLoader];
                                      
                                      NSLog(@"connection Error %@",connectionError);
                                      
                                      if (!connectionError)
                                      {
                                          NSError* error;
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                          if (error)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (showSystemError == YES)
                                                  {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                      [alert show];
                                                      
                                                  }
                                              });
                                              completion(nil,error);
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if ([json valueForKey:@"error"] && [json valueForKey:@"status"])
                                                  {
                                                      NSString *errorMessage = [json valueForKey:@"error"];
                                                      NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey:errorMessage};
                                                      NSError *biqeError = [NSError errorWithDomain:kErrorTitle code:[[json valueForKey:@"status"] integerValue] userInfo:errorDictionary];
                                                      completion(nil,biqeError);
                                                      
                                                  }
                                                  else
                                                  {
                                                      completion(json,connectionError);
                                                  }
                                              });
                                          }
                                      }
                                      else
                                      {
                                          // No internet or connection timed out condition
                                          if (showSystemError)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              });
                                          }
                                          completion(nil,connectionError);
                                      }
                                  }];
    [task resume];
}

- (void)sendPOSTRequestForURL:(NSString *)strUrl params:(NSMutableDictionary*)paramsDict timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    if (showHUD)
    {
        [self ShowMBHUDLoader];
    }
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [urlRequest setValue:@"1.1" forHTTPHeaderField:@"version"];
    
    
    NSLog(@"Parameter %@",paramsDict);
    
    NSData *paramData = [self createPostHttpBody:paramsDict];
    urlRequest.HTTPBody = paramData;
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler: ^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                  {
                                      if (showHUD)
                                          [self hideMBHUDLoader];
                                      
                                      NSLog(@"connection Error %@",connectionError);
                                      
                                      if (!connectionError)
                                      {
                                          NSError* error;
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                          if (error)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (showSystemError == YES)
                                                  {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                      [alert show];
                                                      
                                                  }
                                              });
                                              completion(nil,error);
                                          }
                                          else
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if ([json valueForKey:@"error"] && [json valueForKey:@"status"])
                                                  {
                                                      NSString *errorMessage = [json valueForKey:@"error"];
                                                      NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey:errorMessage};
                                                      NSError *biqeError = [NSError errorWithDomain:kErrorTitle code:[[json valueForKey:@"status"] integerValue] userInfo:errorDictionary];
                                                      completion(nil,biqeError);
                                                      
                                                  }
                                                  else
                                                  {
                                                      completion(json,connectionError);
                                                  }
                                              });
                                          }
                                      }
                                      else
                                      {
                                          // No internet or connection timed out condition
                                          if (showSystemError)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                  [alert show];
                                                  
                                                  
                                              });
                                          }
                                          completion(nil,connectionError);
                                      }
                                  }];
    [task resume];
}

- (void)sendPOSTRequestForURLWithRawJson:(NSString *)strUrl json:(NSString *)json timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    if (showHUD) {
        [self ShowMBHUDLoader];
    }
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
    
    NSLog(@"Parameter %@",json);
    
    urlRequest.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];;
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                  {
                                      if (showHUD)
                                      {
                                          [self hideMBHUDLoader];
                                      }
                                      if (!connectionError)
                                      {
                                          
                                          NSError* error;
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                          if (error)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if (showSystemError == YES) {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                      [alert show];
                                                       
                                                  }
                                                  
                                              });
                                              completion(nil,error);
                                          }
                                          else
                                          {
                                              if ([json valueForKey:@"error"] && [json valueForKey:@"status"])
                                              {
                                                 NSString *errorMessage = [json valueForKey:@"error"];
                                                  NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey:errorMessage};
                                                  NSError *biqeError = [NSError errorWithDomain:kErrorTitle code:[[json valueForKey:@"status"] integerValue] userInfo:errorDictionary];
                                                  completion(nil,biqeError);
                                                  
                                              }
                                              else
                                              {
                                                  completion(json,connectionError);
                                              }
                                          }
                                      }
                                      else
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                              [alert show];
                                              
                                          });
                                      }
                                      
                                  }];
    [task resume];
}

- (void)sendPOSTRequestForURLWithRawJsonAndHeader:(NSString *)strUrl withHeader:(NSString *)header json:(NSString *)json timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion
{
    if (showHUD) {
        [self ShowMBHUDLoader];
    }
    
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:header forHTTPHeaderField:@"token"];

    
    NSLog(@"Parameter %@",json);
    
    urlRequest.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];;
    urlRequest.timeoutInterval = timeoutInterval;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError)
                                  {
                                      if (showHUD)
                                      {
                                          [self hideMBHUDLoader];
                                      }
                                      if (!connectionError)
                                      {
                                          
                                          NSError* error;
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                                          if (error)
                                          {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  if (showSystemError == YES) {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgJsonParse delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                                      [alert show];
                                                      
                                                  }
                                                  
                                              });
                                              completion(nil,error);
                                          }
                                          else
                                          {
                                              if ([json valueForKey:@"error"] && [json valueForKey:@"status"])
                                              {
                                                  NSString *errorMessage = [json valueForKey:@"error"];
                                                  NSDictionary *errorDictionary = @{ NSLocalizedDescriptionKey:errorMessage};
                                                  NSError *biqeError = [NSError errorWithDomain:kErrorTitle code:[[json valueForKey:@"status"] integerValue] userInfo:errorDictionary];
                                                  completion(nil,biqeError);
                                                  
                                              }
                                              else
                                              {
                                                  completion(json,connectionError);
                                              }
                                          }
                                      }
                                      else
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:kErrorTitle message:kErrorMsgSlowInternet delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                                              [alert show];
                                              
                                          });
                                      }
                                      
                                  }];
    [task resume];
}


- (NSData *)createPostHttpBody : (NSMutableDictionary *)sharingDictionary
{
    NSMutableArray * parameterArray = [[NSMutableArray alloc]init];
    for (NSString * keyValue in sharingDictionary.allKeys)
    {
        NSString* keyString = [NSString stringWithFormat:@"%@=%@",keyValue,[sharingDictionary valueForKey:keyValue]];
        [parameterArray addObject:keyString];
    }
    NSString * postString;
    postString = [parameterArray componentsJoinedByString:@"&"];
    NSLog(@"%@", postString);
    return [postString dataUsingEncoding:NSUTF8StringEncoding];
}
@end

