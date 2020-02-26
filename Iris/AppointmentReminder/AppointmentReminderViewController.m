//
//  AppointmentReminderViewController.m
//  Iris
//
//  Created by apptology on 08/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "AppointmentReminderViewController.h"
#import "AppointmentReminderTableViewCell.h"
#import "AppointmentReminder+CoreDataProperties.h"
#import "DbManager.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@import UserNotifications;


@interface AppointmentReminderViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;

@end

@implementation AppointmentReminderViewController
#define MAX_LENGTH 500

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          appointremLbl.text =  [Localization languageSelectedStringForKey:@"Appointment Reminder"];
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"Save"] forState:UIControlStateNormal];

        [_deleteButton setTitle:[Localization languageSelectedStringForKey:@"Delete"] forState:UIControlStateNormal];
  [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        appointremLbl.text =  [Localization languageSelectedStringForKey:@"Appointment Reminder"];
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"Save"] forState:UIControlStateNormal];
        
        [_deleteButton setTitle:[Localization languageSelectedStringForKey:@"Delete"] forState:UIControlStateNormal]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [_saveButton setButtonCornerRadious];
    [self setDeleteButtonCornerRadious];
    //[_deleteButton setButtonCornerRadious];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a"; //@"EEEE, dd MMMM yyyy";
    
    
//
//    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
//
//        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
//         [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
//
//
//        [_appointmentDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
//
//    }
//    else{
//        [_appointmentDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
//
//        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
//        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
//
//
//
//    }
    _titleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Doctor Name"],[Localization languageSelectedStringForKey:@"Name of Facility"],[Localization languageSelectedStringForKey:@"Location"],[Localization languageSelectedStringForKey:@"Appointment Date-Time"],[Localization languageSelectedStringForKey:@"Case Summary"], nil];
    
    
    [_appointmentDatePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [_appointmentDatePicker setMaximumDate:[self maximumDateForDatePicker]];
    [_appointmentDatePicker setMinimumDate:[self minimumDateForDatePicker]];

    _inputDataArray = [[NSMutableArray alloc] init];

    [_inputDataArray addObject:[_appointmentInfoDictionary valueForKey:@"doctorname"]];
    [_inputDataArray addObject:[_appointmentInfoDictionary valueForKey:@"facility"]];
    [_inputDataArray addObject:[_appointmentInfoDictionary valueForKey:@"region"]];
    if(!self.canDeleteAppointment)
    {
        [_inputDataArray addObject:@""];
        [_inputDataArray addObject:@""];
        deleteButtonTrailCons.constant = 0;
        deleteButtonWidthCons.constant = 0;}
        else{
        [_inputDataArray addObject:[_appointmentInfoDictionary valueForKey:@"appointmentdate"]];
        [_inputDataArray addObject:[_appointmentInfoDictionary valueForKey:@"casesummary"]];

        deleteButtonWidthCons.constant = (self.view.frame.size.width-60)/2;
        
        _previousDateString = [_appointmentInfoDictionary valueForKey:@"appointmentdate"];
    }
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];    // Do any additional setup after loading the view.
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}



