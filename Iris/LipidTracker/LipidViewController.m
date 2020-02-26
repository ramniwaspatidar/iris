//
//  LipidViewController.m
//  Iris
//
//  Created by apptology on 20/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "LipidViewController.h"
#import "UILabel+CustomLabel.h"
#import "RevealViewController.h"
#import "LipidTableViewCell.h"
#import "LipidStatesViewController.h"
#import "Constant.h"
#import "UIButton+CustomButton.h"
#import "Utility.h"
#import "Localization.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "MainSideMenuViewController.h"
#import "LipidOptionalCell.h"
#import "NotificationViewController.h"
@interface LipidViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateTimeFormat;

@end

@implementation LipidViewController
#define MAX_LENGTH 8

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_calculateButton setButtonCornerRadious];
    [_saveButton setButtonCornerRadious];
    [viewStatsButton setButtonCornerRadious];
    
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
    //   [Localization languageSelectedStringForKey:@"Time"]
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:@"", [Localization languageSelectedStringForKey:@"Cholesterol"],[Localization languageSelectedStringForKey:@"LDL"],[Localization languageSelectedStringForKey:@"HDL"], [Localization languageSelectedStringForKey:@"Triglycerides"],[Localization languageSelectedStringForKey:@"Date"],[Localization languageSelectedStringForKey:@"Time"], nil];
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"mg/dL",@"",@"",@"",@"",@"",@"", nil];
    [self initialSetupView];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
    
    [_trackerDatePicker setMinimumDate:[self minimumDateForDatePicker]];
    [_trackerDatePicker setMaximumDate:[self maximumDateForDatePicker]];
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



