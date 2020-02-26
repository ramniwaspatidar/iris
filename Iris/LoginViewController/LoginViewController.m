//
//  LoginViewController
//  Iris
//
//  Created by apptology on 27/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "LoginViewController.h"
#import "Utility.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "TabbarViewController.h"
#import "RevealViewController.h"
#import "MainSideMenuViewController.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "SearchViewController.h"
#import "User+CoreDataClass.h"
#import "DbManager.h"
#import "PolicyDetails+CoreDataProperties.h"
#import "Dependent+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BenefitGroup+CoreDataProperties.h"
#import "Benefit+CoreDataProperties.h"
#import "ForgotPasswordViewController.h"
#import <sys/utsname.h>
#import "MainSideMenuViewController.h"
#import "PdfWebViewController.h"
#import "Localization.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

#define MAX_LENGTH 15

//@synthesize emailTextField = _emailTextField;
//@synthesize passwordTextField = _passwordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
 

    [_loginButton setButtonCornerRadious];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    _imageUrlArray = [[NSArray alloc] initWithObjects:@"http://ezyclaim.com/Mappimages/slide_b_1.jpg",@"http://ezyclaim.com/Mappimages/slide_b_2.jpg",@"http://ezyclaim.com/Mappimages/slide_b_3.jpg", nil];
    
    
    /*
     #import "Localization.h"
     
     
     helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
     uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
     omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
     
     
     #import "Localization.h"
     #import "MainSideMenuViewController.h"
     
     if ([MainSideMenuViewController isCurrentLanguageEnglish]){
     [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
     
     [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
     }
     else{
     [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
     
     
     [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
     
     }
     
     
     */
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        userNameLbl.text = [Localization languageSelectedStringForKey:@"Username/Mobileno"];
        passwordLbl.text =  [Localization languageSelectedStringForKey:@"Password"];
        dontLbl.text = [Localization languageSelectedStringForKey:@"Don't have an account?"];
        hrlpLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [forgotpwdLbl setTitle:[Localization languageSelectedStringForKey:@"Forgot Password?"] forState:UIControlStateNormal];
        
        [loginBtn setTitle:[Localization languageSelectedStringForKey:@"LOGIN"] forState:UIControlStateNormal];
        [signUpBtn setTitle:[Localization languageSelectedStringForKey:@"Signup"] forState:UIControlStateNormal];
        _emailTextField.textAlignment  = NSTextAlignmentLeft;
        _passwordTextField.textAlignment  = NSTextAlignmentLeft;
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }else{
        
        
        userNameLbl.text = [Localization languageSelectedStringForKey:@"Username/Mobileno"];
        passwordLbl.text =  [Localization languageSelectedStringForKey:@"Password"];
        dontLbl.text = [Localization languageSelectedStringForKey:@"Don't have an account?"];
        hrlpLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [forgotpwdLbl setTitle:[Localization languageSelectedStringForKey:@"Forgot Password?"] forState:UIControlStateNormal];
        
          [loginBtn setTitle:[Localization languageSelectedStringForKey:@"LOGIN"] forState:UIControlStateNormal];
         [signUpBtn setTitle:[Localization languageSelectedStringForKey:@"Signup"] forState:UIControlStateNormal];
        _emailTextField.textAlignment  = NSTextAlignmentRight;
         _passwordTextField.textAlignment  = NSTextAlignmentRight;
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];


        //   [revealController setFrontViewController:frontNavigationController];
    }
    [self setImagesOnScrollView];
    [self addGestureonView];
    
    if([Utility IsiPhoneX])
    {
        websiteViewBottomCons.constant = -35;
        _logoTopSpaceCons.constant = -20;
    }
    
#ifdef DEBUG
    // multiple policy
//    _emailTextField.text = @"055678934";//055678934 //055221111
//    _passwordTextField.text = @"123456";
    // multiple child
    //_emailTextField.text = @"052323346";
    //_passwordTextField.text = @"123456";
#endif
    // Do any additional setup after loading the view, typically from a nib.
    
#if 0
    [self needsUpdate];
#endif

}

-(BOOL) needsUpdate{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1){
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            
            [Utility showAlertViewControllerInWindowWithActionNames:@[[Localization languageSelectedStringForKey:@"OK"]] title:@"A new version is available." message:[NSString stringWithFormat:@"Please update current app version %@ to %@",currentVersion,appStoreVersion] block:^(int tag) {
                
            }];
            return YES;
        }
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:@"Login"];
    
    
}

