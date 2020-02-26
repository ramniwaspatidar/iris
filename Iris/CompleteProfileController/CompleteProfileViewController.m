//
//  CompleteProfileViewController.m
//  Iris
//
//  Created by apptology on 30/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "CompleteProfileViewController.h"
#import "CompleteProfileTableViewCell.h"
#import "ConnectionManager.h"
#import "Constant.h"
#import "Utility.h"
#import "TabbarViewController.h"
#import "DashboardViewController.h"
#import "RevealViewController.h"
#import "MainSideMenuViewController.h"
#import "AppDelegate.h"
#import "User+CoreDataClass.h"
#import "DbManager.h"
#import "Localization.h"

#import "PolicyDetails+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "Dependent+CoreDataProperties.h"
#import "UIButton+CustomButton.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "MainSideMenuViewController.h"
@interface CompleteProfileViewController ()

@end

@implementation CompleteProfileViewController
#define MAX_LENGTH 15

#pragma mark - view Loading -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    
    [_submitButton setButtonCornerRadious];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         completPLbl.text =  [Localization languageSelectedStringForKey:@"Complete Profile"];
        
        [_submitButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];
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
        completPLbl.text =  [Localization languageSelectedStringForKey:@"Complete Profile"];
        
        [_submitButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    currentPicker = @"defaultpolicy";
    policyArray  = [[NSMutableArray alloc] init];
    for(int i = 0; i< self.responseArray.count; i++)
    {
        [policyArray addObject:[self.responseArray objectAtIndex:i]];
    }
   
    [self setDataInDictionary];
    
    genderArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Male"],[Localization languageSelectedStringForKey:@"Female"],@"Other", nil];
    countryArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"India"],[Localization languageSelectedStringForKey:@"US"],[Localization languageSelectedStringForKey:@"Dubai"], nil];
    
    _profileOptionsArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Full Name"],[Localization languageSelectedStringForKey:@"Email"],[Localization languageSelectedStringForKey:@"User Name"],[Localization languageSelectedStringForKey:@"Password"], [Localization languageSelectedStringForKey:@"Confirm Password"], [Localization languageSelectedStringForKey:@"Gender"],[Localization languageSelectedStringForKey:@"Nationality"],[Localization languageSelectedStringForKey:@"Residence Location"], nil];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if(policyArray.count > 1)
    {
        [self openChoosePolicyPopup];
    }
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    //_mainTableView.separatorInset.right = _mainTableView.separatorInset.left;
    // Do any additional setup after loading the view.
}

-(void)openChoosePolicyPopup
{
    [self.view endEditing:YES];
    [_pickerView reloadAllComponents];
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _rangeViewBottomConstraint.constant = -46;
    }
                     completion:^(BOOL finished)
     {
         
     }];
}

