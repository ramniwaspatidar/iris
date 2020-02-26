//
//  ForgotPasswordViewController.m
//  Iris
//
//  Created by apptology on 19/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ForgotPasswordOTPViewController.h"
#import "ProfileDetailTableViewCell.h"
#import "Utility.h"
#import "ConnectionManager.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface ForgotPasswordOTPViewController ()<UITextFieldDelegate>

@end

@implementation ForgotPasswordOTPViewController
#define MAX_LENGTH 15
#define MAX_OTP_LENGTH 8

- (void)viewDidLoad {
    [super viewDidLoad];
    // [Localization languageSelectedStringForKey:@"OTP"]
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"New Password"],[Localization languageSelectedStringForKey:@"OTP"], nil];
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",nil];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    

    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addGestureonView];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          resetPwdLbl.text =  [Localization languageSelectedStringForKey:@"Reset Password"];
        
        [submitBtn setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        resetPwdLbl.text =  [Localization languageSelectedStringForKey:@"Reset Password"];
        
        [submitBtn setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    // Do any additional setup after loading the view.
}

-(void)addGestureonView
{
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier  =@"ProfileDetailCellIdentifier";
    ProfileDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
        cell.tag = 1000 + indexPath.row;
        if(cell.inputTextField)
        {
            cell.inputTextField.delegate = self;
            cell.inputTextField.tag =  indexPath.row;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.inputTextField.secureTextEntry = (indexPath.row == 0);
        }
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        cell.inputTextField.textAlignment = NSTextAlignmentLeft;
    }else{
        cell.inputTextField.textAlignment = NSTextAlignmentRight;
    }
        cell.titleLabel.text = [_placeholderArray objectAtIndex:indexPath.row];
    
        cell.inputTextField.placeholder = [_placeholderArray objectAtIndex:indexPath.row];
        if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
            cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}


-(void)textFieldDidChange:(UITextField *)textField
{
    
    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if(textField.text)
    {
        [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //cell.titleLabel.hidden = YES;
    if(indexPath.row == 1)
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
    
    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    if(indexPath.row == 1)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_OTP_LENGTH){
            return NO;
        }
    }
    else if(indexPath.row == 0)
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
            fieldName = [_placeholderArray objectAtIndex:i];
            break;
        }
    }
    
    if(isEmptyField)
    {
        //[Localization languageSelectedStringForKey:@"Password should be alphanumeric and between 8 to 15 characters."]
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],fieldName] block:^(int index) {
        }];
    }
    else
    {
        if([Utility trimString:[_inputDataArray objectAtIndex:0]].length < 8 || [Utility trimString:[_inputDataArray objectAtIndex:0]].length > 15)
        {
            [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Password should be alphanumeric and between 8 to 15 characters."] block:^(int index) {
            }];
            return;
        }
        
        [self callResetPasswordAPI];
    }
}


-(void)callResetPasswordAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:self.mobileNo forKey:@"mobileno"];
    [dictionary setValue:[Utility trimString:[_inputDataArray objectAtIndex:0]] forKey:@"password"];
    [dictionary setValue:[Utility trimString:[_inputDataArray objectAtIndex:1]] forKey:@"otp"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ForgotPasswordOTP"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:self.tokenString json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                     ////[Localization languageSelectedStringForKey:@"Password Reset Successfully."]
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Password Reset Successfully."] block:^(int index) {
                         [self.navigationController popToRootViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
