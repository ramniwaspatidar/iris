//
//  MedicineAlertViewController.m
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "MedicineAlertViewController.h"
#import "UILabel+CustomLabel.h"
#import "RevealViewController.h"
#import "MedicineTableViewCell.h"
#import "Constant.h"
#import "UIButton+CustomButton.h"
#import "Utility.h"
#import "Localization.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "NotifyTableViewCell.h"
#import "SaveTableViewCell.h"
#import "DbManager.h"
#import "MedicineAlert+CoreDataProperties.h"
#import "FSCalendar.h"
#import "NotificationViewController.h"
#import "RepeatViewController.h"
#import "MainSideMenuViewController.h"
@import UserNotifications;

@interface MedicineAlertViewController ()<FSCalendarDataSource,FSCalendarDelegate,UIGestureRecognizerDelegate,sendRepeatedData>
{
    void * _KVOContext;
}
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateTimeFormat;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (assign, nonatomic) BOOL           lunar;
@property (strong, nonatomic) NSArray<NSString *> *datesShouldNotBeSelected;

@property (strong, nonatomic) NSMutableArray<NSString *> *repeatedDaysArray;


@property (strong, nonatomic) NSMutableArray<NSString *> *datesWithEvent;
@property (strong, nonatomic) NSCalendar *gregorianCalendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) NSMutableArray *mutArrDates;

@end

@implementation MedicineAlertViewController
#define MAX_LENGTH 40

