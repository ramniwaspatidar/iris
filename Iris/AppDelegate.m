//
//  AppDelegate.m
//  Iris
//
//  Created by apptology on 27/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Constant.h"
#import "UIImage+animatedGIF.h"
#import "SplashViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MainSideMenuViewController.h"
#import "TabbarViewController.h"
#import "DashboardViewController.h"
#import "RevealViewController.h"
#import "Utility.h"
#import "SearchViewController.h"
#import <Google/Analytics.h>
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import "ViewYourECardViewController.h"
#import "LanguageChangeViewController.h"
@import UserNotifications;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSPlacesClient provideAPIKey:@"AIzaSyDD92afc7M8NesWL3OGgFB7LEEzNfWyRA8"];
    [GMSServices provideAPIKey:@"AIzaSyDD92afc7M8NesWL3OGgFB7LEEzNfWyRA8"];
    
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-115175641-1"];

    [Fabric with:@[[Crashlytics class]]];
    //[FIRApp configure];
    //[Fabric.sharedSDK setDebug:YES];
    //[CrashlyticsKit setUserIdentifier:@"com.iris.healthservices"];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Override point for customization after application launch.
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
        
        UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"Snooze"
                                                                                  title:@"Snooze" options:UNNotificationActionOptionNone];
        UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Delete"
                                                                                  title:@"Delete" options:UNNotificationActionOptionDestructive];
        
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"UYLReminderCategory"
                                                                                  actions:@[snoozeAction,deleteAction] intentIdentifiers:@[]
                                                                                  options:UNNotificationCategoryOptionNone];
        NSSet *categories = [NSSet setWithObject:category];
        [center setNotificationCategories:categories];

        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!granted) {
                                      NSLog(@"Something went wrong");
                                  }
                              }];
        
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
                // Notifications not allowed
            }
        }];

    } else {
        // Fallback on earlier versions
    }

    
    [OneSignal initWithLaunchOptions:launchOptions
     appId:@"2e0311b2-9069-4442-8a60-773c37cbc8a0"
     handleNotificationAction:nil
     settings:@{kOSSettingsKeyAutoPrompt: @false}];
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;

    // Recommend moving the below line to prompt for push after informing the user about
    // how your app will use them.
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
      NSLog(@"User accepted notifications: %d", accepted);
    }];

    //    //add the image to the forefront...
    /*/UIImageView *launcherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 250, 200)];
    //    //you can download UIImage+animatedGIF here https://github.com/mayoff/uiimage-from-animated-gif
    
    NSString *assetLocalPath = [[NSBundle mainBundle] pathForResource:@"logo_aniamtion" ofType:@"gif"];
    NSURL *assetURL = [[NSURL alloc] initFileURLWithPath:assetLocalPath];
    
    [launcherImageView setImage: [UIImage animatedImageWithAnimatedGIFURL:assetURL]];
    [self.window addSubview:launcherImageView];
    [self.window bringSubviewToFront:launcherImageView];
    */
    
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    [self.window makeKeyAndVisible];
  
    return YES;
}

-(void)showLoginScreenWithDelay:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
#if 0
        NSDictionary *personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        
        if(personDetailDictionary)
        {
            [self autoLogin];
            return;
        }
#endif
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        LoginViewController * mainController = [storyboard instantiateViewControllerWithIdentifier:kLoginScreenStoryBoardName];
        self.navController = [[UINavigationController alloc]initWithRootViewController:mainController];
        [self.navController setNavigationBarHidden:YES animated:NO];
        [self.window setRootViewController:self.navController];
    });
}

-(void)showsplashScreenWithDelay:(id)sender
{
    
        
        LanguageChangeViewController *secondViewController = [[LanguageChangeViewController alloc] init];
        
        self.navController = [[UINavigationController alloc]initWithRootViewController:secondViewController];
        [self.navController setNavigationBarHidden:YES animated:NO];
        [self.window setRootViewController:self.navController];
   

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack


- (NSManagedObject *)createObject:(NSString *)entityName {
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return obj;
}

- (void)deleteObject:(NSManagedObject *)object {
    if(!object){
        NSLog(@"nil object delete");
    }
    @try {
        [self.managedObjectContext deleteObject:object];
    }
    @catch (NSException *exception) {
        @try {
            [self.managedObjectContext deleteObject:[self.managedObjectContext objectWithID:object.objectID]];
        }
        @catch (NSException *exception) {
        }
    }
}

- (BOOL)saveDB:(BOOL) fireNotification {
    @try {
        
        NSError *error;
        BOOL save = [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"error::%@ :: %@", error.localizedDescription,error);
        }
        return save;
    }
    @catch (NSException *exception) {
        NSLog(@"save Exp : %@",exception);
    }
    @finally {
    }
}