#pragma mark Keyboard notification


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[Localization languageSelectedStringForKey:@"Lipid Tracker"]
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Lipid Tracker"]];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
         liquidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Tracker"];
        
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];

        
        [viewStatsButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"] forState:UIControlStateNormal];

        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
        
    }
    else{
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
          [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        liquidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Tracker"];
        
        [_saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];
        
        
        [viewStatsButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"] forState:UIControlStateNormal];
        
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    
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
        static NSString *cellIdentifier  =@"LipidOptionalCellIdentifier";
        LipidOptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LipidOptionalCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

        if(cell.mgOptionalButton)
        {
            [cell.mgOptionalButton addTarget:self
                       action:@selector(mgButtonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        }
        if(cell.mmOptionalButton)
        {
            [cell.mmOptionalButton addTarget:self
                                      action:@selector(mmButtonAction:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        if([[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@"mg/dL"])
        {
            cell.mgImageView.image = [UIImage imageNamed:@"check"];
            cell.mmImageView.image = [UIImage imageNamed:@"uncheck.png"];
        }
        else
        {
            cell.mgImageView.image = [UIImage imageNamed:@"uncheck.png"];
            cell.mmImageView.image = [UIImage imageNamed:@"check.png"];
        }
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *cellIdentifier  =@"LipidCellIdentifier";
    LipidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LipidTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.tag = indexPath.row;
    
    if(cell.inputTextField)
    {
        cell.inputTextField.delegate = self;
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    if(indexPath.row == 5 || indexPath.row == 6)
    {
        cell.calendarButtonWidthCons.constant = 30;
        cell.inputTextField.enabled = NO;
    }
    else
    {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
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

    if(indexPath.row == 5 || indexPath.row == 6)
    {
        
        if(indexPath.row == 5)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
        }
        else if(indexPath.row == 6)
        {
            [_trackerDatePicker setDatePickerMode:UIDatePickerModeTime];
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
    return 56;
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
    if(activeCellIndexPath.row == 5)
    {
        dateString = [self.dateFormatter1 stringFromDate:_trackerDatePicker.date];
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
        
        if(![[_inputDataArray objectAtIndex:6] isEqualToString:@""])
        {
            NSIndexPath *timeIndexPath = [NSIndexPath indexPathForRow:6 inSection:0];
            [_inputDataArray replaceObjectAtIndex:timeIndexPath.row withObject:@""];
            
            [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath,timeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
            [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];

        
        LipidTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;

    }
    else if(activeCellIndexPath.row == 6)
    {
        dateString = [self.dateTimeFormatter stringFromDate:_trackerDatePicker.date];
        [_inputDataArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
        [_mainTableView reloadRowsAtIndexPaths:@[activeCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        LipidTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
        cell.titleLabel.hidden = NO;
    }

    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
     completion:^(BOOL finished)
     {
     }];
}
- (IBAction)viewStatusButtonAction:(id)sender {
    
    [self performSegueWithIdentifier:kLipidStatesIdentifier sender:nil];
}


-(IBAction)saveButtonAction:(id)sender
{
    BOOL isEmptyField = [self validateForm];
    
    if(!isEmptyField)
    {
        [_trackerDatePicker setDate:[NSDate date]];
        [self callLipidSaveAPI];
    }
}

-(void)mmButtonAction:(id)sender
{
    [_inputDataArray replaceObjectAtIndex:0 withObject:@"mmol/L"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)mgButtonAction:(id)sender
{
    [_inputDataArray replaceObjectAtIndex:0 withObject:@"mg/dL"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(BOOL)validateForm
{
    BOOL isEmptyField = NO;
    NSString *message = nil;
    for(int i = 1; i<_inputDataArray.count; i++)
    {
        if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@""] || [[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
        {
            NSString *fieldName = [_placeholderArray objectAtIndex:i];
            if(i <= 4)
            {
                
                //[Localization languageSelectedStringForKey:@"Please enter"]
                if([[Utility trimString:[_inputDataArray objectAtIndex:i]] isEqualToString:@"0"])
                    message = [NSString stringWithFormat:@"%@ %@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString],[Localization languageSelectedStringForKey:@"greater than 0"]];
                else
                    message = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString]];
            }
            else
            {
                message = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString]];
            }
            isEmptyField = YES;
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

#pragma mark- UITextField Delegate methods -

-(void)textFieldDidChange:(UITextField *)textField
{
    LipidTableViewCell *cell = (LipidTableViewCell*)textField.superview.superview;
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
    
    LipidTableViewCell *cell = (LipidTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    LipidTableViewCell *cell = (LipidTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //cell.titleLabel.hidden = YES;
    if(indexPath.row == 4)
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
    
    
    if(textField.tag == 0 || textField.tag == 1)
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

-(void)callLipidSaveAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:@"" forKey:@"lipidtrackerid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[_inputDataArray objectAtIndex:0] forKey:@"lipidunit"];
    [dictionary setValue:[_inputDataArray objectAtIndex:1] forKey:@"cholestrol"];
    [dictionary setValue:[_inputDataArray objectAtIndex:2] forKey:@"ldl"];
    [dictionary setValue:[_inputDataArray objectAtIndex:3] forKey:@"hdl"];
    [dictionary setValue:[_inputDataArray objectAtIndex:4] forKey:@"triglycerides"];
    
    NSDate *date = [self.dateFormatter1 dateFromString:[_inputDataArray objectAtIndex:5]];
    self.saveDateTimeFormat.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateTimeFormat stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSDate *timeDate = [self.dateTimeFormatter dateFromString:[_inputDataArray objectAtIndex:6]];
    self.saveDateTimeFormat.dateFormat = @"HH:mm";
    NSString *timeString = [self.saveDateTimeFormat stringFromDate:timeDate];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"add" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveLipidTracker"];
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
                     [_inputDataArray replaceObjectAtIndex:0 withObject:@"mg/dL"];
                     for(int i = 1; i< _inputDataArray.count; i++)
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

#pragma mark - Other methods -

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
    //return [self.dateFormatter dateFromString:@"2030/05/31"];
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
