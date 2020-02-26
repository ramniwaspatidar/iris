//
//  BloodSugarTrackerViewController.m
//  Iris
//
//  Created by apptology on 23/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "BloodSugarTrackerViewController.h"
#import "Localization.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "BloodSugarTrackerTableViewCell.h"
#import "RevealViewController.h"
#import "UIButton+CustomButton.h"
#import "Constant.h"
#import "BloodSugarButtonTableViewCell.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "MainSideMenuViewController.h"
#define HourseInDay 24

@interface BloodSugarTrackerViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateTimeFormat;
@property (nonatomic,strong)NSDictionary *personDetailDictionary;


@end

@implementation BloodSugarTrackerViewController

#define MAX_LENGTH 8
#define MAX_NOTE_LENGTH 500

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[_saveButton setButtonCornerRadious];
    //[_viewStatusButton setButtonCornerRadious];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd MMMM yyyy"; //@"EEEE, dd MMMM yyyy";
    
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    self.dateTimeFormatter.dateFormat = @"hh:mm a";
    
    self.saveDateTimeFormat = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateTimeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.saveDateTimeFormat  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
    }else{
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateTimeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.saveDateTimeFormat  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
    }
    //_placeholderArray = [[NSMutableArray alloc] initWithObjects:@"Blood Sugar(mg/dl)",@"Measured",@"Date",@"Time",@"Tag",@"Notes",@"",@"HBA1C",@"Date",@"", nil];
    
//    [Localization languageSelectedStringForKey:@"Date"]
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Blood Sugar(mg/dl)"], [Localization languageSelectedStringForKey:@"Measured"],[Localization languageSelectedStringForKey:@"Date"],[Localization languageSelectedStringForKey:@"Time"],  [Localization languageSelectedStringForKey:@"Notes"],@"",@"HBA1C",[Localization languageSelectedStringForKey:@"Date"],@"", nil];
    
    [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
    [_trackerDatePicker setMaximumDate:[self maximumDateForDatePicker]];
    [_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
    
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    
    _measureArray = [[NSMutableArray alloc] initWithObjects:@"6am-10am",@"10am-2pm",@"2pm-6pm",@"6pm-10pm",@"10pm-2am",@"2am-6am", nil];
    //_measureInputArray = [[NSMutableArray alloc] initWithObjects:@"6-10",@"10-2",@"2-6",@"6-10",@"10-2",@"2-6", nil];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    //[self callUserHistoryAPI];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
   
    [self initialSetupView];

    // Do any additional setup after loading the view.
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bloddsLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Tracker"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
        
    }
    else{
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bloddsLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Tracker"];
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

- (NSDate *)minimumDateForDatePicker
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-10];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
}

- (NSDate *)maximumDateForDatePicker
{
    return [NSDate date];
    //return [self.dateFormatter dateFromString:@"2035/05/31"];
}