-(void)addGestureonView
{
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)setImagesOnScrollView
{
    for(int i = 0; i < 3; i++)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, _bottomScrollView.frame.size.height)];
        
        NSString *adImagUrl = [NSString stringWithFormat:@"%@",[_imageUrlArray objectAtIndex:i]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:adImagUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if(!error){
                [_bottomScrollView addSubview:imgView];
                _bottomScrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, _bottomScrollView.frame.size.height-50);
                [_bottomScrollView setNeedsDisplay];
                [_bottomScrollView setNeedsLayout];
            }
        }];
        
    }
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)forgotPasswordButtonAction:(id)sender {
    [self performSegueWithIdentifier:kForgotPasswordViewIdentifier sender:nil];
    
}

- (IBAction)loginButtonAction:(id)sender {
    NSString *message = [self validateForm];
    if(!message)
    {
        [self callLoginAPI:_emailTextField.text andPassword:_passwordTextField.text];
    }
    else
    {
        [Utility showAlertViewControllerIn:self title:nil message:message block:^(int index)
         {
         }];
    }
    

}



- (IBAction)signupButtonAction:(id)sender {
    [self performSegueWithIdentifier:kSignupIdentifier sender:nil];
    
}

- (IBAction)facebookButtonAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kFacebookUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFacebookUrl]];
    }
}

- (IBAction)instagramButtonAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kInstagramUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kInstagramUrl]];
    }
}

- (IBAction)websiteButtonAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kWebsiteUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kWebsiteUrl]];
    }
}

