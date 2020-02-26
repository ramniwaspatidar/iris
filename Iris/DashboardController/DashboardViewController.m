//
//  DashboardViewController.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "DashboardViewController.h"
#import "RevealViewController.h"
#import "DashboardTableViewCell.h"
#import "EmiratesIDTableViewCell.h"
#import "ConnectionManager.h"
#import "Constant.h"
#import "User+CoreDataClass.h"
#import "DbManager.h"
#import "PolicyDetailTableViewCell.h"
#import "Utility.h"
#import "Localization.h"
#import "AppointmentReminder+CoreDataProperties.h"
#import "AppointmentReminderViewController.h"
#import "Dependent+CoreDataProperties.h"
#import "MyHistoryViewController.h"
#import "UILabel+CustomLabel.h"
#import "PolicyDetails+CoreDataProperties.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "TabbarViewController.h"
#import "MedicineAlert+CoreDataProperties.h"
#import "MainSideMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DashboardViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetupView];
    _mainTableView.backgroundColor = [UIColor clearColor];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    if(_personDetailArray == nil)
        _personDetailArray = [[NSMutableArray alloc] init];
   
    if(_policyInfoDictionary == nil)
        _policyInfoDictionary =  [[NSMutableDictionary alloc] init];
    
    if(_lastTreatmentDictionary == nil)
        _lastTreatmentDictionary =  [[NSMutableDictionary alloc] init];
    
    if(_appointmentListArray == nil)
        _appointmentListArray = [[NSMutableArray alloc] init];
    
    if(_medicineAlertListArray == nil)
        _medicineAlertListArray = [[NSMutableArray alloc] init];
    
    if(_headerTitleArray == nil)
        _headerTitleArray = [[NSArray alloc] initWithObjects:@"",[Localization languageSelectedStringForKey:@"Upcoming Appointments"],[Localization languageSelectedStringForKey:@"Medicine Alert"],[Localization languageSelectedStringForKey:@"Last Treatment"],[Localization languageSelectedStringForKey:@"Policy"],nil];
    
    
    //NSArray *users = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:nil sortKey:nil ascending:NO] ;
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"login"])
    {
         //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND defaultpolicyholder == True",[self.personDetailDictionary valueForKey:@"emiratesid"]];

        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:self.personDetailDictionary] forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //_currentUser = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
        //NSLog(@"token %@",_currentUser.token);
    }
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    //[self callUserHistoryAPI];
    //[self callLastTreatmentHistoryAPI];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsData) name:@"update_alert_notification" object:nil];
        [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:[Localization languageSelectedStringForKey:@"Dashboard"]];
    
     [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:[Localization languageSelectedStringForKey:@"Search"]];
    
     [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[Localization languageSelectedStringForKey:@"Appointment"]];
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"update_profile_notification" object:nil];
     */
    // Do any additional setup after loading the view.
    
    NSString *adImagUrl = [NSString stringWithFormat:@"%@", [self.personDetailDictionary valueForKey:@"insurancecompanylogo"]];
[_dashboardBannerImage sd_setImageWithURL:[NSURL URLWithString:adImagUrl] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsData) name:@"update_alert_notification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"update_profile_notification" object:nil];
     */
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*[[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsData) name:@"update_alert_notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile:) name:@"update_profile_notification" object:nil];
     */
}

#pragma mark- Notification Methods-
-(void)updateNotificationsData
{
    [self getUpdatedAppointmentData];
    [self getUpdatedMedicineData];
}

-(void)updateProfile:(NSNotification *)notification
{
    //[self callLastTreatmentHistoryAPI];
    //[self callShowProfileAPI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //NSLog(@"child viewController count: %d",self.childViewControllers.count);
    // load data only if there is no active child controller.
    if(self.childViewControllers.count == 0) {
        [Utility trackGoogleAnalystic:@"Dashboard"];

        [self callLastTreatmentHistoryAPI];
        [self getUpdatedPolicyData];
        [self getUpdatedAppointmentData];
        [self getUpdatedMedicineData];
    }
}

