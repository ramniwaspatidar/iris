//
//  AppointmentViewController.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "AppointmentViewController.h"
#import "RevealViewController.h"
#import "FSCalendar.h"
#import "AppointmentEventCell.h"
#import "AppointmentReminder+CoreDataProperties.h"
#import "DbManager.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "Constant.h"
#import "AppointmentReminderViewController.h"
#import "NotificationViewController.h"
#import "SearchViewController.h"
#import <Google/Analytics.h>
#import "MainSideMenuViewController.h"
   #import "Localization.h"
@interface AppointmentViewController ()<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate>
{
    void * _KVOContext;
}
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *eventDateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;

@property (assign, nonatomic) BOOL           lunar;

@property (strong, nonatomic) NSArray<NSString *> *datesShouldNotBeSelected;
@property (strong, nonatomic) NSMutableArray<NSString *> *datesWithEvent;

@property (strong, nonatomic) NSCalendar *gregorianCalendar;

@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;


@end

@implementation AppointmentViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy/MM/dd";
        
        self.eventDateFormatter = [[NSDateFormatter alloc] init];
        self.eventDateFormatter.dateFormat = @"dd MMMM yyyy - hh:mm a";
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        //    self.calendar = NSCalendarIdentifierIndian;

           
            
        }else{
            [self.calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
           // self.calendar.identifier = NSCalendarIdentifierIslamic;

           
            
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    
    // Calendar Setting
        self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //self.calendar.identifier = NSCalendarIdentifierIndian;
        
      
        
       // self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicCivil];

        
        
    
    _allAppointmentsArray = [[NSMutableArray alloc] init];
    _selectedDateAppointmentArray = [[NSMutableArray alloc] init];
    _datesWithEvent = [[NSMutableArray alloc] init];

    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeMonth;
    //calendar.allowsMultipleSelection = YES;

    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    // Do any additional setup after loading the view.
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98;
    self.tableView.clipsToBounds = YES;
    [self addPreviousNextButtons];
    [self setAddAppointmentButtonView];
    [self initLocation];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

-(void)initLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}
#pragma mark- View Load -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"My Appointment"];
    
    [self updateDataOnNotification:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataOnNotification:) name:@"update_alert_notification" object:nil];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateDataOnNotification:(NSNotification *)notification
{
    [self setAppointmentsList];
    [self setEventDateList];
    
    [self getSelectedDateFilteredArrayForDate:self.calendar.selectedDate];
    
    [self.calendar reloadData];
    [self.tableView reloadData];
}

-(void)setAddAppointmentButtonView
{
    _addAppointmentButton.layer.cornerRadius = 5.0;
    _addAppointmentButton.layer.borderWidth = 1.0;
    _addAppointmentButton.layer.borderColor =  [[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    _addAppointmentButton.clipsToBounds = YES;
}


-(void)mapDirectionButtonAction:(id)sender
{
    UIButton *directionBtn = sender;
    CLLocationCoordinate2D  destinationPoint;
    NSDictionary *location = [_selectedDateAppointmentArray objectAtIndex:directionBtn.tag];
    
    destinationPoint.latitude  = [[location valueForKey:@"lat"] doubleValue];
    destinationPoint.longitude = [[location valueForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D sourcePCoordinate;
    
    if(self.locationManager.location.coordinate.latitude)
        sourcePCoordinate = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    else
        sourcePCoordinate = CLLocationCoordinate2DMake(25.23, 55.31);
    
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@+%@", sourcePCoordinate.latitude, sourcePCoordinate.longitude, [location valueForKey:@"facility"],[location valueForKey:@"emirate"]];
    
    googleMapUrlString = [googleMapUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}

-(void)addPreviousNextButtons
{
    float yAxis = 109;
    if([Utility IsiPhoneX])
    {
        yAxis = 89;
    }
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, yAxis, 50, 25);
    previousButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-50, yAxis, 50, 25);
    nextButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
}

-(void)setAppointmentsList
{
    [_allAppointmentsArray removeAllObjects];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    
   
    dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a";
    NSString *dateString = [dateFormatter1 stringFromDate:date];

    NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *emiratesId = [userInfo valueForKey:@"emiratesid"];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",emiratesId];
    [_allAppointmentsArray addObjectsFromArray:[[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO] mutableCopy]];
    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < _allAppointmentsArray.count; i++)
    {
        AppointmentReminder *appointment = [_allAppointmentsArray objectAtIndex:i];
        NSDate *appointmentDate = [dateFormatter1 dateFromString:(NSString*) appointment.appointmentdate];
        //if([appointmentDate compare: date] >= 0)
        {
            [filteredArray addObject:appointment];
        }
    }
    [_allAppointmentsArray removeAllObjects];
    [_allAppointmentsArray addObjectsFromArray:filteredArray];
    
    NSArray *arrKeys = [_allAppointmentsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
      
        [df setDateFormat:@"dd MMMM yyyy - hh:mm a"];
        NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"appointmentdate"]];
        NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"appointmentdate"]];
        if (d1 == nil || d2 == nil) {
            return false;
        }
        return [d1 compare: d2];
    }];
    [_allAppointmentsArray removeAllObjects];
    [_allAppointmentsArray addObjectsFromArray:arrKeys];
    
    [self.tableView reloadData];
}


