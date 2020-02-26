//
//  AppDelegate.h
//  Iris
//
//  Created by apptology on 27/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) BOOL shouldRotate;
@property (assign, nonatomic) BOOL isViewYourCard;


-(void)showLoginScreenWithDelay:(id)sender;
-(void)showsplashScreenWithDelay:(id)sender;
- (void)autoLogin;


- (void)saveContext;
-(void)logout;

@end