-(void)initialSetupView
{
   // CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    else
    {
        topViewTopCons.constant = 20;
        _backgroundView.backgroundColor = [UIColor clearColor];
    }

    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
         [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         dashboardLbl.text =  [Localization languageSelectedStringForKey:@"Dashboard"];
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        dashboardLbl.text =  [Localization languageSelectedStringForKey:@"Dashboard"];
      [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        //   [revealController setFrontViewController:frontNavigationController];
    }
  
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
}


-(void)getUpdatedPolicyData
{
    NSString *defaultPolicy = @"True";
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
    
    NSArray *userArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO];
    
    [_policyInfoDictionary setValue:userArray  forKey:@"policyholder"];
}
-(void)getUpdatedAppointmentData
{
    [_appointmentListArray removeAllObjects];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    NSString *dateString = [dateFormatter1 stringFromDate:date];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[self.personDetailDictionary valueForKey:@"emiratesid"]];//  AND SELF.appointmentdate >= %@   //dateString
    
    [_appointmentListArray addObjectsFromArray:[[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:@"appointmentdate" ascending:YES] mutableCopy]];
    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < _appointmentListArray.count; i++)
    {
        AppointmentReminder *appointment = [_appointmentListArray objectAtIndex:i];
        NSDate *appointmentDate = [dateFormatter1 dateFromString:(NSString*) appointment.appointmentdate];
        if([appointmentDate compare: date] >= 0)
        {
            [filteredArray addObject:appointment];
        }
    }
    [_appointmentListArray removeAllObjects];
    [_appointmentListArray addObjectsFromArray:filteredArray];
    
    NSArray *arrKeys = [_appointmentListArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        [df setDateFormat:@"dd MMMM yyyy - hh:mm a"];
        NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"appointmentdate"]];
        NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"appointmentdate"]];
        return [d1 compare: d2];
    }];
    [_appointmentListArray removeAllObjects];
    [_appointmentListArray addObjectsFromArray:arrKeys];
    [_mainTableView reloadData];
}

-(void)getUpdatedMedicineData
{
    [_medicineAlertListArray removeAllObjects];
    NSDate *date = [NSDate date];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[self.personDetailDictionary valueForKey:@"emiratesid"]];
    [_medicineAlertListArray addObjectsFromArray:[[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"MedicineAlert" withPredicate:predicate sortKey:@"time" ascending:YES] mutableCopy]];
    
    NSDateFormatter *medicineDateFormatter = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [medicineDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [medicineDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    medicineDateFormatter.dateFormat = @"yyyy/MM/dd hh:mm a";

    NSMutableArray *medicinefilteredArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < _medicineAlertListArray.count; i++)
    {
        MedicineAlert *medicineAlert = [_medicineAlertListArray objectAtIndex:i];
        NSString *dateTime = [NSString stringWithFormat:@"%@ %@",(NSString*) medicineAlert.date, medicineAlert.time];
        
        NSDateFormatter *dateOnlyFormatter = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateOnlyFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateOnlyFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        dateOnlyFormatter.dateFormat = @"yyyy/MM/dd";
        NSDate *todayMedicineDate = [dateOnlyFormatter dateFromString:medicineAlert.date];
        NSDate *medicineDate = [medicineDateFormatter dateFromString:dateTime];
        NSDate *currentDate = [dateOnlyFormatter dateFromString:[dateOnlyFormatter stringFromDate:date]];
        if([medicineDate compare: date] >= 0 && todayMedicineDate == currentDate)
        {
            [medicinefilteredArray addObject:medicineAlert];
        }
        else if(![medicineAlert.repeat isEqualToString:@""])
        {
            
            medicineAlert = [Utility getMedicineAlertForUpcomingDate:medicineAlert];
            
            dateTime = [NSString stringWithFormat:@"%@ %@",(NSString*) medicineAlert.date, medicineAlert.time];
            
            todayMedicineDate = [dateOnlyFormatter dateFromString:medicineAlert.date];
            
            medicineDate = [medicineDateFormatter dateFromString:dateTime];
            
            if([medicineDate compare: date] >= 0 && todayMedicineDate == currentDate)
            {
                [medicinefilteredArray addObject:medicineAlert];
            }
        }
    }
    [_medicineAlertListArray removeAllObjects];
    [_medicineAlertListArray addObjectsFromArray:medicinefilteredArray];
    
    
    NSArray *arrKeys = [_medicineAlertListArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy/MM/dd"];
        
        NSString *firstDate = [NSString stringWithFormat:@"%@ %@",[obj1 valueForKey:@"date"],[obj1 valueForKey:@"time"]];
        NSString *secondDate = [NSString stringWithFormat:@"%@ %@",[obj2 valueForKey:@"date"],[obj2 valueForKey:@"time"]];
        
        NSDate *d1 = [medicineDateFormatter dateFromString:firstDate];
        NSDate *d2 = [medicineDateFormatter dateFromString:secondDate];
        return [d1 compare: d2];
    }];
    [_medicineAlertListArray removeAllObjects];
    [_medicineAlertListArray addObjectsFromArray:arrKeys];
    [_mainTableView reloadData];
    
}