- (void)viewDidLoad {
    [super viewDidLoad];
    _mutArrDates = [NSMutableArray array];

    [_saveButton setButtonCornerRadious];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"dd MMMM yyyy";
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a"; //@"EEEE, dd MMMM yyyy";
    
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    self.dateTimeFormatter.dateFormat = @"hh:mm a";
    
    self.saveDateTimeFormat = [[NSDateFormatter alloc] init];
    
    

    _placeholderArray = [[NSMutableArray alloc] initWithObjects:@"",[Localization languageSelectedStringForKey:@"Category"],[Localization languageSelectedStringForKey:@"Medicines"],[Localization languageSelectedStringForKey:@"Date"],[Localization languageSelectedStringForKey:@"Time"],[Localization languageSelectedStringForKey:@"Repeat"],@"", nil];
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"on",@"",@"",@"",@"",@"", nil];
    
    _measureArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Before Breakfast"],[Localization languageSelectedStringForKey:@"After Breakfast"],[Localization languageSelectedStringForKey:@"Before Lunch"],[Localization languageSelectedStringForKey:@"After Lunch"],[Localization languageSelectedStringForKey:@"Before Dinner"],[Localization languageSelectedStringForKey:@"After Dinner"], nil];
    
    [self initialSetupView];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_trackerDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [_trackerDatePicker setMaximumDate:[self maximumDateForDatePicker]];
    [_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
    
    self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Do any additional setup after loading the view.
    _datesWithEvent = [[NSMutableArray alloc] init];

    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendar.scope = FSCalendarScopeMonth;
    self.calendar.allowsMultipleSelection = YES;
    
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
    // Do any additional setup after loading the view.
    //[self.calendar selectDate:[NSDate date] scrollToDate:YES];
    
    //[self addPreviousNextButtons];
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    //[self callUserHistoryAPI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    // Do any additional setup after loading the view.
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (NSDate *)minimumDateForDatePicker
{
    NSDate *currentDate = [NSDate date];
    NSDate *datePlusOneMinute = [currentDate dateByAddingTimeInterval:120];
    return datePlusOneMinute;
}
- (NSDate *)maximumDateForDatePicker
{
    return [self.dateFormatter dateFromString:@"2040/05/31"];
}

#pragma mark Keyboard notification
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Medicine Alert"]];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];

          [doneButton setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          medicinLbl.text =  [Localization languageSelectedStringForKey:@"Medicine Alert"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
       // [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];

    }
    else{
       // [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];

        
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
          [doneButton setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        medicinLbl.text =  [Localization languageSelectedStringForKey:@"Medicine Alert"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //   [revealController setFrontViewController:frontNavigationController];
    }
   
    
}

#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _placeholderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier  =@"NotifyCellIdentifier";
        NotifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NotifyTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        if(cell.notifySwiftchButton)
        {
            [cell.notifySwiftchButton addTarget: self action: @selector(switchButtonAction:) forControlEvents:UIControlEventValueChanged];
            
            if([[_inputDataArray objectAtIndex:0] isEqualToString:@"on"])
            {
                [cell.notifySwiftchButton setOn:YES animated:NO];
            }
            else
            {
                [cell.notifySwiftchButton setOn:NO animated:NO];
            }
        }
        
        return cell;
    }
    else if(indexPath.row > 0 && indexPath.row < 6)
    {
        static NSString *cellIdentifier  =@"MedicineCellIdentifier";
        MedicineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MedicineTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.tag = indexPath.row;
        
        if(cell.inputTextField)
        {
            cell.inputTextField.tag = indexPath.row;
            cell.inputTextField.delegate = self;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        cell.calendarButtonWidthCons.constant = 0;
        cell.inputTextField.enabled = NO;

        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            cell.inputTextField.textAlignment  = NSTextAlignmentLeft;

            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            
            cell.inputTextField.textAlignment  = NSTextAlignmentRight;
            
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
        if(indexPath.row == 3 || indexPath.row == 4)
        {
            cell.calendarButtonWidthCons.constant = 30;
        }
        else if(indexPath.row != 1 && indexPath.row != 5)
        {
            cell.inputTextField.enabled = YES;
        }
        
        cell.titleLabel.text = [_placeholderArray objectAtIndex:indexPath.row];
        
        cell.inputTextField.placeholder = [_placeholderArray objectAtIndex:indexPath.row];
        
        if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
            cell.titleLabel.hidden = NO;
            if(indexPath.row == 3)
            {
                NSString *dateSt = [_inputDataArray objectAtIndex:indexPath.row];
                NSDate *dateObj = [self.dateFormatter dateFromString:dateSt];
                NSString *newDateString = [self.dateFormatter2 stringFromDate:dateObj];
                cell.inputTextField.text = newDateString;
            }
            
        }
        else
        {
            cell.inputTextField.text = @"";
            cell.titleLabel.hidden = YES;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
     
        if(indexPath.row == 5)
        {
           // cell.titleLabel.text = [_repeatedDaysArray componentsJoinedByString:@","];
            cell.inputTextField.text = [_repeatedDaysArray componentsJoinedByString:@","];
        }
        
        return cell;
    }
    
   
    
    if(indexPath.row == 6)
    {
        static NSString *cellIdentifier  =@"SaveCellIdentifier";
        SaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SaveTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        if(cell.saveButton)
        {
            [cell.saveButton addTarget:self
                                action:@selector(saveButtonAction:)
                               forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];

    if(indexPath.row == 3 || indexPath.row == 1 || indexPath.row == 4 ) // removed  by Abhishek indexPath.row == 5
    {
        
        previousButton.hidden = YES;
        nextButton.hidden = YES;
        [doneButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:195.0/255.0 alpha:1]];
        if(indexPath.row == 3 )
        {
            //[_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
            //[_trackerDatePicker reloadInputViews];

            [_inputDataArray replaceObjectAtIndex:4 withObject:@""];
            NSIndexPath* repeatIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [_mainTableView reloadRowsAtIndexPaths:@[repeatIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
        }
        if(indexPath.row == 4)
        {
            //[_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
            //[_trackerDatePicker reloadInputViews];

            [_trackerDatePicker setDatePickerMode:UIDatePickerModeTime];
        }
        
        if(indexPath.row == 1)
        {
            _pickerView.hidden = NO;
            _trackerDatePicker.hidden = YES;
            self.calendar.hidden = YES;
            [_pickerView reloadAllComponents];
        }
        else
        {
            _pickerView.hidden = YES;
            _trackerDatePicker.hidden = NO;
            self.calendar.hidden = YES;
            //[_trackerDatePicker reloadInputViews];
        }
//        if(indexPath.row == 5)
//        {
//            if([[_inputDataArray objectAtIndex:3] isEqualToString:@""] || [[_inputDataArray objectAtIndex:4] isEqualToString:@""])
//            {
//                [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"Please choose date & time first."] block:^(int index) {
//                    return;
//                }];
//                return;
//            }
//
//            //NSDate *firstDate = [self.dateFormatter dateFromString:[_inputDataArray objectAtIndex:3]];
//            //[self.calendar selectDate:firstDate scrollToDate:YES];
//
//            _pickerView.hidden = YES;
//            _trackerDatePicker.hidden = YES;
//            self.calendar.hidden = NO;
//            previousButton.hidden = NO;
//            nextButton.hidden = NO;
//            [doneButton setBackgroundColor:[UIColor clearColor]];
//
//        }
        activeCellIndexPath = indexPath;
        
        [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
            _pickerViewBottomCons.constant = -46;
        }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    
    if(indexPath.row == 5){

        if([[_inputDataArray objectAtIndex:3] isEqualToString:@""] || [[_inputDataArray objectAtIndex:4] isEqualToString:@""])
        {
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@.",[Localization languageSelectedStringForKey:@"Please choose date & time first"]] block:^(int index) {
                return;
            }];
            return;
        }
        
        RepeatViewController *repeatVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:kRepeatViewController];
        repeatVC.delegate = self;
        repeatVC.selectedDays = [_repeatedDaysArray mutableCopy];
        repeatVC.selectedDaysValues = [_datesWithEvent mutableCopy];
        [self.navigationController pushViewController:repeatVC animated:YES];
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 40;
    else if(indexPath.row == 6)
        return 150;
    return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kLipidStatesIdentifier])
    {
        // *bmiDetailViewController = segue.destinationViewController;
        //policyDetailViewController.policyDetails = sender;
    }
    
}

#pragma mark - Button Actions -


- (IBAction)doneBtn_Clicked:(id)sender
{
    NSString *dateString = nil;
    if(activeCellIndexPath.row == 3)
    {
        dateString = [self.dateFormatter stringFromDate:_trackerDatePicker.date];
    }
    if(activeCellIndexPath.row == 4)
    {
        dateString = [self.dateTimeFormatter stringFromDate:_trackerDatePicker.date];
    }
    if(activeCellIndexPath.row == 5)
    {
        for(int i = 0; i < _datesWithEvent.count; i++)
        {
            NSString *dateSt = [_datesWithEvent objectAtIndex:i];
            NSDate *dateObj = [self.dateFormatter dateFromString:dateSt];
            NSString *newDateString = [self.dateFormatter2 stringFromDate:dateObj];
            
            if(dateString == nil)
                dateString = [NSString stringWithFormat:@"%@",newDateString];
            else
                dateString = [dateString stringByAppendingFormat:@",%@",newDateString];

        }
        //dateString = [self.dateFormatter2 stringFromDate:_trackerDatePicker.date];
    }
    else
    {
        int selectedRangeRow = (int)[_pickerView selectedRowInComponent:0];
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:[_measureArray objectAtIndex:selectedRangeRow]];
    }
    
    if(dateString)
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
    
    [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    MedicineTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
    cell.titleLabel.hidden = NO;
    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -301;
    }
                     completion:^(BOOL finished)
     {
         //if(activeCellIndexPath.row == 3 || activeCellIndexPath.row == 4)
         {
             //[_trackerDatePicker setDate:[self minimumDateForDatePicker]];
         }
     }];
}