#pragma mark Keyboard notification
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:@"Appointment Reminder"];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
//
//
//
//        [_appointmentDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
//
//    }
//    else{
//        [_appointmentDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
//
//
//
//    }
    [_appointmentDatePicker setMinimumDate:[self minimumDateForDatePicker]];
    
    [_appointmentDatePicker reloadInputViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"appointmentReminderCellIdentifier";
    AppointmentReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AppointmentReminderTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.tag = 1000 + indexPath.row;
    if(cell.inputTextField)
    {
        cell.inputTextField.delegate = self;
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)
    {
        cell.inputTextField.enabled = NO;
        cell.calendarButtonWidthCons.constant = 0;
    }
    else if(indexPath.row == 3)
    {
        cell.calendarButtonWidthCons.constant = 30;
        cell.inputTextField.enabled = NO;
        cell.inputTextField.placeholder = @"select";
    }
    else if(indexPath.row == 4)
    {
        cell.inputTextField.placeholder = [Localization languageSelectedStringForKey:@"Notes (maximum 500 characters)"];//@"Case Summary";
        cell.calendarButtonWidthCons.constant = 0;
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        cell.inputTextField.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.inputTextField.textAlignment = NSTextAlignmentRight;
    }
    cell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
        cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];

    if(indexPath.row == 1)
        return;
    if(indexPath.row == 3)
    {
        //[self showCalendar:nil];
        [_appointmentDatePicker setMinimumDate:[self minimumDateForDatePicker]];
        [_appointmentDatePicker reloadInputViews];
        [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
            _pickerViewBottomCons.constant = -46;
        }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if(indexPath.row == 4)
       // return 50;
        
    return 65;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changedDate:(id)sender
{
//     [_inputDataArray replaceObjectAtIndex:3 withObject:[self.dateFormatter stringFromDate:_appointmentDatePicker.date]];
//     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)doneBtn_Clicked:(id)sender
{
    NSString *dateString = [self.dateFormatter1 stringFromDate:_appointmentDatePicker.date];
    
   /* NSDateFormatter *dateFormattertest = [[NSDateFormatter alloc] init];
    dateFormattertest.dateFormat = @"dd/MM/yyyy HH:mm";
    NSDate *date = [self.dateFormatter1 dateFromString:dateString];
    NSString *stringDateTemp = [self.dateFormatter1 stringFromDate:date];
    */
    [_inputDataArray replaceObjectAtIndex:3 withObject:dateString];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
   /* if([currentPicker isEqualToString:@"facility"])
    {
        // [_inputDataArray replaceObjectAtIndex:(NSUInteger) withObject:<#(nonnull id)#>];
        // indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    }
    else if([currentPicker isEqualToString:@"speciality"])
    {
        [_inputDataArray replaceObjectAtIndex:2 withObject:[_specialityArray objectAtIndex:selectedRangeRow]];
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        
    }
    else if([currentPicker isEqualToString:@"gender"])
    {
        [_inputDataArray replaceObjectAtIndex:1 withObject:[[_genderArray objectAtIndex:selectedRangeRow] substringWithRange:NSMakeRange(0, 1)]];
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
    }
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    */
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
                     completion:^(BOOL finished)
     {
         [_appointmentDatePicker setDate:[self minimumDateForDatePicker]];
     }];
}


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)saveButtonAction:(id)sender
{
    BOOL isEmptyField = NO;
    NSString *fieldName = nil;
    for(int i = 0; i<_inputDataArray.count; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""])
        {
            isEmptyField = YES;
            fieldName = [_titleArray objectAtIndex:i];
            break;
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"Enter %@.",[fieldName lowercaseString]] block:^(int index) {
        }];
    }
    else
    {
        NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        NSString *emiratesId = [userInfo valueForKey:@"emiratesid"];
        
        AppointmentReminder *appointmentReminder = nil;
        if(self.canDeleteAppointment)
        {
            NSPredicate *predicate1 =
            [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@ AND SELF.doctorname == %@ AND SELF.casesummary == %@",[_inputDataArray objectAtIndex:3],emiratesId,[_appointmentInfoDictionary valueForKey:@"doctorname"],[_inputDataArray objectAtIndex:4]];
            
            
            NSArray *appointmentArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate1 sortKey:nil ascending:NO];
            if(appointmentArray.count > 0)
            {
                [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"You already have appointment with %@ on %@.",[_appointmentInfoDictionary valueForKey:@"doctorname"],[_inputDataArray objectAtIndex:3]] block:^(int index) {
                }];
                return;
            }
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@ AND SELF.doctorname == %@",[_appointmentInfoDictionary valueForKey:@"appointmentdate"],emiratesId,[_appointmentInfoDictionary valueForKey:@"doctorname"]];
            
            appointmentReminder = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
        }
        else
        {
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@ AND SELF.doctorname == %@",[_inputDataArray objectAtIndex:3],emiratesId,[_appointmentInfoDictionary valueForKey:@"doctorname"]];
            
            
            NSArray *appointmentArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO];
            if(appointmentArray.count > 0)
            {
                [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"You already have appointment with %@ on %@.",[_appointmentInfoDictionary valueForKey:@"doctorname"],[_inputDataArray objectAtIndex:3]] block:^(int index) {
                }];
                return;
                //[self showAlert];
            }
            
            appointmentReminder = [NSEntityDescription insertNewObjectForEntityForName:@"AppointmentReminder"
                                             inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        }
        
        
        NSString *userMemberId = [userInfo valueForKey:@"memberid"];
        appointmentReminder.emiratesid = emiratesId;
        appointmentReminder.memberid = userMemberId;
        appointmentReminder.doctorname = [_inputDataArray objectAtIndex:0];
        appointmentReminder.facility = [_inputDataArray objectAtIndex:1];
        appointmentReminder.region = [_inputDataArray objectAtIndex:2];
        appointmentReminder.appointmentdate = [_inputDataArray objectAtIndex:3];
        appointmentReminder.casesummary = [_inputDataArray objectAtIndex:4];
        
        appointmentReminder.lat = [_appointmentInfoDictionary valueForKey:@"lat"];
        appointmentReminder.lng = [_appointmentInfoDictionary valueForKey:@"lng"];
        
        if([_appointmentInfoDictionary valueForKey:@"emiratesid"])
            appointmentReminder.emiratesid = [_appointmentInfoDictionary valueForKey:@"emiratesid"];
        
        if(![[_appointmentInfoDictionary valueForKey:@"doctorlang"] isKindOfClass:[NSNull class]] && ![[_appointmentInfoDictionary valueForKey:@"doctorlang"] isEqualToString:@""])
            appointmentReminder.doctorlang = [_appointmentInfoDictionary valueForKey:@"doctorlang"];
        
        if(![[_appointmentInfoDictionary valueForKey:@"doctorgender"] isKindOfClass:[NSNull class]] && ![[_appointmentInfoDictionary valueForKey:@"doctorgender"] isEqualToString:@""])
            appointmentReminder.doctorgender = [_appointmentInfoDictionary valueForKey:@"doctorgender"];
        
        if(![[_appointmentInfoDictionary valueForKey:@"timings"] isKindOfClass:[NSNull class]] && ![[_appointmentInfoDictionary valueForKey:@"timings"] isEqualToString:@""])
            appointmentReminder.timings = [_appointmentInfoDictionary valueForKey:@"timings"];
        
        appointmentReminder.emirate = [_appointmentInfoDictionary valueForKey:@"emirate"];
        appointmentReminder.facilityid = [_appointmentInfoDictionary valueForKey:@"facilityid"];

        [[DbManager getSharedInstance] saveContext];
        
        
        // Schedule the notification
        
        
        
       
            if (@available(iOS 10.0, *)) {
                
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                
                if(self.canDeleteAppointment)
                {
                    NSString *oldrequestIdentifier = [NSString stringWithFormat:@"UYLLocalReminderNotification_%@_%@",appointmentReminder.doctorname,_previousDateString];
                    
                    [center removePendingNotificationRequestsWithIdentifiers:@[oldrequestIdentifier]];
                }
                
                NSString *dateString = [NSString stringWithFormat:@"%@",[_inputDataArray objectAtIndex:3]];
                
                NSDate *newDate = [self.dateFormatter1 dateFromString:dateString];
                
                
                NSDateFormatter *timeFormater= [[NSDateFormatter alloc] init];
                timeFormater.dateFormat = @"hh:mm a";
//
//                if ([MainSideMenuViewController isCurrentLanguageEnglish]){
//
//                    [timeFormater  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
//
//
//                }else{
//
//                    [timeFormater  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
//
//
//
//                }
                NSString *timeString = [timeFormater stringFromDate:newDate];
                
                NSArray *namesArray = [[userInfo valueForKey:@"fullname"] componentsSeparatedByString:@" "];
                
                //NSString *message = [NSString stringWithFormat:@"Hi %@,  you have an appointment at %@ tomorrow at %@ with %@. ",[namesArray firstObject],[_inputDataArray objectAtIndex:1],timeString,[_inputDataArray objectAtIndex:0]];
                
                NSString *message = [NSString stringWithFormat:@"Hi %@, you have an appointment at %@ with %@ %@",[namesArray firstObject],[_inputDataArray objectAtIndex:1],[_inputDataArray objectAtIndex:0], [_inputDataArray objectAtIndex:4]];
                
                    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                    content.title = @"Appointment Reminder";
                    content.body = message;
                    content.sound = [UNNotificationSound defaultSound];
                    
                    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                                     components:NSCalendarUnitYear +
                                                     NSCalendarUnitMonth + NSCalendarUnitDay +
                                                     NSCalendarUnitHour + NSCalendarUnitMinute + NSCalendarUnitSecond fromDate:newDate];
                    
                    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
                    
                    NSString *identifier = [NSString stringWithFormat:@"UYLLocalReminderNotification_%@_%@",[_inputDataArray objectAtIndex:0],dateString];
                    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                          content:content trigger:trigger];
                    
                
                
                    
                    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        if (error != nil) {
                            NSLog(@"Something went wrong: %@",error);
                        }
                        else
                        {
                            NSLog(@"You got appointment notification.......... Open dashboard");
                            
//                            UITabBarController *tabBarController = (UITabBarController *)self.navigationController.viewControllers.firstObject;
//                            tabBarController.selectedIndex = 0;
                            
                        }
                    }];
                
            } else {
                // Fallback on earlier versions
                
                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                NSDate *now = [NSDate date];
                NSDate *dateToFire = [now dateByAddingTimeInterval:30];
                localNotification.fireDate = dateToFire;
                localNotification.alertBody = [Localization languageSelectedStringForKey:@"Reminder Alert"];
                //localNotification.alertAction = @"Show me the item";
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
                
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        
        [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Appointment Saved"] block:^(int index) {
            [self.navigationController popViewControllerAnimated:YES];
        }];

        
        
    }
}