#pragma mark Keyboard notification
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [_trackerDatePicker setMaximumDate:[self maximumDateForDatePicker]];
    [_trackerDatePicker reloadInputViews];
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
    return _placeholderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 70;
    }
    return 60;
}*/

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 5 || indexPath.row == 8)
    {
        static NSString *cellIdentifier  =@"BloodSugarButtonCellIdentifier";
        BloodSugarButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BloodSugarButtonTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        if(cell.saveButton)
        {
            cell.saveButton.tag = indexPath.row;
            cell.viewStatesButton.tag = indexPath.row + 1;
            [cell.saveButton addTarget:self
                           action:@selector(saveAction:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            [cell.viewStatesButton addTarget:self
                                 action:@selector(viewStatesButtonAction:)
                       forControlEvents:UIControlEventTouchUpInside];
        }
        if(indexPath .row == 5)
        {
            cell.viewStatesWidthConstant.constant = (cell.buttonView.frame.size.width - 15)/2;
            cell.viewStateLeadingConstant.constant = 15.0;
            cell.lineLabel.hidden = NO;
        }
        else
        {
            cell.viewStatesWidthConstant.constant = 0.0;
            cell.viewStateLeadingConstant.constant = 5.0;
            cell.lineLabel.hidden = YES;
        }
        
        cell.backgroundColor = [UIColor clearColor];
    
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellIdentifier  =@"BloodSugarTrackerCellIdentifier";
    BloodSugarTrackerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BloodSugarTrackerTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(cell.inputTextField)
    {
        cell.inputTextField.tag = indexPath.row;
        cell.inputTextField.delegate = self;
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    if(indexPath.row == 0 || indexPath.row == 6)
    {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    else
    {
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 7)
    {
        if(indexPath.row == 1)
            [cell.calendarButton setImage:[UIImage imageNamed:@"downarrow.png"] forState:UIControlStateNormal];
        else
            [cell.calendarButton setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];

        cell.calendarButtonWidthCons.constant = 30;
        cell.inputTextField.enabled = NO;
    }
    else
    {
        cell.inputTextField.enabled = YES;
        cell.calendarButtonWidthCons.constant = 0;
    }
    
    cell.titleLabel.text = [_placeholderArray objectAtIndex:indexPath.row];
    cell.inputTextField.placeholder = [_placeholderArray objectAtIndex:indexPath.row];
    
    if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
        cell.titleLabel.hidden = NO;
    }
    else
    {
        cell.inputTextField.text = @"";
        cell.titleLabel.hidden = YES;
    }
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        cell.inputTextField.textAlignment  = NSTextAlignmentRight;
        
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 7)
    {
        
        if(indexPath.row == 2 || indexPath.row == 7)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
        }
        else if(indexPath.row == 3)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeTime];
        }
        
        if(indexPath.row == 1)
        {
            _pickerView.hidden = NO;
            _trackerDatePicker.hidden = YES;
            [_pickerView reloadAllComponents];
        }
        else
        {
            _pickerView.hidden = YES;
            _trackerDatePicker.hidden = NO;
            [_trackerDatePicker reloadInputViews];
        }
        activeCellIndexPath = indexPath;
        
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
    if(indexPath.row == 5)
    {
        return 90;
    }
    else if(indexPath.row == 8)
    {
        return 80;
    }
    return 55;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    // update sectionFooterView.text
    UIView *footerView = nil;
    
    if(section == 0)
    {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [savebutton addTarget:self
                   action:@selector(saveBloodSugarAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [savebutton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1]];
        [savebutton setTitle:@"Save" forState:UIControlStateNormal];
        savebutton.frame = CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width - 40, 40.0);
        [savebutton setButtonCornerRadious];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 1)];
        lineLabel.font = [UIFont systemFontOfSize:11];
        lineLabel.text = @"- - - - - - - - - - - - - - - - - - - - - - - - - - - - ";
        lineLabel.textColor = [UIColor lightGrayColor];

        [footerView addSubview:savebutton];
        [footerView addSubview:lineLabel];

    }
    else if(section == 1)
    {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
        footerView.backgroundColor = [UIColor clearColor];

        UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [savebutton addTarget:self
                   action:@selector(saveHIBBloodSugarAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [savebutton setTitle:@"Save" forState:UIControlStateNormal];
        savebutton.frame = CGRectMake(20.0, 0.0, [UIScreen mainScreen].bounds.size.width/2 - 30, 40.0);
        [savebutton setButtonCornerRadious];
        
        UIButton *viewStatesbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewStatesbutton addTarget:self
                       action:@selector(viewStatesButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        [viewStatesbutton setTitle:@"View States" forState:UIControlStateNormal];
        [savebutton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        viewStatesbutton.frame = CGRectMake(CGRectGetMaxX(savebutton.frame) + 20, 0.0, [UIScreen mainScreen].bounds.size.width/2 - 30, 40.0);
        [viewStatesbutton setButtonCornerRadious];
        
        [footerView addSubview:viewStatesbutton];
    }
    
    return footerView;
}
*/
-(void)saveAction:(id)sender
{
    UIButton *senderButton = sender;
    if(senderButton.tag == 5)
    {
        BOOL isEmptyField = [self validateSugarForm];
        
        if(!isEmptyField)
        {
            if([self checkTimeExitsInSlot])
            {
                [_trackerDatePicker setDate:[NSDate date]];
                [self saveBloodSugarAction];
            }
        }
    }
    else
    {
        BOOL isEmptyField = [self validateHBASugarForm];
        
        if(!isEmptyField)
        {
            [_trackerDatePicker setDate:[NSDate date]];
            [self saveHBABloodSugarAction];
        }
    }
}

-(BOOL)checkTimeExitsInSlot
{
    NSDate *timeDate = [self.dateTimeFormatter dateFromString:[_inputDataArray objectAtIndex:3]];
    self.saveDateTimeFormat.dateFormat = @"HH:mm";
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:timeDate];
    NSInteger currentHour = [components hour];
    //NSInteger currentMinute = [components minute];
    
    int index = (int)[_measureArray indexOfObject:[_inputDataArray objectAtIndex:1]];
    
    NSString *lowerTimeString = [[[_measureArray objectAtIndex:index] componentsSeparatedByString:@"-"] firstObject];
    
    int lowerTime = [self getSlotTime:lowerTimeString];
    
    NSString *upperTimeString = [[[_measureArray objectAtIndex:index] componentsSeparatedByString:@"-"] objectAtIndex:1];
    
    int upperTime = [self getSlotTime:upperTimeString];
    
    if([upperTimeString isEqualToString:@"2am"])
    {
        upperTime = HourseInDay + upperTime;
        if(currentHour >= 0 && currentHour < upperTime)
        {
            if(currentHour < 3)
                currentHour = currentHour + (NSInteger)HourseInDay;
        }
    }
    
    if (currentHour >= lowerTime && currentHour < upperTime)
    {
        // Do Something
        return YES;
    }
    else//[Localization languageSelectedStringForKey:@"Jan"]
    {
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@ %@",[Localization languageSelectedStringForKey:@"Time should be in between the selected slot"],[_measureArray objectAtIndex:index]] block:^(int index) {
        }];
        return NO;
    }
}