-(IBAction)saveButtonAction:(id)sender
{
    BOOL isEmptyField = [self validateForm];
    
    if(!isEmptyField)
    {
        NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        
        NSString *emiratesId = [userInfo valueForKey:@"emiratesid"];

        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"SELF.date == %@ AND SELF.emiratesid == %@ AND SELF.category == %@ AND SELF.time == %@ AND SELF.medicines == %@",[_inputDataArray objectAtIndex:3],emiratesId,[_inputDataArray objectAtIndex:1],[_inputDataArray objectAtIndex:4],[_inputDataArray objectAtIndex:2]];
        
        
        NSArray *medicineArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"MedicineAlert" withPredicate:predicate sortKey:nil ascending:NO];
        if(medicineArray.count > 0)
        {
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@",[Localization languageSelectedStringForKey:@"Medicine alert has already been set for same medicine with same data."]] block:^(int index) {
            }];
            return;
        }
        
        MedicineAlert *medicineAlert = nil;
        medicineAlert = [NSEntityDescription insertNewObjectForEntityForName:@"MedicineAlert"
                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        
        NSString *userMemberId = [userInfo valueForKey:@"memberid"];
        medicineAlert.emiratesid = emiratesId;
        medicineAlert.memberid = userMemberId;
        medicineAlert.notify = [_inputDataArray objectAtIndex:0];
        medicineAlert.category = [_inputDataArray objectAtIndex:1];
        medicineAlert.medicines = [_inputDataArray objectAtIndex:2];
        medicineAlert.date = [_inputDataArray objectAtIndex:3];
        medicineAlert.time = [_inputDataArray objectAtIndex:4];
        if(_repeatedDaysArray.count > 0)
            medicineAlert.repeat = [_repeatedDaysArray componentsJoinedByString:@","];
        else
            medicineAlert.repeat = @"";
        
        [[DbManager getSharedInstance] saveContext];
        
        // Schedule the notification
        if([medicineAlert.notify isEqualToString:@"on"])
        {
            if (@available(iOS 10.0, *)) {
                
                NSArray *firstNameArray = [[userInfo valueForKey:@"fullname"] componentsSeparatedByString:@" "];
                
                NSString *message = [NSString stringWithFormat:@"Hi %@, %@ %@. %@",[firstNameArray firstObject],[Localization languageSelectedStringForKey:@"it’s time for your MEDICINE"],[_inputDataArray objectAtIndex:2],[Localization languageSelectedStringForKey:@"Hope you feel better!"]];
                NSDateFormatter *alertDateFormatter = [[NSDateFormatter alloc] init];
                alertDateFormatter.dateFormat = @"yyyy/MM/dd hh:mm a";
                //[alertDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
              
                for(int i = 0; i < self.datesWithEvent.count + 1; i++)
                {
                    //for(int j = 0; j < 52; j++)
                    //{
                    NSString *dateString = nil;
                    if(i == 0)
                    {
                      dateString = [NSString stringWithFormat:@"%@ %@",[_inputDataArray objectAtIndex:3],[_inputDataArray objectAtIndex:4]];
                    }
                    else
                    {
                        dateString = [NSString stringWithFormat:@"%@ %@",[self.datesWithEvent objectAtIndex:i-1],[_inputDataArray objectAtIndex:4]];
                    }
          
                    NSDate *newDate = [alertDateFormatter dateFromString:dateString];
                    
                    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                    content.title = @"Medicine alert";
                    content.body = message;
                    content.sound = [UNNotificationSound defaultSound];
                    if(i != 0)
                    {
                        NSTimeInterval interval = 60 * 60 * 24 * 7;
                        [newDate  dateByAddingTimeInterval:interval];
                        dateString = [alertDateFormatter stringFromDate:newDate];
                    }
                    
                    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                                     components:NSCalendarUnitWeekday +
                                                     NSCalendarUnitHour + NSCalendarUnitMinute  fromDate:newDate];
           
                    
                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:YES];
                    
                    NSString *identifier = [NSString stringWithFormat:@"UYLLocalNotification_%@",dateString];
                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                        content:content trigger:trigger];
                    
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];

                    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        if (error != nil) {
                            NSLog(@"Something went wrong: %@",error);
                        }
                        else
                        {
                            /*UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (notifications) in
                                print("num of pending notifications \(notifications.count)")
                                
                            })*/
                            [[UNUserNotificationCenter currentNotificationCenter] getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                                NSLog(@"hello");
                                
                            }];
                            
                            NSLog(@"You got medicine notification.......... Open dashboard");
                            
                            
                        }
                    }];
                }
                //}
            } else {
                // Fallback on earlier versions
                
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                NSDate *now = [NSDate date];
                NSDate *dateToFire = [now dateByAddingTimeInterval:30];
                localNotification.fireDate = dateToFire;
                localNotification.alertBody = @"Medicine alert";
                //localNotification.alertAction = @"Show me the item";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        }
        [_inputDataArray replaceObjectAtIndex:0 withObject:@"on"];
        for(int i = 1; i< _inputDataArray.count; i++)
            [_inputDataArray replaceObjectAtIndex:i withObject:@""];
        [_mainTableView reloadData];
        
        [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Saved successfully"] block:^(int index)
         {
         }];
        [_repeatedDaysArray removeAllObjects];
        [_datesWithEvent removeAllObjects];
        [_trackerDatePicker setDate:[self minimumDateForDatePicker]];
    }
}


