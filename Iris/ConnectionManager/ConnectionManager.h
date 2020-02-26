//
//  ConnectionManager.h
//  Iris
//
//  Created by apptology on 28/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBHud.h"

typedef void (^kResultBlock)(NSDictionary *dictionary, NSError *error);

@interface ConnectionManager : NSObject
{
    YBHud *hud;
}

+(ConnectionManager *)sharedInstance;
- (void)ShowMBHUDLoader;
- (void)ShowFileMBHUDLoader;
- (void)hideMBHUDLoader;
-(void)updateCompletionText:(long)currentUploading total:(long)totalUploading;

- (void)sendPOSTRequestForURL:(NSString *)url params:(NSMutableDictionary*)paramsData timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

- (void)sendPOSTRequestForURLWithRawJson:(NSString *)strUrl json:(NSString *)json timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

- (void)sendPOSTRequestForURLWithRawJsonAndHeader:(NSString *)strUrl withHeader:(NSString *)header json:(NSString *)json timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

- (void)sendGETRequestForURL:(NSString *)strUrl withHeader:(NSString *)header timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

@end