-(void)setDataInDictionary
{
    [_inputDictionary removeAllObjects];
    _inputDictionary = nil;
    
     _inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"username",@"",@"password",@"",@"confirmpassword",[self.responseDictionary valueForKey:@"fullname"],@"fullname",[self.responseDictionary valueForKey:@"email"],@"email",[self.responseDictionary valueForKey:@"nationality"],@"nationality",[self.responseDictionary valueForKey:@"gender"],@"gender",[self.responseDictionary valueForKey:@"memberid"],@"memberid",[self.responseDictionary valueForKey:@"residence"],@"residence", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Registration"];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View methods-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _profileOptionsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"CompleteProfileIdentifier";
    CompleteProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CompleteProfileTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(cell.inputTextField)
    {
        cell.inputTextField.delegate = self;
        [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    }
    

    cell.tag = indexPath.row + 100;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if(indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4)
    {
        cell.inputTextField.enabled = YES;
        cell.inputTextField.textColor = [UIColor blackColor];
        cell.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
    }
    else
    {
        cell.inputTextField.enabled = NO;
        cell.inputTextField.textColor = [UIColor lightGrayColor];
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    }
    
    cell.inputTextField.secureTextEntry = (indexPath.row == 3 || indexPath.row == 4);
    cell.dropDownButton.hidden = YES;
    cell.inputTextField.hidden = NO;
    
    cell.titleLabel.text = [_profileOptionsArray objectAtIndex:indexPath.row];
    cell.inputTextField.placeholder = [_profileOptionsArray objectAtIndex:indexPath.row];
    cell.inputTextField.text = @"";
    if(indexPath.row == 0 && ![[_inputDictionary valueForKey:@"fullname"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"fullname"];
        
    }
    else if(indexPath.row == 1 && ![[_inputDictionary valueForKey:@"email"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"email"];
        
    }
    else if(indexPath.row == 2 && ![[_inputDictionary valueForKey:@"username"]isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"username"];
    }
    else if(indexPath.row == 3 && ![[_inputDictionary valueForKey:@"password"]isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"password"];
    }
    else if(indexPath.row == 4 && ![[_inputDictionary valueForKey:@"confirmpassword"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"confirmpassword"];
    }
    
    else if(indexPath.row == 5 && ![[_inputDictionary valueForKey:@"gender"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"gender"];
        
    }
    else if(indexPath.row == 6 && ![[_inputDictionary valueForKey:@"nationality"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"nationality"];
    }
    else if(indexPath.row == 7 && ![[_inputDictionary valueForKey:@"residence"] isEqualToString:@""])
    {
        cell.inputTextField.text = [_inputDictionary valueForKey:@"residence"];
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    return;
    
    if(indexPath.row == 5 || indexPath.row == 6)
    {
        [self.view endEditing:YES];
        if(indexPath.row == 5)
            currentPicker = @"gender";
        else if(indexPath.row == 6)
            currentPicker = @"country";
        
        if(currentPicker)
        {
            [_pickerView reloadAllComponents];
            [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
                _rangeViewBottomConstraint.constant = -46;
            }
                             completion:^(BOOL finished)
             {
                 
             }];
        }
    }
}


#pragma mark- UITextField Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CompleteProfileTableViewCell *cell = (CompleteProfileTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CompleteProfileTableViewCell *cell = (CompleteProfileTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    

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

-(void)textFieldDidChange:(UITextField *)textField
{
    CompleteProfileTableViewCell *cell = (CompleteProfileTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    if(indexPath.row == 0)
    {
        [_inputDictionary setValue:textField.text forKey:@"fullname"];
    }
    else if(indexPath.row == 1)
    {
        [_inputDictionary setValue:textField.text forKey:@"email"];
    }
    else if(indexPath.row == 2)
    {
        [_inputDictionary setValue:textField.text forKey:@"username"];

    }
    else if(indexPath.row == 3)
    {
        [_inputDictionary setValue:textField.text forKey:@"password"];
    }
    else if(indexPath.row == 4)
    {
        [_inputDictionary setValue:textField.text forKey:@"confirmpassword"];
    }
    else if(indexPath.row == 5)
    {
        [_inputDictionary setValue:textField.text forKey:@"gender"];
    }
    else if(indexPath.row == 6)
    {
        [_inputDictionary setValue:textField.text forKey:@"nationality"];
    }
    else if(indexPath.row == 7)
    {
        [_inputDictionary setValue:textField.text forKey:@"residence"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    CompleteProfileTableViewCell *cell = (CompleteProfileTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    if(indexPath.row == 3 || indexPath.row == 4)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_LENGTH){
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([a-zA-Z0-9]+)?(\\.([0-9]{1,2})?)?$";
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



#pragma mark- Picker View Methods-

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return policyArray.count;
    
    if([currentPicker isEqualToString:@"gender"])
        return genderArray.count;
    else if([currentPicker isEqualToString:@"country"])
        return countryArray.count;

    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [policyArray[row] valueForKey:@"insurancecompany"];
    
    if([currentPicker isEqualToString:@"gender"])
        return genderArray[row];
    else if([currentPicker isEqualToString:@"country"])
        return countryArray[row];
    return @"";
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


#pragma mark- Button Actions-

- (IBAction)submitButtonAction:(id)sender {
    // move to dashboard screen.
    BOOL isValid = YES;
    NSArray *mendatoryFields = [[NSArray alloc] initWithObjects:@"username",@"password",@"confirmpassword", nil];
    for(int i = 0; i< mendatoryFields.count; i++)
    {
        NSString *key = [mendatoryFields objectAtIndex:i];
        NSString *valueString = [_inputDictionary valueForKey:key];
        if(!valueString || [[Utility trimString:valueString] isEqualToString:@""])
        {
            isValid = NO;
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],key] block:^(int index) {
            }];
            break;
        }
    }
    if(isValid)
    {
        
#if 1
        if(((NSString*)[_inputDictionary valueForKey:@"password"]).length < 8 || ((NSString*)[_inputDictionary valueForKey:@"password"]).length > 15)
        {
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@",[Localization languageSelectedStringForKey:@"Password should be alphanumeric and between 8 to 15 characters."]] block:^(int index) {
            }];
            return;
        }
#endif
        if(![[_inputDictionary valueForKey:@"password"] isEqualToString:[_inputDictionary valueForKey:@"confirmpassword"]])
        {
            [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@",[Localization languageSelectedStringForKey:@"Confirm password does not match"]] block:^(int index) {
            }];
            return;
        }
        [self callCompleteProfileAPI];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtn_Clicked:(id)sender
{
    int selectedRangeRow = (int)[_pickerView selectedRowInComponent:0];
    
    NSString *profileimge = [self.responseDictionary valueForKey:@"profileimage"];
    NSString *token = [self.responseDictionary valueForKey:@"token"];
    NSString *mobileno = [self.responseDictionary valueForKey:@"mobileno"];
    
    [self.responseDictionary removeAllObjects];
    [self.responseDictionary addEntriesFromDictionary:[self.responseArray objectAtIndex:selectedRangeRow]];
    
    [self.responseDictionary setValue:profileimge forKey:@"profileimage"];
    [self.responseDictionary setValue:token forKey:@"token"];
    [self.responseDictionary setValue:mobileno forKey:@"mobileno"];

    [self setDataInDictionary];
    [_mainTableView reloadData];

    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _rangeViewBottomConstraint.constant = -263;
    }
                     completion:^(BOOL finished)
     {
         
     }];
}

#pragma mark- Calling APIs-

-(void)callCompleteProfileAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary addEntriesFromDictionary:_inputDictionary];
    [dictionary removeObjectForKey:@"confirmpassword"];
    [dictionary setValue:@"new" forKey:@"mode"];
    [dictionary setValue:[self.responseDictionary valueForKey:@"mobileno"] forKey:@"mobileno"];
    if([self.responseDictionary valueForKey:@"profileimage"])
    {
        [dictionary setValue:[self.responseDictionary valueForKey:@"profileimage"] forKey:@"profileimage"];
    }
    else
    {
        [dictionary setValue:@"" forKey:@"profileimage"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"UpdateUserProfile"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.responseDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                    
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Registration successful"] block:^(int index)
                      {
                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          //[appDelegate logout];
                          NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                          [defaults removeObjectForKey:@"login"];
                          [defaults removeObjectForKey:@"usermemberid"];
                          [defaults synchronize];
                          
                          UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                          LoginViewController *initialController = [storyBoard instantiateViewControllerWithIdentifier:kLoginScreenStoryBoardName];
                         
                          /*UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:initialController];
                          [navigation setNavigationBarHidden:YES animated:NO];
                          
                          appDelegate.window.rootViewController = navigation;
                           */
                          
                         [initialController callLoginAPI:[_inputDictionary valueForKey:@"username"] andPassword:[_inputDictionary valueForKey:@"password"]];
                          
                      }];
                     
                     return;
                     
                     
                     
                     [[DbManager getSharedInstance] clearTable:@"User"];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Dependent" withPredicate:nil];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"PolicyDetails" withPredicate:nil];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults removeObjectForKey:@"login"];
                     [defaults synchronize];
                     
                     //NSArray *policyHolderArray = [responseDictionary valueForKey:@"policyholder"];
                     
                     for(int i = 0; i < policyArray.count; i++)
                     {
                         NSDictionary *dictionary = [policyArray objectAtIndex:i];
                         
                         User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                        inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                         
                         
                         if([dictionary valueForKey:@"username"])
                             user.name= [dictionary valueForKey:@"username"];
                         else
                             user.name= [dictionary valueForKey:@"mobileno"];
                         
                         user.password = [_inputDictionary valueForKey:@"password"];
                         user.email = [dictionary valueForKey:@"email"];
                         user.fullname = [_inputDictionary valueForKey:@"fullname"];
                         user.gender = [dictionary valueForKey:@"gender"];
                         user.memberid = [dictionary valueForKey:@"memberid"];
                         user.residence = [dictionary valueForKey:@"residence"];
                         user.nationality = [dictionary valueForKey:@"nationality"];
                         user.mobileno = [dictionary valueForKey:@"mobileno"];
                         user.company = [dictionary valueForKey:@"company"];
                         user.insurancecompany =
                         [dictionary valueForKey:@"insurancecompany"];
                         
                         if([dictionary valueForKey:@"profileimage"])
                         {
                            user.profileimage = [dictionary valueForKey:@"profileimage"];
                         }
                         if([[dictionary valueForKey:@"defaultpolicyholder"] isKindOfClass:[NSString class]])
                         {
                             user.defaultpolicyholder = [dictionary valueForKey:@"defaultpolicyholder"];
                         }
                         else
                         {
                             if(i == 0)
                                 user.defaultpolicyholder = @"True";
                         }
                         
                         user.emiratesid = [dictionary valueForKey:@"emiratesid"];
                         user.token = [dictionary valueForKey:@"token"];

                         if([dictionary valueForKey:@"policydetails"])
                         {
                             PolicyDetails *policyDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PolicyDetails"
                                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                             
                             NSDictionary *policyDetailDic = [dictionary valueForKey:@"policydetails"];
                             if([policyDetailDic valueForKey:@"emiratesid"])
                                 policyDetail.emiratesid = [policyDetailDic valueForKey:@"emiratesid"];
                             policyDetail.memberid = [policyDetailDic valueForKey:@"memberid"];
                             policyDetail.policyno = [policyDetailDic valueForKey:@"policynumber"];
                             policyDetail.policyperiod = [policyDetailDic valueForKey:@"policyperiod"];
                             policyDetail.policystatus = [policyDetailDic valueForKey:@"status"];
                             policyDetail.premiumamount = [policyDetailDic valueForKey:@"premiumamount"];
                             policyDetail.mastercontractname = [policyDetailDic valueForKey:@"mastercontractname"];
                             policyDetail.productname = [policyDetailDic valueForKey:@"productname"];
                             policyDetail.insurancecompanyname = [dictionary valueForKey:@"insurancecompany"];
                             policyDetail.companyname = [dictionary valueForKey:@"company"];
                             
                             if([policyDetailDic valueForKey:@"policystartdate"])
                                 policyDetail.startdate = [policyDetailDic valueForKey:@"policystartdate"];
                             
                             if([policyDetailDic valueForKey:@"policyenddate"])
                                 policyDetail.enddate = [policyDetailDic valueForKey:@"policyenddate"];
                             
                             user.policydetail = policyDetail;
                         }
                         
                         NSArray *dependentArray = [dictionary valueForKey:@"dependents"];
                         if(dependentArray.count > 0)
                         {
                             NSMutableSet * dependentSet = [[NSMutableSet alloc]init];
                             
                             for(NSDictionary *dependentDic in dependentArray)
                             {
                                 Dependent *dependent = [NSEntityDescription insertNewObjectForEntityForName:@"Dependent"
                                                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                                 if(![[dependentDic valueForKey:@"email"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.email = [dependentDic valueForKey:@"email"];
                                 }
                                 if(![[dependentDic valueForKey:@"emiratesid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.emiratesid = [dependentDic valueForKey:@"emiratesid"];
                                 }
                                 if(![[dependentDic valueForKey:@"fullname"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.fullname = [dependentDic valueForKey:@"fullname"];
                                 }
                                 
                                 if(![[dependentDic valueForKey:@"gender"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.gender = [dependentDic valueForKey:@"gender"];
                                 }
                                 if(![[dependentDic valueForKey:@"memberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.memberid = [dependentDic valueForKey:@"memberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"nationality"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.nationality = [dependentDic valueForKey:@"nationality"];
                                 }
                                 if(![[dependentDic valueForKey:@"passport"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.passport = [dependentDic valueForKey:@"passport"];
                                 }
                                 if(![[dependentDic valueForKey:@"principalmemberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.principalmemberid = [dependentDic valueForKey:@"principalmemberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"relation"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.relation = [dependentDic valueForKey:@"relation"];
                                 }
                                 if(![[dependentDic valueForKey:@"residence"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.residence = [dependentDic valueForKey:@"residence"];
                                 }
                                 [dependentSet addObject:dependent];
                             }
                             user.depend = dependentSet;
                         }
                         [[DbManager getSharedInstance] saveContext];
                    }
                     
                     NSMutableDictionary *updatedDictionary = [[NSMutableDictionary alloc] init];
                     
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
                     //NSArray *allPolicyHolderArray = [dictionary valueForKey:@"policyholder"];
                     NSArray *defaultArray = [policyArray filteredArrayUsingPredicate:predicate];
                     
                     if(defaultArray.count > 0)
                         [updatedDictionary addEntriesFromDictionary:[defaultArray firstObject]];
                     else
                         [updatedDictionary addEntriesFromDictionary:[policyArray firstObject]];
                     
                     [updatedDictionary setValue:[dictionary valueForKey:@"token"] forKey:@"token"];
                     
                     UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     TabbarViewController *homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"TabbarControllerIdentifier"];
                     
                     DashboardViewController *dashboardObj =  (DashboardViewController*)[[homeViewController viewControllers] objectAtIndex:0];
                     
                     SearchViewController *searchObj =  (SearchViewController*)[[homeViewController viewControllers] objectAtIndex:1];
                     
                     dashboardObj.personDetailDictionary = updatedDictionary;
                     searchObj.personDetailDictionary = updatedDictionary;
                     
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
                     
                     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     appDelegate.window.rootViewController = revealController;
                     [appDelegate.window makeKeyAndVisible];
                     
                     /*UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Verification successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                      [alert show];
                      */
                     return;
                     
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
