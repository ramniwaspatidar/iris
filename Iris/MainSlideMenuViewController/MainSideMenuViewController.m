//
//  MainSideMenuViewController.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "MainSideMenuViewController.h"
#import "SideMenuTableViewCell.h"
#import "RevealViewController.h"
#import "Constant.h"
#import "User+CoreDataClass.h"
#import "DbManager.h"
#import "User+CoreDataClass.h"
#import "AppDelegate.h"
#import "TabbarViewController.h"
#import "DashboardViewController.h"
#import "RevealViewController.h"
#import "Utility.h"
#import "SearchViewController.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"
#import "MyHistoryViewController.h"
#import "ReimbursmentViewController.h"
#import "PolicyViewController.h"
#import "BMICalculatorViewController.h"
#import "BloodPressureTrackerViewController.h"
#import "BloodPressureTrackerViewController.h"
#import "LipidViewController.h"
#import "MedicineAlertViewController.h"
#import "PromotionViewController.h"
#import "ProfileViewController.h"
#import "ProviderNetworkViewController.h"
#import "AboutUsViewController.h"
#import "NSData+Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebViewsViewController.h"
#import "DependentProfileDetailViewController.h"

#import "Dependent+CoreDataProperties.h"
#import "PdfWebViewController.h"
#import "ViewYourECardViewController.h"

#define kBlueColor [UIColor colorWithRed:0.0/255.0 green:113.0/255.0 blue:183.0/255.0 alpha:1.0]
#define kLightGrayColor [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]


struct menu {
    NSString *ArabicText;
    NSString *IconURL;
    Boolean *IsMenuforDependent;
    NSInteger *MenuID;
    NSString *Menuname;
    Boolean *Status;
    NSString *URL;
    NSInteger *sortid;
//    "ArabicText": "Policy Details",
//    "IconURL": "http://demoiris.ezyclaim.com:8080/Mobileapp/Mobileapp/MenuIcons/ic_nav_policy.png",
//    "IsMenuforDependent": true,
//    "MenuID": 1,
//    "Menuname": "Policy Details",
//    "Status": true,
//    "URL": "",
//    "sortid": 1
};

@interface MainSideMenuViewController (){
    
}

@property (assign) BOOL isShowingDependentProfile;

@end

@implementation MainSideMenuViewController
+ (NSBundle *)currentLanguageBundle
{
    // Default language incase an unsupported language is found
    NSString *language = @"en";
    
    if ([NSLocale preferredLanguages].count) {
        // Check first object to be of type "en","es" etc
        // Codes seen by my eyes: "en-US","en","es-US","es" etc
        
        NSString *letterCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if ([letterCode rangeOfString:@"en"].location != NSNotFound) {
            // English
            language = @"en";
        } else if ([letterCode rangeOfString:@"ar"].location != NSNotFound) {
            // Spanish
            language = @"ar";
        } // Add more if needed
    }
    
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]];
}