- (void)clearTable:(NSString *)name {
    NSFetchRequest *allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *manObjs = [self.managedObjectContext executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject *manObj in manObjs) {
        [self.managedObjectContext deleteObject:manObj];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    //more error handling here
}

- (NSArray *)fatchAllObjectsForEntity:(NSString *)entityName sortKey:(NSString *)sortKey ascending:(BOOL)sortAscending {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    if (sortKey) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        [request setSortDescriptors:@[sortDescriptor]];
    }
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return [array copy];
}
- (NSManagedObject *)fatchObjectForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate{
    NSArray *array = [self fatchAllObjectsForEntity:entityName withPredicate:predicate sortKey:nil ascending:NO];
    if(array&&array.count>0){
        NSManagedObject *obj=array[array.count-1];
        if(array.count>1){
            //                    abort();
            NSLog(@"*** erooro \n%@",array);
        }
        for (int i=0; i<array.count-1; i++) {
            NSManagedObject* obj=array[i];
            
            [self deleteObject:obj];
        }
      
        return obj;
    }
    return nil;
}
-(NSManagedObject*)topObjectFor:(NSString*)entityName sortBy:(NSString*)sortKey ascending:(BOOL)sortAscending{
    NSArray* arr=[self fatchAllObjectsForEntity:entityName sortKey:sortKey ascending:sortAscending];
    if(arr&&arr.count>0){
        return arr[0];
    }
    return nil;
}
- (NSArray *)fatchAllObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate sortKey:(NSString *)sortKey ascending:(BOOL)sortAscending {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortKey) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:sortAscending];
        [request setSortDescriptors:@[sortDescriptor]];
    }
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return [array copy];
}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.prospus.DBChecker" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return [self persistentStoreCoordinator:YES];
   
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(BOOL)deleteOld {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    // Create the coordinator and store
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSString *dbfileName = [NSString stringWithFormat:@"Iris.sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dbfileName];
    NSLog(@"db path: %@", storeURL);
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        if(deleteOld){
            @try {
                NSFileManager* manager=  [NSFileManager defaultManager];
                [manager removeItemAtPath:[storeURL path] error:&error];
                persistentStoreCoordinator=nil;
                return [self persistentStoreCoordinator:NO];
            }
            @catch (NSException *exception) {
                NSLog(@"error %@",exception);
            }
            @finally {
            }
        }
    }
    return persistentStoreCoordinator;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    exit(0);
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)logout
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"login"];
    [defaults removeObjectForKey:@"usermemberid"];
    [defaults synchronize];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *initialController = [storyBoard instantiateViewControllerWithIdentifier:kLoginScreenStoryBoardName];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:initialController];
    [navigation setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = navigation;
}
/*
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    dispatch_async(dispatch_get_main_queue(), ^{

        if (@available(iOS 10.0, *))
        {
            NSLog( @"iOS version >= 10. Let NotificationCenter handle this one." );
            // set a member variable to tell the new delegate that this is background
            return;
        }
    });
}
*/
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Userinfo........... %@",notification.request.content.userInfo);
        
        [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(updateAlertNotification) userInfo:nil repeats:NO];
        
        if (@available(iOS 10.0, *)) {
            completionHandler(UNNotificationPresentationOptionAlert);
        } else {
            // Fallback on earlier versions
        }
    });
}

-(void)updateAlertNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update_alert_notification"                                                                object:nil userInfo:nil];
    });
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    //UITabBarController *tabBarController = (UITabBarController *)self.navController.viewControllers.firstObject;
    //tabBarController.selectedIndex = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Userinfo %@",response.notification.request.content.userInfo);

    });
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Localization languageSelectedStringForKey:@"Medicine Alert"]
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Request to reload table view data
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

-(void)autoLogin
{
    NSDictionary *personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];

    if(personDetailDictionary)
    {
        
       

        UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabbarViewController *homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"TabbarControllerIdentifier"];
        
        DashboardViewController *dashboardObj =  (DashboardViewController*)[[homeViewController viewControllers] objectAtIndex:0];
        SearchViewController *searchObj =  (SearchViewController*)[[homeViewController viewControllers] objectAtIndex:1];
        
        dashboardObj.personDetailDictionary = personDetailDictionary;
        searchObj.personDetailDictionary = personDetailDictionary;
        
        MainSideMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:kMainSideMenuStoryBoardName];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        [frontNavigationController setNavigationBarHidden:YES animated:NO];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        [rearNavigationController setNavigationBarHidden:YES animated:NO];
        RevealViewController *revealController = [[RevealViewController alloc] init] ;
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            [revealController setFrontViewController:frontNavigationController];
            [revealController setRearViewController:rearNavigationController];
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            [revealController setRightViewController:rearNavigationController];
            [revealController setFrontViewController:frontNavigationController];
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
//        RevealViewController *revealController = [[RevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = revealController;
        [appDelegate.window makeKeyAndVisible];
    }
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//
//    UIViewController *rootVC = [self topViewControllerWithRootViewController:[window rootViewController]];
//
//    if ([rootVC respondsToSelector:@selector(canRotate)]) {
//
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    }
//
//    // Only allow portrait (standard behaviour)
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIViewController*)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
//
//    if (rootViewController == nil) { return nil; }
//    if (rootViewController == [UITabBarController class]) {
//        return [self topViewControllerWithRootViewController:rootViewController];
//    }else if (rootViewController == [UINavigationController class]) {
//        return [self topViewControllerWithRootViewController:rootViewController];
//    }else if ([rootViewController presentedViewController] != nil) {
//        return [self topViewControllerWithRootViewController:rootViewController];
//    }
//    return rootViewController;
//}
//
//

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.shouldRotate) {
        return UIInterfaceOrientationMaskLandscape;

    }else {
        return UIInterfaceOrientationMaskPortrait;

    }
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    if ([navigationController isKindOfClass:[ViewYourECardViewController class]])
//    {
//        return UIInterfaceOrientationMaskLandscape;
//    }
//    else
//        return UIInterfaceOrientationMaskPortrait;
//}

@end