-(void)setEventDateList
{
    [self.datesWithEvent removeAllObjects];
    for(int i = 0; i< _allAppointmentsArray.count; i++)
    {
        AppointmentReminder *appointmentReminder = [_allAppointmentsArray objectAtIndex:i];
        NSString *appointmentDate = appointmentReminder.appointmentdate;
        NSDate *date = [self.eventDateFormatter dateFromString:appointmentDate];
        if (date == nil|| [date  isEqual: @"<nil>"]) {
            [self.eventDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

            date = [self.eventDateFormatter dateFromString:appointmentDate];
        }
       
        if (date == nil || [date  isEqual: @"<nil>"] || [date  isEqual: @"nil"]) {

     
        }else{
            NSString *dateString = [self.dateFormatter stringFromDate:date];

            if(![self.datesWithEvent containsObject:dateString])
                [self.datesWithEvent addObject:dateString];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
         myappointLbl.text =  [Localization languageSelectedStringForKey:@"My Appointment"];
        
        [addApointBtn setTitle:[Localization languageSelectedStringForKey:@"Add Appointment"] forState:UIControlStateNormal];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        myappointLbl.text =  [Localization languageSelectedStringForKey:@"My Appointment"];
        
        [addApointBtn setTitle:[Localization languageSelectedStringForKey:@"Add Appointment"] forState:UIControlStateNormal];

        [_sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
}

#pragma mark - Button Actions -

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorianCalendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorianCalendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    //notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)addAppointmentButtonAction:(id)sender {
    UITabBarController *tabBarController = (UITabBarController *)self.navigationController.viewControllers.firstObject;
    tabBarController.selectedIndex = 1;
    
    UIViewController *selectedViewController = [tabBarController.viewControllers objectAtIndex:1];
    
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    if(selectedViewController.childViewControllers.count > 0)
    {
        for(UIViewController *child in selectedViewController.childViewControllers)
        {
            [self hideContentController:child];
        }
        [selectedViewController viewDidAppear:YES];
    }
    if(((SearchViewController *)selectedViewController).isLocationLoaded)
        [(SearchViewController *)selectedViewController removeFilter];
}

- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin)
    {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}


#pragma mark - FSCalendarDataSource

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return [self.gregorianCalendar isDateInToday:date] ? nil : nil;
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    if (!_lunar) {
        return nil;
    }
    return [self.dateFormatter stringFromDate:date];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    if ([self.datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return 1;
    }
    return 0;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2017/01/01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2025/05/31"];
}

#pragma mark - FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    BOOL shouldSelect = ![_datesShouldNotBeSelected containsObject:[self.dateFormatter stringFromDate:date]];
    if (!shouldSelect) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FSCalendar" message:[NSString stringWithFormat:@"%@ %@  %@",[Localization languageSelectedStringForKey:@"FSCalendar delegate forbid"],[self.dateFormatter stringFromDate:date],[Localization languageSelectedStringForKey:@"to be selected"]] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"OK"] style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSLog(@"Should select date %@",[self.dateFormatter stringFromDate:date]);
    }
    return shouldSelect;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    [self getSelectedDateFilteredArrayForDate:date];
}

-(void)getSelectedDateFilteredArrayForDate:(NSDate *)date
{
    [_selectedDateAppointmentArray removeAllObjects];
    
    if([self.datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]])
    {
        for(int i = 0; i< _allAppointmentsArray.count; i++)
        {
            AppointmentReminder *appointmentReminder = [_allAppointmentsArray objectAtIndex:i];
            NSString *appointmentDateString = appointmentReminder.appointmentdate;
            NSDate *appointmentDate = [self.eventDateFormatter dateFromString:appointmentDateString];
            NSString *dateString = [self.dateFormatter stringFromDate:appointmentDate];
            
            if([dateString isEqualToString:[self.dateFormatter stringFromDate:date]])
                [_selectedDateAppointmentArray addObject:appointmentReminder];
        }
    }
    [self.tableView reloadData];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    _calendarHeightConstraint.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return CGPointMake(0, -2);
    }
    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return CGPointMake(0, -10);
    }
    return CGPointZero;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return @[appearance.eventDefaultColor];
    }
    if ([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]]) {
        return @[[UIColor whiteColor]];
    }
    return nil;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectedDateAppointmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"AppointmentEventCellIdentifier";
    AppointmentEventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AppointmentEventCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.doctorNameLabel.text = [[_selectedDateAppointmentArray objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
    cell.hospitalNameLabel.text = [[_selectedDateAppointmentArray objectAtIndex:indexPath.row] valueForKey:@"facility"];
    cell.addressLabel.text = [[_selectedDateAppointmentArray objectAtIndex:indexPath.row] valueForKey:@"region"];
    cell.dateTimeLabel.text = [[_selectedDateAppointmentArray objectAtIndex:indexPath.row] valueForKey:@"appointmentdate"];

    if(cell.mapDirectionButton)
    {
        cell.mapDirectionButton.tag = indexPath.row;
        [cell.mapDirectionButton addTarget:self
                   action:@selector(mapDirectionButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppointmentReminder *appointmentReminder = [_selectedDateAppointmentArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:kAppointmentReminderIdentifier sender:indexPath];
    
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:kAppointmentReminderIdentifier])
    {
        NSIndexPath *indexPath = sender;
        AppointmentReminderViewController *appointReminderViewController = segue.destinationViewController;
        appointReminderViewController.canDeleteAppointment = YES;
        appointReminderViewController.appointmentInfoDictionary = [_selectedDateAppointmentArray objectAtIndex:indexPath.row];
    }
    
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
