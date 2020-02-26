//
//  BloodPressureTrackerViewController.m
//  Iris
//
//  Created by apptology on 22/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "BloodPressureTrackerViewController.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "BloodPressureTrackerCell.h"
#import "RevealViewController.h"
#import "UIButton+CustomButton.h"
#import "Constant.h"
#import "Localization.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "MainSideMenuViewController.h"
@interface BloodPressureTrackerViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateTimeFormat;
@property (nonatomic,strong)NSDictionary *personDetailDictionary;


@end

@implementation BloodPressureTrackerViewController
#define itemSize CGSizeMake(50,20)

#define MAX_LENGTH 8

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_saveButton setButtonCornerRadious];
    [_viewStatusButton setButtonCornerRadious];
    
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
//[Localization languageSelectedStringForKey:@"Time"]
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"SYS(mmHG)"],[Localization languageSelectedStringForKey:@"DIA(mmHG)"], [Localization languageSelectedStringForKey:@"Pulse(min)"],[Localization languageSelectedStringForKey:@"Date"],[Localization languageSelectedStringForKey:@"Time"], nil];
    
    [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
    [_trackerDatePicker setMaximumDate:[self maximumDateForDatePicker]];
    [_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
    
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",nil];

    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self initialSetupView];
 
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
        bloodPLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Tracker"];
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];
        [_viewStatusButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"] forState:UIControlStateNormal];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
        
    }
    else{
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];
        [_viewStatusButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
           bloodPLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Tracker"];
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    
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
    //return [self.dateFormatter dateFromString:@"2025/05/31"];
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

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"BloodPressureTrackerCellIdentifer";
    BloodPressureTrackerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BloodPressureTrackerCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(cell.inputTextField)
    {
        cell.inputTextField.delegate = self;
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)
    {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        cell.inputTextField.enabled = YES;
        cell.calendarButtonWidthCons.constant = 0;
    }
    else if(indexPath.row == 3 || indexPath.row == 4)
    {
        if(indexPath.row == 4)
            [cell.calendarButton setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        else
            [cell.calendarButton setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
        
        cell.calendarButtonWidthCons.constant = 30;
        cell.inputTextField.enabled = NO;
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

    if(indexPath.row == 3 || indexPath.row == 4)
    {
        if(indexPath.row == 3)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
        }
        else if(indexPath.row == 4)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeTime];
        }
        activeCellIndexPath = indexPath;
        [_trackerDatePicker reloadInputViews];
        
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
        return 55;
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


#pragma mark - Button Action -
- (IBAction)doneBtn_Clicked:(id)sender
{
    if(activeCellIndexPath.row == 3)
    {
        NSString *dateString = [self.dateFormatter1 stringFromDate:_trackerDatePicker.date];
        
        [_inputDataArray replaceObjectAtIndex:3 withObject:dateString];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        
        if(![[_inputDataArray objectAtIndex:4] isEqualToString:@""])
        {
            NSIndexPath *timeIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [_inputDataArray replaceObjectAtIndex:timeIndexPath.row withObject:@""];
            
            [_mainTableView reloadRowsAtIndexPaths:@[indexPath,timeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
           [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        BloodPressureTrackerCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }
    else if(activeCellIndexPath.row == 4)
    {
        
        NSString *dateString = [self.dateTimeFormatter stringFromDate:_trackerDatePicker.date];
        
        [_inputDataArray replaceObjectAtIndex:4 withObject:dateString];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        BloodPressureTrackerCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }
    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
                     completion:^(BOOL finished)
     {
     }];
}



-(IBAction)saveButtonAction:(id)sender
{
    BOOL isEmptyField = NO;
    NSString *message = nil;
    for(int i = 0; i<_inputDataArray.count; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""] || [[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
        {
            NSString *fieldName = [_placeholderArray objectAtIndex:i];
            isEmptyField = YES;
            if(i < 3)
            {
                fieldName = [[fieldName componentsSeparatedByString:@"("] firstObject];
                
                if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
                    //[Localization languageSelectedStringForKey:@"DIA should be less than SYS."]
                    message = [NSString stringWithFormat:@"%@ %@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString],[Localization languageSelectedStringForKey:@"greater than 0"]];
                else
                    message = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString]];
            }
            else
            {
                message = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please select"],fieldName];
            }
            break;
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:message block:^(int index) {
        }];
    }
    else
    {
        NSInteger sysValue = [[_inputDataArray objectAtIndex:0] integerValue];
        NSInteger diaValue = [[_inputDataArray objectAtIndex:1] integerValue];
        if(sysValue > diaValue) {
            [_trackerDatePicker setDate:[NSDate date]];
            [self callSugarSaveAPI];
        } else {
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat: [Localization languageSelectedStringForKey:@"DIA should be less than SYS."]] block:^(int index) {
            }];
        }
    }
}


- (IBAction)viewStatesButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:kBloodPressureStatesIdentifier sender:nil];
    
    /*NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.appointmentdate == %@ AND SELF.emiratesid == %@",[_appointmentInfoDictionary valueForKey:@"appointmentdate"],[_appointmentInfoDictionary valueForKey:@"emiratesid"]];
    
    AppointmentReminder *appointmentReminder = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    
    
    [[DbManager getSharedInstance] deleteObject:appointmentReminder];
    [[DbManager getSharedInstance] saveContext];
    */
     //[self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kBloodPressureStatesIdentifier])
    {
        //BMIDetailViewController *bmiDetailViewController = segue.destinationViewController;
        //policyDetailViewController.policyDetails = sender;
    }
    
}


#pragma mark- UITextField Delegate methods

-(void)textFieldDidChange:(UITextField *)textField
{
    BloodPressureTrackerCell *cell = (BloodPressureTrackerCell*)textField.superview.superview;
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
    BloodPressureTrackerCell *cell = (BloodPressureTrackerCell*)textField.superview.superview;
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


-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    BloodPressureTrackerCell *cell = (BloodPressureTrackerCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    
    if(textField.tag == 0 || textField.tag == 1 || textField.tag == 2)
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


#pragma mark - Server API Call -

-(void)callSugarSaveAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:@"" forKey:@"bloodressureid"];
    [dictionary setValue:[_inputDataArray objectAtIndex:0] forKey:@"systolic"];
    [dictionary setValue:[_inputDataArray objectAtIndex:1] forKey:@"diastolic"];
    [dictionary setValue:[_inputDataArray objectAtIndex:2] forKey:@"pulse"];
    NSDate *date = [self.dateFormatter1 dateFromString:[_inputDataArray objectAtIndex:3]];
    self.saveDateTimeFormat.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateTimeFormat stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSDate *timeDate = [self.dateTimeFormatter dateFromString:[_inputDataArray objectAtIndex:4]];
    self.saveDateTimeFormat.dateFormat = @"HH:mm";
    NSString *timeString = [self.saveDateTimeFormat stringFromDate:timeDate];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"add" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveBloodPressure"];
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
                     for(int i = 0; i < _inputDataArray.count; i++)
                         [_inputDataArray replaceObjectAtIndex:i withObject:@""];
                     [_mainTableView reloadData];
                     //[Localization languageSelectedStringForKey:@"Saved successfully"]
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