#pragma mark Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return [_appointmentListArray count];
    }
    else if(section == 3)
    {
        if([_lastTreatmentDictionary allKeys].count > 0)
            return 1;
    }
    else if(section == 4)
    {
        NSArray *policyholder = [_policyInfoDictionary valueForKey:@"policyholder"];
        return policyholder.count;
    }
    else if(section == 2)
    {
        return _medicineAlertListArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 10;
    
    else if(section == 1)
    {
        if(_appointmentListArray.count > 0)
        {
            return 40;
        }
    }
    else if(section == 3)
    {
        if([_lastTreatmentDictionary allKeys].count > 0)
            return 40;
    }
    else if(section == 4)
    {
        NSArray *policyholder = [_policyInfoDictionary valueForKey:@"policyholder"];
        if(policyholder.count > 0)
            return 40;
    }
    else if(section == 2)
    {
        if(_medicineAlertListArray.count > 0)
        {
            return 40;
        }
    }
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   if(section == 4)
    {
        NSArray *policyholder = [_policyInfoDictionary valueForKey:@"policyholder"];
        if(policyholder.count > 0)
            return 5;
    }
    return 0.1;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row ==0)
    {
        static NSString *cellIdentifier  =@"EmiratesIDIdentifier";
        EmiratesIDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EmiratesIDTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        NSString *userEmiratesId = [userInfo valueForKey:@"emiratesid"];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        BOOL isShowingDependentProfile = ([userInfo valueForKey:@"dependentmemberid"] != nil);
        
        if(isShowingDependentProfile)
        {
            NSString *defaultPolicy = @"True";
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",userEmiratesId,defaultPolicy];
            
            User *user = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
            
            NSString *dependentId = [userInfo valueForKey:@"dependentmemberid"];
            Dependent *dependentUser = [self getDependentWithId:dependentId fromUser:user];
            if(dependentUser.emiratesid)
                cell.emiratesIdValueLabel.text = dependentUser.emiratesid;
            else
                cell.emiratesIdValueLabel.text =  [Localization languageSelectedStringForKey:@"Not Available"];
        }
        else
        {
            if(userEmiratesId)
                cell.emiratesIdValueLabel.text = userEmiratesId;
            else
                cell.emiratesIdValueLabel.text =  [Localization languageSelectedStringForKey:@"Not Available"];

        }
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 4)
    {
        static NSString *cellIdentifier  =@"policyDetailCellIdentifier";
        PolicyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PolicyDetailTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        User *defaultUser = [[_policyInfoDictionary valueForKey:@"policyholder"] objectAtIndex:indexPath.row];
        cell.policyNumberLabel.text = defaultUser.policydetail.policyno;
        cell.policyStatusLabel.text = defaultUser.policydetail.policystatus;
        //int policyTime = ([defaultUser.policydetail.policyperiod intValue])/365;
        
        /*if(policyTime == 0)
        {
            int months = ([defaultUser.policydetail.policyperiod intValue])/30;
            cell.policyPeriodLabel.text = [NSString stringWithFormat:@"%d Month",months];
        }
        else
        {
            cell.policyPeriodLabel.text = [NSString stringWithFormat:@"%d Year",policyTime];
        }*/
        cell.policyPeriodLabel.text = [NSString stringWithFormat:@"%@ to %@",defaultUser.policydetail.startdate,defaultUser.policydetail.enddate];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *cellIdentifier  =@"DashboardTableViewCellIdentifier";
        DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DashboardTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        dateFormatter1.dateFormat = @"MMMM dd yyyy hh:mma";
        NSDateFormatter *dateFormattertest = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        dateFormattertest.dateFormat = @"EEE dd MMMM yyyy HH:mm";
        NSDate *date = [dateFormatter1 dateFromString:[_lastTreatmentDictionary valueForKey:@"diagnosysdate"]];
        
        dateFormattertest.dateFormat = @"EEEE";
        NSString *stringDay = [dateFormattertest stringFromDate:date];
        cell.dayLabel.text = stringDay;
        
        dateFormattertest.dateFormat = @"dd MMM";
        NSString *stringMonth = [dateFormattertest stringFromDate:date];
        cell.monthLabel.text = stringMonth;
        
        dateFormattertest.dateFormat = @"yyyy";
        NSString *stringYear = [dateFormattertest stringFromDate:date];
        cell.yearLabel.text = stringYear;
        
        dateFormattertest.dateFormat = @"hh:mm a";
        NSString *stringTime = [dateFormattertest stringFromDate:date];
        cell.timeLabel.text = stringTime;
        
        cell.doctorNameLabel.text = [_lastTreatmentDictionary valueForKey:@"doctorname"];
        cell.hospitalNameLabel.text = [_lastTreatmentDictionary valueForKey:@"providername"];
        cell.addressLabel.text = [_lastTreatmentDictionary valueForKey:@"treatmentdetails"];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *cellIdentifier  =@"DashboardTableViewCellIdentifier";
        DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DashboardTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
         dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a";
         NSDateFormatter *dateFormattertest = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
         dateFormattertest.dateFormat = @"EEE dd MMMM yyyy HH:mm";
         NSDate *date = [dateFormatter1 dateFromString:[[_appointmentListArray objectAtIndex:indexPath.row] valueForKey:@"appointmentdate"]];
        
        dateFormattertest.dateFormat = @"EEEE";
         NSString *stringDay = [dateFormattertest stringFromDate:date];
        cell.dayLabel.text = stringDay;
        
        dateFormattertest.dateFormat = @"dd MMM";
        NSString *stringMonth = [dateFormattertest stringFromDate:date];
        cell.monthLabel.text = stringMonth;
        
        dateFormattertest.dateFormat = @"yyyy";
        NSString *stringYear = [dateFormattertest stringFromDate:date];
        cell.yearLabel.text = stringYear;
        
        dateFormattertest.dateFormat = @"hh:mm a";
        NSString *stringTime = [dateFormattertest stringFromDate:date];
        cell.timeLabel.text = stringTime;
        
        cell.doctorNameLabel.text = [[_appointmentListArray objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
        cell.hospitalNameLabel.text = [[_appointmentListArray objectAtIndex:indexPath.row] valueForKey:@"facility"];
        cell.addressLabel.text = [[_appointmentListArray objectAtIndex:indexPath.row] valueForKey:@"region"];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
    if(indexPath.section == 2)
    {
        static NSString *cellIdentifier  =@"DashboardTableViewCellIdentifier";
        DashboardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DashboardTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        dateFormatter1.dateFormat = @"yyyy/MM/dd";
        NSDateFormatter *dateFormattertest = [[NSDateFormatter alloc] init];
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
        }
        dateFormattertest.dateFormat = @"EEE dd MMMM yyyy";
        NSDate *date = [dateFormatter1 dateFromString:[[_medicineAlertListArray objectAtIndex:indexPath.row] valueForKey:@"date"]];
        
        dateFormattertest.dateFormat = @"EEEE";
        NSString *stringDay = [dateFormattertest stringFromDate:date];
        cell.dayLabel.text = stringDay;
        
        dateFormattertest.dateFormat = @"dd MMM";
        NSString *stringMonth = [dateFormattertest stringFromDate:date];
        cell.monthLabel.text = stringMonth;
        
        dateFormattertest.dateFormat = @"yyyy";
        NSString *stringYear = [dateFormattertest stringFromDate:date];
        cell.yearLabel.text = stringYear;
        
        NSString *stringTime = [[_medicineAlertListArray objectAtIndex:indexPath.row] valueForKey:@"time"];
        cell.timeLabel.text = stringTime;
        
        cell.doctorNameLabel.text = [Localization languageSelectedStringForKey:@"Need to take medicine"];
        cell.hospitalNameLabel.text = [NSString stringWithFormat:@"%@",[[_medicineAlertListArray objectAtIndex:indexPath.row] valueForKey:@"category"]];
        cell.addressLabel.text = [[_medicineAlertListArray objectAtIndex:indexPath.row] valueForKey:@"medicines"];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    
    return nil;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0)
        return 70;
    else if(indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3)
        return 120;
    
        return 101;
}*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"";
    }
    else if(section == 1 && _appointmentListArray.count > 0)
    {
        return @"Upcoming Appointments";
    }
    else if(section == 2 && _medicineAlertListArray.count > 0)
    {
        return @"Medicine Alerts";
    }
    else
    {
        return @"Policy";
    }
}*/

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string = nil;// [_headerTitleArray objectAtIndex:section];
    
    if(section == 0)
    {
        string = @"";
    }
    else if(section == 1 && _appointmentListArray.count > 0)
    {
        string = [Localization languageSelectedStringForKey:@"Upcoming Appointments"];
    }
    else if(section == 2 && _medicineAlertListArray.count > 0)
    {
        string = [Localization languageSelectedStringForKey:@"Medicine Alert"];
    }
    else if(section == 3 && [_lastTreatmentDictionary allKeys].count > 0)
    {
        string = [Localization languageSelectedStringForKey:@"Last Treatment"];
    }
    else if(section == 4)
    {
        string = [Localization languageSelectedStringForKey:@"Policy"];
    }
    else
        return nil;
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 1)
    {
        
        [self performSegueWithIdentifier:kAppointmentReminderIdentifier sender:indexPath];
        
        /*UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MyHistoryViewController *initialController = [storyBoard instantiateViewControllerWithIdentifier:kMyHistoryStoryBoardName];        //myHistory.view.bounds = self.view.bounds;
        [self displayContentController:initialController];
         */

    }
    
}