-(void)callLoginAPI:(NSString *)email andPassword:(NSString*)password
{
    _emailTextField.text = email;
    _passwordTextField.text = password;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:email forKey:@"username"];
    [dictionary setValue:password forKey:@"password"];
    [dictionary setValue:email forKey:@"mobileno"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"LoginUser"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJson:url json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
                 
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                    
                     [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                         
                     } ];
                     [[SDImageCache sharedImageCache] clearMemory];
                     [[DbManager getSharedInstance] clearTable:@"User"];
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Dependent" withPredicate:nil];
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"PolicyDetails" withPredicate:nil];
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"BenefitGroup" withPredicate:nil];
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Benefit" withPredicate:nil];
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults removeObjectForKey:@"login"];
                     [defaults synchronize];
                     UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     TabbarViewController *homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"TabbarControllerIdentifier"];
                     DashboardViewController *dashboardObj =  (DashboardViewController*)[[homeViewController viewControllers] objectAtIndex:0];
                     SearchViewController *searchObj =  (SearchViewController*)[[homeViewController viewControllers] objectAtIndex:1];
                     NSMutableDictionary *updatedDictionary = [[NSMutableDictionary alloc] init];
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
                     NSArray *allPolicyHolderArray = [dictionary valueForKey:@"policyholder"];
                     NSArray *defaultArray = [allPolicyHolderArray filteredArrayUsingPredicate:predicate];
                     // For E-Card details
                     NSMutableDictionary *updatedECardInfoDictionary = [[NSMutableDictionary alloc] init];
                     NSArray *eCardInfoArray = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:0] valueForKey:@"eCardInfo"];
                     [updatedECardInfoDictionary setValue:eCardInfoArray forKey:@"eCardInfo"];
                     [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:updatedECardInfoDictionary] forKey:@"policyInfoDictionary"];
                     //=================================
                     if(defaultArray.count > 0)
                         [updatedDictionary addEntriesFromDictionary:[defaultArray firstObject]];
                     else
                         [updatedDictionary addEntriesFromDictionary:[allPolicyHolderArray firstObject]];
                     [updatedDictionary setValue:[dictionary valueForKey:@"token"] forKey:@"token"];
                     dashboardObj.personDetailDictionary = updatedDictionary;
                     searchObj.personDetailDictionary = updatedDictionary;
                     NSArray *policyHolderArray = [dictionary valueForKey:@"policyholder"];
                     for(int i = 0; i< policyHolderArray.count; i++)
                     {
                         User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                    inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                         
                         user.name= _emailTextField.text;
                         user.password = _passwordTextField.text;
                         user.email = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"email"];
                         user.fullname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"fullname"];
                         user.gender = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"gender"];
                         user.memberid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"memberid"];
                         user.residence = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"residence"];
                         user.nationality = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"nationality"];
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"])
                             user.mobileno = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"];
                         user.company = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                         user.insurancecompany = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                         if([[[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"] isKindOfClass:[NSString class]])
                         {
                             user.defaultpolicyholder = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"];
                         }
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                             user.emiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                         
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] && ![[[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                             user.profileimage = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"];
                         
                         user.token = [dictionary valueForKey:@"token"];
                         
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"])
                         {
                             PolicyDetails *policyDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PolicyDetails"
                                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                             
                             NSDictionary *policyDetailDic = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"];
                             if([policyDetailDic valueForKey:@"emiratesid"])
                                 policyDetail.emiratesid = [policyDetailDic valueForKey:@"emiratesid"];
                             policyDetail.memberid = [policyDetailDic valueForKey:@"memberid"];
                             policyDetail.policyno = [policyDetailDic valueForKey:@"policynumber"];
                             policyDetail.policyperiod = [policyDetailDic valueForKey:@"policyperiod"];
                             policyDetail.policystatus = [policyDetailDic valueForKey:@"status"];
                             policyDetail.premiumamount = [policyDetailDic valueForKey:@"premiumamount"];
                             policyDetail.mastercontractname = [policyDetailDic valueForKey:@"mastercontractname"];
                             policyDetail.productname = [policyDetailDic valueForKey:@"productname"];
                             policyDetail.insurancecompanyname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                             policyDetail.companyname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                             
                             if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                 policyDetail.parentemiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                             
                             
                             if([policyDetailDic valueForKey:@"policystartdate"])
                                 policyDetail.startdate = [policyDetailDic valueForKey:@"policystartdate"];
                             
                             if([policyDetailDic valueForKey:@"policyenddate"])
                                 policyDetail.enddate = [policyDetailDic valueForKey:@"policyenddate"];
                             
                             //[[DbManager getSharedInstance] saveContext];
                             
                             // process and generate plan benefits data
                             policyDetail.benefitgroup = [self processBenefitsData:[policyDetailDic valueForKey:@"planbenefits"]];
                             
                             user.policydetail = policyDetail;
                             
                         }
                         NSArray *dependentArray = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"dependents"];
                         
                         if(dependentArray.count > 0)
                         {
                             NSMutableSet * dependentSet = [[NSMutableSet alloc]init];
                             for(NSDictionary *dependentDic in dependentArray)
                             {
                                 Dependent *dependent = [NSEntityDescription insertNewObjectForEntityForName:@"Dependent"
                                                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                                 if(![[dependentDic valueForKey:@"email"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.email = [dependentDic valueForKey:@"email"];
                                 }
                                 if(![[dependentDic valueForKey:@"emiratesid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.emiratesid = [dependentDic valueForKey:@"emiratesid"];
                                 }
                                 if(![[dependentDic valueForKey:@"fullname"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.fullname = [dependentDic valueForKey:@"fullname"];
                                 }
                                 
                                 if(![[dependentDic valueForKey:@"gender"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.gender = [dependentDic valueForKey:@"gender"];
                                 }
                                 if(![[dependentDic valueForKey:@"memberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.memberid = [dependentDic valueForKey:@"memberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"nationality"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.nationality = [dependentDic valueForKey:@"nationality"];
                                 }
                                 if(![[dependentDic valueForKey:@"passport"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.passport = [dependentDic valueForKey:@"passport"];
                                 }
                                 if(![[dependentDic valueForKey:@"principalmemberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.principalmemberid = [dependentDic valueForKey:@"principalmemberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"relation"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.relation = [dependentDic valueForKey:@"relation"];
                                 }
                                 if(![[dependentDic valueForKey:@"residence"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.residence = [dependentDic valueForKey:@"residence"];
                                 }
                                 if(![[dependentDic valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.profileimage = [dependentDic valueForKey:@"profileimage"];
                                 }
                                 if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                     dependent.parentemiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                                 [dependentSet addObject:dependent];
                                 //[[DbManager getSharedInstance] saveContext];
                             }
                             user.depend = dependentSet;
                         }
                         [[DbManager getSharedInstance] saveContext];
                     }
                     User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                     inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                     
                     MainSideMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:kMainSideMenuStoryBoardName];
                     rearViewController.usernameLabel.text = [updatedDictionary valueForKey:@"fullname"];
                     if([updatedDictionary valueForKey:@"emiratesid"])
                         rearViewController.emiratesidLabel.text = [updatedDictionary valueForKey:@"emiratesid"];
                     
                     UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                     [frontNavigationController setNavigationBarHidden:YES animated:NO];
                     UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
                     [rearNavigationController setNavigationBarHidden:YES animated:NO];
                    
                     RevealViewController *revealController = [[RevealViewController alloc] init] ;
                     if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                         [revealController setFrontViewController:frontNavigationController];
                         [revealController setRearViewController:rearNavigationController];
                        

                         [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                     }
                     else{
                         [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                         
                         [revealController setRightViewController:rearNavigationController];
                         [revealController setFrontViewController:frontNavigationController];

                     }
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     appDelegate.window.rootViewController = revealController;
                     [appDelegate.window makeKeyAndVisible];
                 }
                 else
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                         
                     }];
                 }
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kSignupIdentifier])
    {
        //HIPRootViewController *hipRootViewController = segue.destinationViewController;
    }
    else if ([segue.identifier isEqualToString:kForgotPasswordViewIdentifier])
    {
        ForgotPasswordViewController *forgotPasswordViewController = segue.destinationViewController;
    }
}

#pragma mark- Validation Methods -
-(NSString *)validateForm
{
    if([Utility trimString:_emailTextField.text].length == 0)
    {
        return [Localization languageSelectedStringForKey:@"Please enter username."];
    }
    else if([Utility trimString:_passwordTextField.text].length == 0)
    {
        
        return [Localization languageSelectedStringForKey:@"Please enter password."];
    }
    
#if 0
    else if([Utility trimString:_passwordTextField.text].length <= 7 || [Utility trimString:_passwordTextField.text].length > 15)
    {
       
        return  [Localization languageSelectedStringForKey:@"Password should be alphanumeric and between 8 to 15 characters."];
    }
#endif
    
    return nil;
}

#pragma mark- UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _emailTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    if (textField == _passwordTextField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    if(textField == _passwordTextField)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_LENGTH){
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([a-zA-Z0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    else if(textField == _emailTextField)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > 40){
            return NO;
        }
    }
    return YES;
}

#pragma mark- Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed, do your thing!
        // ...
        // Finally, update previous page
        previousPage = page;
        _pageController.currentPage = page;
        
    }
    
}

#pragma mark - private methods
-(NSMutableSet *)processBenefitsData:(NSDictionary *)benefitData {
    NSMutableSet *planBenefits = [[NSMutableSet alloc] init];
    
    NSArray *parentBenefits = [benefitData valueForKey:@"BenefitMaster"];
    NSSet *benefitGroups = [NSSet setWithArray:[parentBenefits valueForKey:@"Group"]];
    
    NSArray *childBenefits = [benefitData valueForKey:@"BenefitChild"];
    
    // loop through groups
    for (NSString *groupTitle in benefitGroups) {
        BenefitGroup *benefitGroup = [NSEntityDescription insertNewObjectForEntityForName:@"BenefitGroup"
                                                                   inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        benefitGroup.grouptitle = groupTitle;
        
        NSPredicate *parentBenefitPredicate = [NSPredicate predicateWithFormat:@"Group ==[c]%@",groupTitle];
        NSArray *filteredParentBenefits = [parentBenefits filteredArrayUsingPredicate:parentBenefitPredicate];
        
        NSMutableSet *parentBenefitSet = [[NSMutableSet alloc] init];
        // loop through parent benefits
        for (NSDictionary *parentBenefit in filteredParentBenefits) {
            Benefit *parentBenefitObj = [NSEntityDescription insertNewObjectForEntityForName:@"Benefit"
                                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
            
            NSString *benefitId = [parentBenefit valueForKey:@"BenefitID"];
            if(!benefitId || benefitId == [NSNull null]) {
                //continue;
                benefitId = 0;
            }
            
            parentBenefitObj.benefitid = benefitId;
            parentBenefitObj.benefitdescription = [parentBenefit valueForKey:@"Description"];
            parentBenefitObj.value = ([[parentBenefit valueForKey:@"Value"] isKindOfClass:[NSString class]])?[parentBenefit valueForKey:@"Value"]:@"0";
            parentBenefitObj.parentid = @"0";
            
            //benefitObj.parentid = [benefit valueForKey:@"ParentBenefitID"];
            parentBenefitObj.sortid = [parentBenefit valueForKey:@"Sortid"];
            benefitGroup.groupid = parentBenefitObj.sortid;
            [parentBenefitSet addObject:parentBenefitObj];
            
            // loop through child benefits
            NSPredicate *childBenefitPredicate = [NSPredicate predicateWithFormat:@"ParentBenefitID ==[c] %@",benefitId];
            NSArray *filteredChildBenefits = [childBenefits filteredArrayUsingPredicate:childBenefitPredicate];
            for (NSDictionary *childBenefit in filteredChildBenefits) {
                Benefit *childBenefitObj = [NSEntityDescription insertNewObjectForEntityForName:@"Benefit"
                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                
                if(![[childBenefit valueForKey:@"BenefitID"] isKindOfClass:[NSNull class]])
                    childBenefitObj.benefitid = [childBenefit valueForKey:@"BenefitID"];
                childBenefitObj.benefitdescription = [childBenefit valueForKey:@"Description"];
                
                if(![[childBenefit valueForKey:@"Value"] isKindOfClass:[NSNull class]])
                    childBenefitObj.value = [childBenefit valueForKey:@"Value"];
                
                if(![[childBenefit valueForKey:@"ParentBenefitID"] isKindOfClass:[NSNull class]])
                    childBenefitObj.parentid = [childBenefit valueForKey:@"ParentBenefitID"];
                
                childBenefitObj.sortid = [childBenefit valueForKey:@"Sortid"];
                [parentBenefitSet addObject:childBenefitObj];
            }
            
        }
        benefitGroup.benefits = parentBenefitSet;
        [planBenefits addObject:benefitGroup];
    }
    
    return planBenefits;
}




@end