/// Check if preferred language is English
+ (BOOL)isCurrentLanguageEnglish
{
    if (![NSLocale preferredLanguages].count) {
        // Just incase check for no items in array
        return YES;
    }
    
    if ([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location == NSNotFound) {
        // No letter code for english found
        return NO;
    } else {
        // Tis English
        return YES;
    }
}

/*  Swap language between English & Spanish
 *  Could send a string argument to directly pass the new language
 */
+ (void)changeCurrentLanguage
{
    if ([self isCurrentLanguageEnglish]) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = YES;
    
    //Initializing the array which be source for the tableview
    _selectedIndex = nil;
    //_mainTableView.backgroundColor = [UIColor clearColor];
    
    [self updateProfile:nil];
    
    //_mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //All other initialization to be done in the intialSetup method
    //Gurmandeep Singh 10th September 2017
    [self initialSetUp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"update_profile_notification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    _isDepenndentMenu = false;
    
    
    NSMutableDictionary * dictMenu = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"menuDictionary"]];
    NSLog(@"%@", dictMenu);
    
    _menuOptions = [[NSMutableArray alloc]initWithArray:[dictMenu valueForKey:@"Menu"]];
    
    if (self.isShowingDependentProfile){
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"IsMenuforDependent == %d",1];
        NSArray *userArray =(NSArray*) [_menuOptions filteredArrayUsingPredicate:predicate];
        [_menuOptions removeAllObjects];
        _menuOptions = [[NSMutableArray alloc]initWithArray:userArray];
        [_mainTableView reloadData];
    }
    
 /*   if(!self.isShowingDependentProfile){
//        _menuOptions = [[NSMutableArray alloc] initWithObjects:@"My History",@"Reimbursment",@"Policy Details",@"Provider Network", @"BMI Calculator", @"Blood Sugar Tracker",@"Blood Pressure Tracker",@"Lipid Tracker",@"Medicine Alert",@"Promotions", @"About Us",@"SignOut", nil];
//
//        _menuImages = [[NSMutableArray alloc] initWithObjects:@"history",@"reimbursment",@"policy", @"network", @"calculator", @"bloodsugar", @"bloodpressure",@"lipidtraker",@"medicinealert",@"promotion",@"aboutus",@"signout",nil];
 //                [Localization languageSelectedStringForKey:@"Sign Out"]
        _menuOptions = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Policy Details"],[Localization languageSelectedStringForKey:@"View Your E-Card"],[Localization languageSelectedStringForKey:@"Claim History"],[Localization languageSelectedStringForKey:@"Reimbursement"], [Localization languageSelectedStringForKey:@"Provider Network"], [Localization languageSelectedStringForKey:@"BMI Calculator"],  [Localization languageSelectedStringForKey:@"Blood Sugar Tracker"], [Localization languageSelectedStringForKey:@"Blood Pressure Tracker"], [Localization languageSelectedStringForKey:@"Lipid Tracker"],[Localization languageSelectedStringForKey:@"Medicine Alert"], [Localization languageSelectedStringForKey:@"Club IRIS"], [Localization languageSelectedStringForKey:@"About Us"], [Localization languageSelectedStringForKey:@"Feedback"], [Localization languageSelectedStringForKey:@"English"], [Localization languageSelectedStringForKey:@"Sign Out"], nil];
        
        _menuImages = [[NSMutableArray alloc] initWithObjects:@"policy", @"ecart",@"history",@"reimbursment",@"network", @"calculator", @"bloodsugar", @"bloodpressure",@"lipidtraker",@"medicinealert",@"promotion",@"aboutus",@"feedback", @"lanuage",@"signout",nil];
        [_mainTableView reloadData];
        
    }
    
    else{
        _isDepenndentMenu = true;
        _menuOptions = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Policy Details"],[Localization languageSelectedStringForKey:@"View Your E-Card"],[Localization languageSelectedStringForKey:@"Claim History"],[Localization languageSelectedStringForKey:@"Reimbursement"],[Localization languageSelectedStringForKey:@"Provider Network"],[Localization languageSelectedStringForKey:@"Promotions"],[Localization languageSelectedStringForKey:@"About Us"], [Localization languageSelectedStringForKey:@"Feedback"], [Localization languageSelectedStringForKey:@"English"], [Localization languageSelectedStringForKey:@"Sign Out"], nil];
        
        _menuImages = [[NSMutableArray alloc] initWithObjects:@"policy",@"ecart",@"history",@"reimbursment", @"network",@"promotion",@"aboutus",@"feedback", @"lanuage",@"signout",nil];
        
        [_mainTableView reloadData];
        
    }*/
    
}


- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateProfile:(NSNotification *)notification
{
    NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiratesId = [userInfo valueForKey:@"emiratesid"];
    self.isShowingDependentProfile = ([userInfo valueForKey:@"dependentmemberid"] != nil);
    
    NSString *defaultPolicy = @"True";
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",userEmiratesId,defaultPolicy];
    
    User *user = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    NSString *userName = user.fullname;
    NSString *emiratesId = user.emiratesid;
    NSString *profileImage = user.profileimage;
    
    if(self.isShowingDependentProfile) {
        self.accountTypeLabel.text = @"Dependant";
        self.accountTypeLabel.textColor = self.emiratesidLabel.textColor = self.usernameLabel.textColor = kBlueColor;
        _mainTableView.backgroundColor = kLightGrayColor;
        //_mainTableView.separatorColor = [kBlueColor colorWithAlphaComponent:0.4];
        self.dividerView.backgroundColor = kBlueColor;
        
        NSString *dependentId = [userInfo valueForKey:@"dependentmemberid"];
        Dependent *dependentUser = [self getDependentWithId:dependentId fromUser:user];
        if(dependentUser != nil) {
            userName = dependentUser.fullname;
            emiratesId = dependentUser.emiratesid;
            profileImage = dependentUser.profileimage;
        }
    } else {
        self.accountTypeLabel.text = @"Principal";
        self.accountTypeLabel.textColor = self.emiratesidLabel.textColor = self.usernameLabel.textColor = [UIColor whiteColor];
        _mainTableView.backgroundColor = kBlueColor;
        //_mainTableView.separatorColor = [kLightGrayColor colorWithAlphaComponent:0.4];
        self.dividerView.backgroundColor = kLightGrayColor;
    }
    
    self.usernameLabel.text = ([userName isKindOfClass:[NSString class]])?userName:@"";
    self.emiratesidLabel.text = ([emiratesId isKindOfClass:[NSString class]])?emiratesId:@"";
    if([profileImage isKindOfClass:[NSString class]] && profileImage.length > 0)
    {
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profileImage] placeholderImage:[UIImage imageNamed:@"userplaceholde"] options:SDWebImageHighPriority];
        //[self.profileImageView sd_setImageWithURL:[NSURL URLWithString:profileImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }
    else {
        [self.profileImageView setImage:[UIImage imageNamed:@"userplaceholde"]];
    }
}