-(void)callShowProfileAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];

    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary setValue:[userInfoDic valueForKey:@"memberid"]
                      forKey:@"memberid"];
    }
    
    //[dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"principalmemberid"];

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ShowProfile"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.personDetailDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:NO showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     //[_personDetailArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"policyholder"]).count > 0)
                     {
                         NSString *defaultPolicy = @"True";
                         NSPredicate *predicate =
                         [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
                         NSArray *allPolicyHolderArray = [responseDictionary valueForKey:@"policyholder"];
                         NSArray *defaultArray = [allPolicyHolderArray filteredArrayUsingPredicate:predicate];
                         
                         [_policyInfoDictionary setValue:defaultArray  forKey:@"policyholder"];
                         [_mainTableView reloadData];
                     }
                     [self callLastTreatmentHistoryAPI];
                 }
                 else if([[responseDictionary valueForKey:@"status"] intValue] == 3)
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Session expired ,Please login"] block:^(int index)
                      {
                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          [appDelegate logout];
                      }];
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
    
    if ([segue.identifier isEqualToString:kAppointmentReminderIdentifier])
    {
        NSIndexPath *indexPath = sender;
        AppointmentReminderViewController *appointReminderViewController = segue.destinationViewController;
        appointReminderViewController.canDeleteAppointment = YES;
        appointReminderViewController.appointmentInfoDictionary = [_appointmentListArray objectAtIndex:indexPath.row];
    }
    
}