-(void)showAlert
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"You have an appointment with same doctor ,do you want to proceed."]
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"OK"]
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    /** What we write here???????? **/
                                    NSLog(@"you pressed Yes, please button");
                                    
                                    // call method whatever u need
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"CANCEL"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   /** What we write here???????? **/
                                   NSLog(@"you pressed No, thanks button");
                                   // call method whatever u need
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)deleteButtonAction:(id)sender {
    
    NSDictionary *userInfo = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *emiratesId = [userInfo valueForKey:@"emiratesid"];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@",[_inputDataArray objectAtIndex:3],emiratesId];
    
    AppointmentReminder *appointmentReminder = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        

        NSString *requestIdentifier = [NSString stringWithFormat:@"UYLLocalReminderNotification_%@_%@",appointmentReminder.doctorname,_previousDateString];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                              content:nil trigger:nil];
        
        [center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
        
    } else {
        // Fallback on earlier versions
    }
    
    
    
    
   /* NSPredicate *userPredicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[_appointmentInfoDictionary valueForKey:@"emiratesid"]];
    
    User *user = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:userPredicate sortKey:nil ascending:NO] firstObject];
    [user removeAppointmentreminderObject:appointmentReminder];
    */
    [[DbManager getSharedInstance] deleteObject:appointmentReminder];
    [[DbManager getSharedInstance] saveContext];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSDate *)minimumDateForDatePicker
{
    NSDate *currentDate = [NSDate date];
    NSDate *datePlusOneMinute = [currentDate dateByAddingTimeInterval:120];
    return datePlusOneMinute;
}

- (NSDate *)maximumDateForDatePicker
{
    return [self.dateFormatter dateFromString:@"2030/05/31"];
}

-(void)setDeleteButtonCornerRadious
{
    _deleteButton.layer.cornerRadius = 5.0;
    _deleteButton.layer.borderWidth = 1.0;
    _deleteButton.layer.borderColor =  [[UIColor colorWithRed:209.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1] CGColor];
    _deleteButton.clipsToBounds = YES;
}

#pragma mark- UITextField Delegate methods

-(void)textFieldDidChange:(UITextField *)textField
{
    AppointmentReminderTableViewCell *cell = (AppointmentReminderTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if(textField.text)
    {
        [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    AppointmentReminderTableViewCell *cell = (AppointmentReminderTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if(indexPath.row == 2 || indexPath.row == 4)
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


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    AppointmentReminderTableViewCell *cell = (AppointmentReminderTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    NSUInteger newLength = [textField.text length] + [string length];
    
    if(newLength > MAX_LENGTH){
        return NO;
    }
    
    return YES;
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



@end