-(Dependent *)getDependentWithId:(NSString *)dependentId fromUser:(User *)userObj {
    for (Dependent *dependentUser in userObj.depend) {
        if([dependentUser.memberid isEqualToString:dependentId]) {
            return dependentUser;
        }
    }
    return nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//7th September 2017
//Gurmandeep Singh
//Defining all the aspects of view which needs to be initilized on load
#pragma mark initial setup of view
-(void) initialSetUp
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuOptions count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"sideMenuCell";
    SideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SideMenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell._titleLbl.textColor = (self.isShowingDependentProfile)?kBlueColor:[UIColor whiteColor];
    
    NSString *menuTitle = [[_menuOptions objectAtIndex:indexPath.row] valueForKey:@"Menuname"];
    NSString *menuImageUrl = [[_menuOptions objectAtIndex:indexPath.row] valueForKey:@"IconURL"];
    cell._titleLbl.text = [Localization languageSelectedStringForKey:menuTitle];
    
    [cell._iconImgView sd_setImageWithURL:[NSURL URLWithString:menuImageUrl] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    
//    [cell setImage:[_menuImages objectAtIndex:indexPath.row] forMode:!self.isShowingDependentProfile];
    //cell._iconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[_menuImages objectAtIndex:indexPath.row]]];
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    if (indexPath == _selectedIndex)
    {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath;
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
    if(indexPath.row == [_menuOptions count]-1)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logout];
    }
    if(indexPath.row == [_menuOptions count]-2)
    {
        
        
        //Handle your yes please button action here
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
            NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
            //exit(0);
            //
            //                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //
            //
            //                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
            NSLog(@"Arabic");
            
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
            NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
            //                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            //
            //
            //                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
            //                                            NSLog(@"English");
            // exit(0);
        }
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [appDelegate performSelector:@selector(autoLogin) withObject:nil afterDelay:0.0];//12
        
        
        
//      //  [self isCur]
//        UIAlertController * alert = [UIAlertController
//                                     alertControllerWithTitle:@"Language Change"
//                                     message:@"The app will restart to change the language. Do you want to proceed?"
//                                     preferredStyle:UIAlertControllerStyleAlert];
//
//        //Add Buttons
//
//        UIAlertAction* yesButton = [UIAlertAction
//                                    actionWithTitle:@"Yes"
//                                    style:UIAlertActionStyleDefault
//                                    handler:^(UIAlertAction * action) {
//
//
//
//                                        //Handle your yes please button action here
//                                        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
//                                            [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
//                                            NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
//                                           //exit(0);
////
////                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////
////
////                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
//                                            NSLog(@"Arabic");
//
//                                            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//                                        }
//                                        else{
//                                            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//
//                                            [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
//                                            NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
////                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////
////
////                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
////                                            NSLog(@"English");
//                                          // exit(0);
//                                        }
//                                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//                                        [appDelegate performSelector:@selector(autoLogin) withObject:nil afterDelay:0.0];//12
//
//
//
//
//                                    }];
//
//        UIAlertAction* noButton = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction * action) {
//                                       //Handle no, thanks button
//                                   }];
//
//        //Add your buttons to alert controller
//
//        [alert addAction:yesButton];
//        [alert addAction:noButton];
//
//        [self presentViewController:alert animated:YES completion:nil];
       
        
    }
   else if(indexPath.row == 0)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PolicyViewController *policyViewController = [storyBoard instantiateViewControllerWithIdentifier:kPolicyViewStoryboardName];
        [self displayContentController:policyViewController];
    }else if(indexPath.row == 1)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewYourECardViewController *viewYourECardViewController = [storyBoard instantiateViewControllerWithIdentifier:kViewYourECardViewStoryboardName];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate setShouldRotate:YES]; // or NO to disable rotation
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

        [self displayContentController:viewYourECardViewController];
    }
    else if(indexPath.row == 2)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyHistoryViewController *historyViewController = [storyBoard instantiateViewControllerWithIdentifier:kMyHistoryStoryBoardName];
        [self displayContentController:historyViewController];
    }
    else if(indexPath.row == 3)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReimbursmentViewController *reimbursementViewController = [storyBoard instantiateViewControllerWithIdentifier:kReimbursementStoryBoardName];
        [self displayContentController:reimbursementViewController];
    }
    else if(indexPath.row == 4)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProviderNetworkViewController *providerNetworkViewController = [storyBoard instantiateViewControllerWithIdentifier:kProviderNetworkViewStoryboardName];
        [self displayContentController:providerNetworkViewController];
    }
    else if(indexPath.row == 5)
    {
        if(_isDepenndentMenu){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PromotionViewController *promotionViewController = [storyBoard instantiateViewControllerWithIdentifier:kPromotionStoryboardName];
            [self displayContentController:promotionViewController];
            
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BMICalculatorViewController *bmiViewController = [storyBoard instantiateViewControllerWithIdentifier:kBMICalculatorStoryboardName];
            [self displayContentController:bmiViewController];
        }
        
    }
    else if(indexPath.row == 6)
    {
        if(_isDepenndentMenu){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AboutUsViewController *aboutUsViewController = [storyBoard instantiateViewControllerWithIdentifier:kAboutUsStoryBoardIdentifier];
            [self displayContentController:aboutUsViewController];
           
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BloodPressureTrackerViewController *bpTrackerViewController = [storyBoard instantiateViewControllerWithIdentifier:kBloodSugarTrackerStoryboardName];
            [self displayContentController:bpTrackerViewController];
        }
    }
    else if(indexPath.row == 7)
    {
        if(_isDepenndentMenu){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WebViewsViewController *webViewViewController = [storyBoard instantiateViewControllerWithIdentifier:kWebViewsViewController];
            [self displayContentController:webViewViewController];
        }
        else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            BloodPressureTrackerViewController *bpTrackerViewController = [storyBoard instantiateViewControllerWithIdentifier:kBloodPressureTrackerStoryboardName];
            [self displayContentController:bpTrackerViewController];
        }
    }
    else if(indexPath.row == 8)
    {
        if(_isDepenndentMenu){
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate logout];
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LipidViewController *lipidViewController = [storyBoard instantiateViewControllerWithIdentifier:kLipidTrackerStoryboardName];
            [self displayContentController:lipidViewController];
        }
        
    }
    else if(indexPath.row == 9)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MedicineAlertViewController *medicineViewController = [storyBoard instantiateViewControllerWithIdentifier:kMedicineAlertStoryboardName];
        [self displayContentController:medicineViewController];
    }
   else if(indexPath.row == 10)
    {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        PromotionViewController *promotionViewController = [storyBoard instantiateViewControllerWithIdentifier:kPromotionStoryboardName];
//        [self displayContentController:promotionViewController];
        
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                PdfWebViewController *promotionViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PdfWebViewController"];
                [self displayContentController:promotionViewController];
        
//            PdfWebViewController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"PdfWebViewController"];
//            UINavigationController *navigationController = [[UINavigationController alloc] init];
//            [self.navigationController pushViewController:myViewController animated:YES];
    }
    else if(indexPath.row == 11)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AboutUsViewController *aboutUsViewController = [storyBoard instantiateViewControllerWithIdentifier:kAboutUsStoryBoardIdentifier];
        [self displayContentController:aboutUsViewController];
    }
    else if(indexPath.row == 12)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewsViewController *webViewViewController = [storyBoard instantiateViewControllerWithIdentifier:kWebViewsViewController];
        [self displayContentController:webViewViewController];
    }
    //[_mainTableView reloadData];
}