-(void)switchButtonAction:(id)sender
{
    UISwitch *switchBtn = sender;
    if(switchBtn.isOn)
        [_inputDataArray replaceObjectAtIndex:0 withObject:@"on"];
    else
        [_inputDataArray replaceObjectAtIndex:0 withObject:@"off"];

}

- (IBAction)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorianCalendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (IBAction)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorianCalendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

-(void)addPreviousNextButtons
{
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 109, 50, 25);
    previousButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-50, 109, 50, 25);
    nextButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
}



-(BOOL)validateForm
{
    BOOL isEmptyField = NO;
    NSString *fieldName = nil;
    for(int i = 0; i<_inputDataArray.count-1; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""])
        {
            isEmptyField = YES;
            fieldName = [_placeholderArray objectAtIndex:i];
            break;
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@ %@ %@.",[Localization languageSelectedStringForKey:@"Please fill"],fieldName, [Localization languageSelectedStringForKey:@"field"]] block:^(int index) {
        }];
    }
    return isEmptyField;
}

#pragma mark- UITextField Delegate methods -

-(void)textFieldDidChange:(UITextField *)textField
{
    MedicineTableViewCell *cell = (MedicineTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if(textField.text)
    {
        if(textField.text.length > 0)
            cell.titleLabel.hidden = NO;
        else
            cell.titleLabel.hidden = YES;
        
        [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    MedicineTableViewCell *cell = (MedicineTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    MedicineTableViewCell *cell = (MedicineTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //cell.titleLabel.hidden = YES;
    if(indexPath.row == 2)
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
    if(cell)
    {
        activeCellIndexPath = indexPath;
        for(id view in cell.contentView.subviews)
            if([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField1 = view;
                [textField1 becomeFirstResponder];
            }
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    
    if(textField.tag == 2)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_LENGTH){
            return NO;
        }
        
       
    }
    return YES;
}


#pragma mark- Picker View Methods-

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _measureArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _measureArray[row];
}


#pragma mark - move view when keyboard comes into play
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if(keyboardShown)
        return;
    
    keyboardShown = YES;
    
    // Get the keyboard size
    UIScrollView *tableView;
    if([_mainTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)_mainTableView.superview;
    else
        tableView = _mainTableView;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
    // Get the keyboard's animation details
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    // Determine how much overlap exists between tableView and the keyboard
    CGRect tableFrame = tableView.frame;
    CGFloat tableLowerYCoord = tableFrame.origin.y + tableFrame.size.height;
    keyboardOverlap = tableLowerYCoord - keyboardRect.origin.y;
    if(self.inputAccessoryView && keyboardOverlap>0)
    {
        CGFloat accessoryHeight = self.inputAccessoryView.frame.size.height;
        keyboardOverlap -= accessoryHeight;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
    }
    
    if(keyboardOverlap < 0)
        keyboardOverlap = 0;
    
    if(keyboardOverlap != 0)
    {
        tableFrame.size.height -= keyboardOverlap;
        
        NSTimeInterval delay = 0;
        if(keyboardRect.size.height)
        {
            delay = (1 - keyboardOverlap/keyboardRect.size.height)*animationDuration;
            animationDuration = animationDuration * keyboardOverlap/keyboardRect.size.height;
        }
        
        [UIView animateWithDuration:animationDuration delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             tableView.frame = tableFrame;
         }
                         completion:^(BOOL finished){ [self tableAnimationEnded:nil finished:nil contextInfo:nil]; }];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(!keyboardShown)
        return;
    
    keyboardShown = NO;
    
    UIScrollView *tableView;
    if([_mainTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)_mainTableView.superview;
    else
        tableView = _mainTableView;
    //if(self.inputAccessoryView)
    {
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    
    if(keyboardOverlap == 0)
        return;
    
    // Get the size & animation details of the keyboard
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect tableFrame = tableView.frame;
    tableFrame.size.height += keyboardOverlap;
    
    if(keyboardRect.size.height)
        animationDuration = animationDuration * keyboardOverlap/keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ tableView.frame = tableFrame; }
                     completion:nil];
}

- (void) tableAnimationEnded:(NSString*)animationID finished:(NSNumber *)finished contextInfo:(void *)context
{
    // Scroll to the active cell
    if(activeCellIndexPath)
    {
        [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
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
    /*BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendar.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
    */
    return NO;
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

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if([_datesWithEvent containsObject:[self.dateFormatter stringFromDate:date]])
    {
        [_datesWithEvent removeObject:[self.dateFormatter stringFromDate:date]];
    }
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);

    NSDate *firstDate = [self.dateFormatter dateFromString:[_inputDataArray objectAtIndex:3]];
    
    NSDate *today = [NSDate date]; // it will give you current date
  
    NSComparisonResult result;
    NSComparisonResult result1;
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    
    result = [today compare:date]; // comparing two dates
    result1 = [firstDate compare:date]; // comparing two dates

    if(result==NSOrderedAscending && result1 == NSOrderedAscending)
        NSLog(@"today is less");
    else if(result==NSOrderedDescending || result1 == NSOrderedDescending)
    {
        NSLog(@"newDate is less");
        [_calendar deselectDate:date];
        return;
    }
    else
    {
        [_calendar deselectDate:date];
        NSLog(@"Both dates are same");
        return;
    }
    
    [self.datesWithEvent addObject:[self.dateFormatter stringFromDate:date]];
    
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    //[self getSelectedDateFilteredArrayForDate:date];
}


- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    //_calendarHeightConstraint.constant = CGRectGetHeight(bounds);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDaysData:(NSArray *)data{
    _repeatedDaysArray = data.mutableCopy;
    NSIndexPath* repeatIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[repeatIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)getDatesFromDays:(NSArray*)data{
 
    for(int i = 0; i < data.count; i++ ){
      
        NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps1 = [[NSDateComponents alloc] init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponent = [calendar components:(NSWeekOfYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:_trackerDatePicker.date];
        [comps1 setYear:dateComponent.year];
        [comps1 setWeekOfYear:dateComponent.weekOfYear];
        [comps1 setWeekday:[[data objectAtIndex:i]integerValue]];
        NSDate *resultDate = [gregorian1 dateFromComponents:comps1];
        [self.datesWithEvent  addObject:[self.dateFormatter stringFromDate:resultDate]];
        
    }
    
    NSLog(@"%@",self.datesWithEvent);
}




@end