-(int)getSlotTime:(NSString *)timeSting
{
    int time = 0;
    if([timeSting containsString:@"am"])
    {
        timeSting = [timeSting stringByReplacingOccurrencesOfString:@"am" withString:@""];
        time = [timeSting intValue];
    }
    else
    {
        timeSting = [timeSting stringByReplacingOccurrencesOfString:@"pm" withString:@""];
        time = [timeSting intValue] + 12;
    }
    return time;
}

-(void)saveBloodSugarAction
{
    [self callSugarSaveAPI];
}

-(void)saveHBABloodSugarAction
{
    [self callHBASugarSaveAPI];
}


-(BOOL)validateSugarForm
{
    BOOL isEmptyField = NO;
    NSString *message = nil;
    for(int i = 0; i < 4; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""] || [[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
        {
            isEmptyField = YES;
            if(i == 0)
            {
                if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
                    message = [NSString stringWithFormat: @"%@", [Localization languageSelectedStringForKey:@"Please enter blood sugar greater than 0."]];
                else
                    message = [NSString stringWithFormat: @"%@", [Localization languageSelectedStringForKey:@"Please enter blood sugar."]];
                
            }
            else
            {
                message =  [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please select"],[[_placeholderArray objectAtIndex:i] lowercaseString]];
            }
            break;
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:[message lowercaseString] block:^(int index) {
        }];
    }
    return isEmptyField;
}

-(BOOL)validateHBASugarForm
{
    BOOL isEmptyField = NO;
    NSString *message = nil;
    for(int i = 6; i < 8; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""] || [[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
        {
            isEmptyField = YES;
            if(i == 6)
            {
                if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
                    message = [Localization languageSelectedStringForKey:@"Please enter HBA1C greater than 0."];
                else
                    message =  [Localization languageSelectedStringForKey:@"Please enter HBA1C."];

            }
            else
            {
                message =  [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please select"],[[_placeholderArray objectAtIndex:i] lowercaseString]];
            }
             break;
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:message block:^(int index) {
        }];
    }
    return isEmptyField;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return _measureArray[row];//(row < 3)?@"am":@"pm"];
}



#pragma mark - Button Action -

- (IBAction)doneBtn_Clicked:(id)sender
{
    NSString *dateString = nil;
    if(activeCellIndexPath.row == 2 || activeCellIndexPath.row == 7)
    {
        dateString = [self.dateFormatter1 stringFromDate:_trackerDatePicker.date];
        
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
        
        if(activeCellIndexPath.row == 2 && ![[_inputDataArray objectAtIndex:3] isEqualToString:@""])
        {
            NSIndexPath *timeIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [_inputDataArray replaceObjectAtIndex:timeIndexPath.row withObject:@""];
            
            [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath,timeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else
        {
            [_mainTableView reloadData];
            //[_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        BloodSugarTrackerTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }
    else if(activeCellIndexPath.row == 3)
    {
        dateString = [self.dateTimeFormatter stringFromDate:_trackerDatePicker.date];
        
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
        [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        BloodSugarTrackerTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }
    else if(activeCellIndexPath.row == 1)
    {
        int selectedRangeRow = (int)[_pickerView selectedRowInComponent:0];
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:[_measureArray objectAtIndex:selectedRangeRow]];
            [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        BloodSugarTrackerTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }
    
    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
                     completion:^(BOOL finished)
     {
         if(activeCellIndexPath.row == 1)
         {
             [_pickerView selectRow:0 inComponent:0 animated:NO];
         }
         else
         {
         }
     }];
}


- (IBAction)viewStatesButtonAction:(id)sender {
    
        [self performSegueWithIdentifier:kBloodSugarStatesIdentifier sender:nil];
    /*NSPredicate *predicate =
     [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@",[_appointmentInfoDictionary valueForKey:@"appointmentdate"],[_appointmentInfoDictionary valueForKey:@"emiratesid"]];
     
     AppointmentReminder *appointmentReminder = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
     
     
     [[DbManager getSharedInstance] deleteObject:appointmentReminder];
     [[DbManager getSharedInstance] saveContext];
     */
    //[self.navigationController popViewControllerAnimated:YES];
}



#pragma mark- UITextField Delegate methods

-(void)textFieldDidChange:(UITextField *)textField
{
    BloodSugarTrackerTableViewCell *cell = (BloodSugarTrackerTableViewCell*)textField.superview.superview;
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


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BloodSugarTrackerTableViewCell *cell = (BloodSugarTrackerTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //cell.titleLabel.hidden = YES;
    if(indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 6)
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
    
    if(textField.tag == 4)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_NOTE_LENGTH){
            return NO;
        }
    }
    else if(textField.tag == 0 || textField.tag == 6)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_LENGTH){
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    return YES;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    BloodSugarTrackerTableViewCell *cell = (BloodSugarTrackerTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kBloodSugarStatesIdentifier])
    {
        //BMIDetailViewController *bmiDetailViewController = segue.destinationViewController;
        //policyDetailViewController.policyDetails = sender;
    }
    
}


#pragma mark - Server API Call -

-(void)callSugarSaveAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:@"" forKey:@"bloodsugarid"];
    [dictionary setValue:[_inputDataArray objectAtIndex:0] forKey:@"bloodsugar"];
    int indexValue = 0;
    if([_measureArray containsObject:[_inputDataArray objectAtIndex:1]])
    {
        indexValue = (int)[_measureArray indexOfObject:[_inputDataArray objectAtIndex:1]];
        [dictionary setValue:[_measureArray objectAtIndex:indexValue] forKey:@"slot"];
    }
    
    
    NSDate *date = [self.dateFormatter1 dateFromString:[_inputDataArray objectAtIndex:2]];
    self.saveDateTimeFormat.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateTimeFormat stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSDate *timeDate = [self.dateTimeFormatter dateFromString:[_inputDataArray objectAtIndex:3]];
    self.saveDateTimeFormat.dateFormat = @"HH:mm";
    NSString *timeString = [self.saveDateTimeFormat stringFromDate:timeDate];
    [dictionary setValue:timeString forKey:@"time"];
    
    //[dictionary setValue:[_inputDataArray objectAtIndex:4] forKey:@"tag"];
    [dictionary setValue:@"test" forKey:@"tag"];
    [dictionary setValue:[_inputDataArray objectAtIndex:4] forKey:@"notes"];
    [dictionary setValue:@"add" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveBloodSugar"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                         //[_inputDataArray removeAllObjects];
                     for(int i = 0; i< 5; i++)
                         [_inputDataArray replaceObjectAtIndex:i withObject:@""];
                     
                         [_mainTableView reloadData];
                     
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Saved successfully"] block:^(int index)
                      {
                      }];
                     
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


-(void)callHBASugarSaveAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:@"" forKey:@"hba1cid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[_inputDataArray objectAtIndex:6] forKey:@"hba1c"];
    
    NSDate *date = [self.dateFormatter1 dateFromString:[_inputDataArray objectAtIndex:7]];
    self.saveDateTimeFormat.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateTimeFormat stringFromDate:date];
    
    [dictionary setValue:dateString forKey:@"date"];

    [dictionary setValue:@"add" forKey:@"mode"];

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveHBA1C"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                        for(int i = 6; i< 8; i++)
                            [_inputDataArray replaceObjectAtIndex:i withObject:@""];
                         [_mainTableView reloadData];
                     
                        [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Saved successfully"] block:^(int index)
                         {
                         }];
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

@end