- (void) displayContentController: (UIViewController*) content;
{
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    
    
    
    //navController.viewControllers = nil;
    
    UITabBarController *tabBarController = (UITabBarController *)navController.viewControllers.firstObject;
    
    
    UIViewController *parentViewController = tabBarController.selectedViewController;
    
    NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:parentViewController.childViewControllers];
    if(tbViewControllers.count > 0)
    {
        UIViewController *childViewCtr = [tbViewControllers firstObject];
        [self removeClass:NSStringFromClass([childViewCtr class]) fromChildViewControllers:parentViewController.childViewControllers];
    }
    
    if(parentViewController.childViewControllers.count) {
        [self removeClass:NSStringFromClass([content class]) fromChildViewControllers:parentViewController.childViewControllers];
    }
   
    [parentViewController addChildViewController:content];                 // 1
    content.view.bounds = parentViewController.view.bounds;                 //2
    [parentViewController.view addSubview:content.view];
    [content didMoveToParentViewController:parentViewController];          // 3
    tabBarController.tabBar.tintColor = [UIColor colorWithRed:156.0/255.0 green:199.0/255.0 blue:227.0/255.0 alpha:1.0] ;
    
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

-(void)removeClass:(NSString *)className fromChildViewControllers:(NSArray *)childControllers {
    for (UIViewController *controller in childControllers) {
        if([NSStringFromClass([controller class]) isEqualToString:className]) {
            [controller willMoveToParentViewController:nil];  // 1
            [controller.view removeFromSuperview];            // 2
            [controller removeFromParentViewController];      // 3
            break;
        }
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue isKindOfClass: [RevealViewControllerSegue class]] )
    {
        RevealViewControllerSegue *swSegue = (RevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(RevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
            if([sender isEqualToString:@"dashboard"])
            {
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[dvc] animated: NO];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                return;
            }
            else if([sender isEqualToString:@"search"])
            {
                ((UITabBarController *)dvc).selectedIndex = 1;
            }
            else if([sender isEqualToString:@"appointment"])
            {
                ((UITabBarController *)dvc).selectedIndex = 2;
            }
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            
            [navController setViewControllers: @[dvc] animated: NO];
            
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


#pragma mark - Button Action -

- (IBAction)editProfileButtonAction:(id)sender {
    
    if(_isDepenndentMenu)
    {
        NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        NSString *userEmiratesId = [userInfo valueForKey:@"emiratesid"];
        self.isShowingDependentProfile = ([userInfo valueForKey:@"dependentmemberid"] != nil);
        
        NSString *defaultPolicy = @"True";
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",userEmiratesId,defaultPolicy];
        
        User *user = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
        
        NSString *dependentId = [userInfo valueForKey:@"dependentmemberid"];
        Dependent *dependentUser = [self getDependentWithId:dependentId fromUser:user];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DependentProfileDetailViewController *dependentProfileViewController = [storyBoard instantiateViewControllerWithIdentifier:kDependentProfileViewStoryboardName];
        dependentProfileViewController.showMenuIcon = YES;
        dependentProfileViewController.dependentUser = dependentUser;
        [self displayContentController:dependentProfileViewController];
    }
    else
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController *profileViewController = [storyBoard instantiateViewControllerWithIdentifier:kProfileViewStoryboardName];
        [self displayContentController:profileViewController];
    }
}



@end