#pragma mark - API Called -
-(void)callUserHistoryAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"principalmemberid"];
    [dictionary setValue:[NSNumber numberWithInt:10000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"datafilter"];
    
    [dictionary setValue:@"" forKey:@"datefrom"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dictionary setValue:toDateString forKey:@"dateto"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetClaimHistory"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.personDetailDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     //[_personDetailArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"claims"]).count > 0)
                     {
                         [_policyInfoDictionary setValue:[responseDictionary valueForKey:@"claims"] forKey:@"claims"];
                         [_mainTableView reloadData];
                     }
                     [self callShowProfileAPI];
                 }
                 else if([[responseDictionary valueForKey:@"status"] intValue] == 3)
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Session expired ,Please login"] block:^(int index)
                      {
                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          [appDelegate logout];
                      }];
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


-(void)callLastTreatmentHistoryAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary setValue:[userInfoDic valueForKey:@"memberid"]
                      forKey:@"memberid"];
    }
    
    //[dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"principalmemberid"];
    [dictionary setValue:[NSNumber numberWithInt:10000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"datafilter"];
    [dictionary setValue:@"" forKey:@"datefrom"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dictionary setValue:toDateString forKey:@"dateto"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetTopClaimHistory"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.personDetailDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:NO showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [_lastTreatmentDictionary removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"claims"]).count > 0)
                     {
                         [_lastTreatmentDictionary setValuesForKeysWithDictionary:[[responseDictionary valueForKey:@"claims"] firstObject]];
                         [_mainTableView reloadData];
                     }
                 }
                 else if([[responseDictionary valueForKey:@"status"] intValue] == 3)
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Session expired ,Please login"] block:^(int index)
                      {
                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          [appDelegate logout];
                      }];
                 }
                 else
                 {
                     /*[Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                     }];*/
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


-(Dependent *)getDependentWithId:(NSString *)dependentId fromUser:(User *)userObj {
    for (Dependent *dependentUser in userObj.depend) {
        if([dependentUser.memberid isEqualToString:dependentId]) {
            return dependentUser;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
