//
//  ProfileDetailViewController.m
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ProfileDetailViewController.h"
#import "ProfileDetailTableViewCell.h"
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
#import "PolicyDetails+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "Dependent+CoreDataProperties.h"
#import "UIButton+CustomButton.h"
#import "ProfileDetailSaveTableViewCell.h"
#import "ProfileImageTableViewCell.h"
#import "NSData+Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HIPRootViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SearchViewController.h"
#import "DashboardViewController.h"
#import "BenefitGroup+CoreDataProperties.h"
#import "Benefit+CoreDataProperties.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface ProfileDetailViewController ()<coropImageDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

typedef enum _cameraMode
{
    typeCamera = 0,
    typeLibrary = 1
    
} cameraMode;

@implementation ProfileDetailViewController

#define MAX_LENGTH 15
#define MAX_USERNAME_LENGHT 40

#pragma mark - view Loading -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isDependentProfile)
        self.titleLabel.text = @"Dependant";
    else
        self.titleLabel.text = [Localization languageSelectedStringForKey:@"Edit Profile"];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    [_submitButton setButtonCornerRadious];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
         editPLbl.text =  [Localization languageSelectedStringForKey:@"Edit Profile"];
         switchLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"];
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        editPLbl.text =  [Localization languageSelectedStringForKey:@"Edit Profile"];
        switchLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    if(self.dependentUser)
    {
        _inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dependentUser.fullname,@"fullname",self.dependentUser.email,@"email",self.dependentUser.nationality,@"nationality",self.dependentUser.gender,@"gender",self.dependentUser.memberid,@"memberid",self.dependentUser.residence,@"residence",self.dependentUser.profileimage,@"profileimage", nil];
        
        _profileOptionsArray = [[NSMutableArray alloc] initWithObjects:@"",[Localization languageSelectedStringForKey:@"Full Name"],[Localization languageSelectedStringForKey:@"Email"], [Localization languageSelectedStringForKey:@"Gender"],[Localization languageSelectedStringForKey:@"Nationality"],[Localization languageSelectedStringForKey:@"Residence Location"], nil];
        
        _bottomViewHeightCons.constant = 44;
        
        NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
        NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
        if(activeDependent && ![activeDependent isEqualToString:@""])
        {
            if([self.dependentUser.memberid isEqualToString:activeDependent])
                switchToDependentButton.selected = YES;
        }
    }
    else
    {
        _bottomViewHeightCons.constant = 0;

        _inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.currentUser.name,@"username",self.currentUser.password,@"password",self.currentUser.password,@"confirmpassword",self.currentUser.fullname,@"fullname",self.currentUser.email,@"email",self.currentUser.nationality,@"nationality",self.currentUser.gender,@"gender",self.currentUser.memberid,@"memberid",self.currentUser.residence,@"residence",self.currentUser.profileimage,@"profileimage",self.currentUser.mobileno,@"mobileno", nil];
        
        _profileOptionsArray = [[NSMutableArray alloc] initWithObjects:@"",[Localization languageSelectedStringForKey:@"Full Name"],[Localization languageSelectedStringForKey:@"Email"],[Localization languageSelectedStringForKey:@"User Name"],[Localization languageSelectedStringForKey:@"Password"], [Localization languageSelectedStringForKey:@"Confirm Password"], [Localization languageSelectedStringForKey:@"Gender"],[Localization languageSelectedStringForKey:@"Nationality"],[Localization languageSelectedStringForKey:@"Residence Location"],@"", nil];
    }
    

    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Edit Profile"]];

    
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
    if(indexPath.row == 0)
        return 110;
    else if(indexPath.row == _profileOptionsArray.count-1 && self.currentUser)
        return 80;
    return 60;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier  =@"ProfileImageCellIdentifier";
        ProfileImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileImageTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        if(cell.profileImageButton && self.currentUser)
        {
            [cell.profileImageButton addTarget:self
                                      action:@selector(profileImageChangeAction:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.profileEditImageView.hidden = YES;
        }
        
        [cell.profileImageView setImage:[UIImage imageNamed:@"userplaceholde"]];
        
        if([_inputDictionary valueForKey:@"profileimage"])
        {
            NSString *imageString = [_inputDictionary valueForKey:@"profileimage"];

            if(imageString.length > 100)
            {
                NSString *imageString = [_inputDictionary valueForKey:@"profileimage"];
                NSData *imageData = [NSData dataFromBase64String:imageString];
                UIImage *dependentImage = [UIImage imageWithData:imageData];
                [cell.profileImageView setImage:dependentImage];
                NSLog(@"imageSize %@",NSStringFromCGRect(cell.profileImageView.frame));
            }
            else
            {
                [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"userplaceholde"]];
                NSLog(@"imageSize %@",NSStringFromCGRect(cell.profileImageView.frame));
            }
        }
        else
        {
            [cell.profileImageView setImage:[UIImage imageNamed:@"userplaceholde"]];
        }
        return cell;
    }
    else if(indexPath.row == _profileOptionsArray.count - 1 && self.currentUser)
    {
        static NSString *cellIdentifier  =@"ProfileDetailSaveCellIdentifier";
        ProfileDetailSaveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailSaveTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        if(cell.saveButton)
        {
            [cell.saveButton addTarget:self
                                        action:@selector(submitButtonAction:)
                              forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    
    static NSString *cellIdentifier  =@"ProfileDetailCellIdentifier";
    ProfileDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileDetailTableViewCell" owner:self options:nil];
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
    
    if((indexPath.row == 4 || indexPath.row == 5) && self.currentUser)
     {
         cell.inputTextField.textColor = [UIColor blackColor];
         cell.inputTextField.enabled = YES;
         cell.inputTextField.secureTextEntry = (indexPath.row == 4 || indexPath.row == 5);
         cell.titleLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1];
     }
     else
     {
         cell.inputTextField.textColor = [UIColor lightGrayColor];
         cell.titleLabel.textColor = [UIColor lightGrayColor];
         cell.inputTextField.enabled = NO;
     }
    
    cell.titleLabel.text = [_profileOptionsArray objectAtIndex:indexPath.row];
    cell.inputTextField.placeholder = [_profileOptionsArray objectAtIndex:indexPath.row];
    cell.inputTextField.text = @"";
    if(indexPath.row == 1 && ![[_inputDictionary valueForKey:@"fullname"] isEqualToString:@""])
    {
        cell.titleLabel.hidden = NO;
        cell.inputTextField.text = [_inputDictionary valueForKey:@"fullname"];
        
    }
    else if(indexPath.row == 2 && ![[_inputDictionary valueForKey:@"email"] isEqualToString:@""])
    {
        cell.titleLabel.hidden = NO;
        cell.inputTextField.text = [_inputDictionary valueForKey:@"email"];
        
    }
    if(self.dependentUser)
    {
        cell.inputTextField.textColor = [UIColor blackColor];
        if(indexPath.row == 3 && ![[_inputDictionary valueForKey:@"gender"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"gender"];
            
        }
        else if(indexPath.row == 4 && ![[_inputDictionary valueForKey:@"nationality"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"nationality"];
            
        }
        else if(indexPath.row == 5 && ![[_inputDictionary valueForKey:@"residence"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"residence"];
            
        }
    }
    else
    {
        cell.inputTextField.textColor = [UIColor lightGrayColor];
        if(indexPath.row == 3 && ![[_inputDictionary valueForKey:@"username"]isEqualToString:@""] && self.currentUser)
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"username"];
        }
        else if(indexPath.row == 4 && ![[_inputDictionary valueForKey:@"password"]isEqualToString:@""] && self.currentUser)
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"password"];
            cell.inputTextField.textColor = [UIColor blackColor];
        }
        else if(indexPath.row == 5 && ![[_inputDictionary valueForKey:@"confirmpassword"] isEqualToString:@""] && self.currentUser)
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"confirmpassword"];
            cell.inputTextField.textColor = [UIColor blackColor];
        }
        
        else if(indexPath.row == 6 && ![[_inputDictionary valueForKey:@"gender"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"gender"];
        }
        else if(indexPath.row == 7 && ![[_inputDictionary valueForKey:@"nationality"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"nationality"];
            
        }
        else if(indexPath.row == 8 && ![[_inputDictionary valueForKey:@"residence"] isEqualToString:@""])
        {
            cell.titleLabel.hidden = NO;
            cell.inputTextField.text = [_inputDictionary valueForKey:@"residence"];
            
        }
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
}


#pragma mark- UITextField Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    if(indexPath.row == 5)
    {
        [textField resignFirstResponder];
        return YES;
    }

    activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    cell = [_mainTableView cellForRowAtIndexPath:activeCellIndexPath];
    
    if(cell)
    {
        for(id view in cell.contentView.subviews)
            if([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField1 = view;
                [textField1 becomeFirstResponder];
                break;
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
    
    if(indexPath.row == 4 || indexPath.row == 5)
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
    else
    {
            NSUInteger newLength = [textField.text length] + [string length];
            
            if(newLength > MAX_USERNAME_LENGHT){
                return NO;
        }
    }
    return YES;
}

-(void)textFieldDidChange:(UITextField *)textField
{
    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
   
    /*if(textField.text)
    {
        if(textField.text.length > 0)
            cell.titleLabel.hidden = NO;
        else
            cell.titleLabel.hidden = YES;
    }*/
    
   if(indexPath.row == 4)
    {
        [_inputDictionary setValue:textField.text forKey:@"password"];
    }
    else if(indexPath.row == 5)
    {
        [_inputDictionary setValue:textField.text forKey:@"confirmpassword"];
    }
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

- (IBAction)switchToDependentButtonAction:(id)sender {
    
    NSMutableDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];

    if(!switchToDependentButton.selected)
    {
        switchToDependentButton.selected = YES;
        [userInfoDic setValue:self.dependentUser.memberid forKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        switchToDependentButton.selected = false;
        [userInfoDic removeObjectForKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_profile_notification"                                                                object:nil userInfo:nil];
}


- (IBAction)submitButtonAction:(id)sender {
    // move to dashboard screen.
    BOOL isValid = YES;
    
    NSString *valueString = nil;
    
    if([[Utility trimString:[_inputDictionary valueForKey:@"password"]] isEqualToString:@""])
        valueString = [Localization languageSelectedStringForKey:@"Please enter password"];
    else if(((NSString*)[_inputDictionary valueForKey:@"password"]).length < 8 || ((NSString*)[_inputDictionary valueForKey:@"password"]).length > 15)
    {
        valueString = [Localization languageSelectedStringForKey:@"Password should be alphanumeric and between 8 to 15 characters."];

    }
    else if([[Utility trimString:[_inputDictionary valueForKey:@"confirmpassword"]] isEqualToString:@""])
    {
        valueString = [Localization languageSelectedStringForKey:@"Please enter confirm password"];
    }
    else if(![[Utility trimString:[_inputDictionary valueForKey:@"password"]] isEqualToString:[Utility trimString:[_inputDictionary valueForKey:@"confirmpassword"]]])
    {
        valueString = [Localization languageSelectedStringForKey:@"Confirm password does not match"];
    }
    
    if(valueString)
    {
        isValid = NO;
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@.",valueString] block:^(int index) {
        }];
    }
    
    if(isValid)
    {
        [self callUpdateProfileAPI];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)openCamera
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"Please select"] message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addPhotoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Library"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         capturedMode = typeLibrary;
                                         if(self.imagePicker == nil)
                                             self.imagePicker = [[UIImagePickerController alloc] init];
                                         [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                         [self.imagePicker setDelegate:self];
                                         [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
                                         [self presentViewController:self.imagePicker animated:YES completion:nil];
                                     }];
    
    UIAlertAction *addVideoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Camera"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                             if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                                             {
                                                 capturedMode = typeCamera;
                                                 if(self.imagePicker == nil)
                                                     self.imagePicker = [[UIImagePickerController alloc] init];
                                                 
                                                 [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                                 self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                                                 self.imagePicker.showsCameraControls = YES;
                                                 self.imagePicker.delegate = self;
                                                 [self presentViewController:self.imagePicker animated:YES completion:nil];
                                             }
                                     }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSLog(@"Dismiss");
    }];
    
    [alertController addAction:addPhotoAction];
    [alertController addAction:addVideoAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
-(IBAction)profileImageChangeAction:(id)sender
{
    [self openCamera];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
     UIImage *capturedImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    capturedImage = [self compressImage:capturedImage];
    
    //UIImage *newImage = [self imageWithImage:capturedImage scaledToFillSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)];
    [self performSelector:@selector(moveToCroperScreen:) withObject:capturedImage afterDelay:0];
}

-(void)moveToCroperScreen:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *capturedImage = sender;
        [self performSegueWithIdentifier:kImageCropViewIdentifier sender:capturedImage];
    });
}

-(UIImage *)compressImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = self.view.frame.size.height;
    float maxWidth = self.view.frame.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}

-(void)updateCropedCaptureImage:(UIImage *)capturedImage
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ProfileImageTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:indexPath];
    UIImage *thumbnailImage = [self imageWithImage:capturedImage scaledToFillSize:CGSizeMake(150,150)];
    [cell.profileImageView setImage:thumbnailImage];
    [_inputDictionary setValue:[self encodeToBase64String: thumbnailImage] forKey:@"profileimage"];
    
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f, (size.height - height)/2.0f, width,height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 600; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:[Localization languageSelectedStringForKey:@"Invalid image orientation"]];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kImageCropViewIdentifier])
    {
        HIPRootViewController *hipRootViewController = segue.destinationViewController;
        
        hipRootViewController.customDelegate = self;
        CGSize size = CGSizeZero;
        size.width = self.view.frame.size.width - 50;
        size.height = size.width;
        UIImage *capturedImage = sender;
        [hipRootViewController setImageToCrop:capturedImage withSize:size];
    }
}

#pragma mark- Calling APIs-

-(void)callUpdateProfileAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary addEntriesFromDictionary:_inputDictionary];
    [dictionary removeObjectForKey:@"confirmpassword"];
    [dictionary setValue:@"update" forKey:@"mode"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"UpdateUserProfile"];
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
                     //// update the login dic in userdefault///
                     
                    /* NSDictionary *dictionary = [[responseDictionary valueForKey:@"policyholder"] firstObject];
                     
                     NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
                     
                     NSString *emiratesId = [userInfoDic valueForKey:@"emiratesid"];
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",emiratesId,defaultPolicy];
                     
                     User *user = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
                     
                     user.password = [_inputDictionary valueForKey:@"password"];
                     
                     
                     if([dictionary valueForKey:@"profileimage"])
                     {
                         user.profileimage = [dictionary valueForKey:@"profileimage"];
                     }
                     [[DbManager getSharedInstance] saveContext];
                     */
                     
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Profile updated successfully."] block:^(int index) {
                         [self callShowProfileAPI];
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


-(void)callShowProfileAPI
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
   
    NSMutableDictionary *dictionary1 = [[NSMutableDictionary alloc] init];
    [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"principalmemberid"];
    
    
    NSString *token = [userInfoDic valueForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ShowProfile"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary1 options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                     NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
                     
                     NSString *emiratesId = [userInfoDic valueForKey:@"emiratesid"];
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",emiratesId,defaultPolicy];
                     
                     NSArray *userArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO];
                     
                     NSArray *allPolicyHolderArray = [responseDictionary valueForKey:@"policyholder"];
                     NSArray *defaultArray = [allPolicyHolderArray filteredArrayUsingPredicate:predicate];
                     
                     NSDictionary *updatedDic = [defaultArray firstObject];
                     NSString *profileImage = [updatedDic valueForKey:@"profileimage"];
                     User *user = [userArray firstObject];
                     user.password = [_inputDictionary valueForKey:@"password"];
                     user.profileimage = profileImage;
                     [[DbManager getSharedInstance] saveContext];
                     
                     [userInfoDic setValue:user.profileimage forKey:@"profileimage"];
                     [userInfoDic setValue:user.password forKey:@"password"];
                     [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     [[SDImageCache sharedImageCache] removeImageForKey:user.profileimage fromDisk:YES withCompletion:^{
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"update_profile_notification"                                                                object:nil userInfo:nil];
                     }];

                    /* [[DbManager getSharedInstance] clearTable:@"User"];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Dependent" withPredicate:nil];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"PolicyDetails" withPredicate:nil];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults removeObjectForKey:@"login"];
                     [defaults synchronize];
                     
                     UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     TabbarViewController *homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"TabbarControllerIdentifier"];
                     
                     DashboardViewController *dashboardObj =  (DashboardViewController*)[[homeViewController viewControllers] objectAtIndex:0];
                     SearchViewController *searchObj =  (SearchViewController*)[[homeViewController viewControllers] objectAtIndex:1];
                     NSMutableDictionary *updatedDictionary = [[NSMutableDictionary alloc] init];
                     
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
                     NSArray *allPolicyHolderArray = [responseDictionary valueForKey:@"policyholder"];
                     NSArray *defaultArray = [allPolicyHolderArray filteredArrayUsingPredicate:predicate];
                     
                     if(defaultArray.count > 0)
                         [updatedDictionary addEntriesFromDictionary:[defaultArray firstObject]];
                     else
                         [updatedDictionary addEntriesFromDictionary:[allPolicyHolderArray firstObject]];
                     
                     [updatedDictionary setValue:token forKey:@"token"];
                     dashboardObj.personDetailDictionary = updatedDictionary;
                     searchObj.personDetailDictionary = updatedDictionary;
                     
                     
                     NSArray *policyHolderArray = [responseDictionary valueForKey:@"policyholder"];
                     
                     for(int i = 0; i< policyHolderArray.count; i++)
                     {
                        /* User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                    inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                         
                         user.name = [_inputDictionary valueForKey:@"username"];
                         user.password = [_inputDictionary valueForKey:@"password"];
                         //user.password = _passwordTextField.text;
                         user.email = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"email"];
                         user.fullname = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"fullname"];
                         user.gender = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"gender"];
                         user.memberid = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"memberid"];
                         user.residence = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"residence"];
                         user.nationality = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"nationality"];
                         if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"])
                             user.mobileno = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"];
                         user.company = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                         user.insurancecompany = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                         if([[[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"] isKindOfClass:[NSString class]])
                         {
                             user.defaultpolicyholder = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"];
                         }
                         if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                             user.emiratesid = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                         
                         if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] && ![[[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                             user.profileimage = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"];
                         
                         user.token = token;
                         
                         if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"])
                         {
                             PolicyDetails *policyDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PolicyDetails"
                                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                             
                             NSDictionary *policyDetailDic = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"];
                             if([policyDetailDic valueForKey:@"emiratesid"])
                                 policyDetail.emiratesid = [policyDetailDic valueForKey:@"emiratesid"];
                             policyDetail.memberid = [policyDetailDic valueForKey:@"memberid"];
                             policyDetail.policyno = [policyDetailDic valueForKey:@"policynumber"];
                             policyDetail.policyperiod = [policyDetailDic valueForKey:@"policyperiod"];
                             policyDetail.policystatus = [policyDetailDic valueForKey:@"status"];
                             policyDetail.premiumamount = [policyDetailDic valueForKey:@"premiumamount"];
                             policyDetail.mastercontractname = [policyDetailDic valueForKey:@"mastercontractname"];
                             policyDetail.productname = [policyDetailDic valueForKey:@"productname"];
                             policyDetail.insurancecompanyname = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                             policyDetail.companyname = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                             
                             if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                 policyDetail.parentemiratesid = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                             
                             //[[DbManager getSharedInstance] saveContext];
                             
                             // process and generate plan benefits data
                             policyDetail.benefitgroup = [self processBenefitsData:[policyDetailDic valueForKey:@"planbenefits"]];
                             
                             user.policydetail = policyDetail;
                             
                         }
                         NSArray *dependentArray = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"dependents"];
                         
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
                                 if(![[dependentDic valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.profileimage = [dependentDic valueForKey:@"profileimage"];
                                 }
                                 if([[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                     dependent.parentemiratesid = [[[responseDictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                                 [dependentSet addObject:dependent];
                                 //[[DbManager getSharedInstance] saveContext];
                             }
                             user.depend = dependentSet;
                         }
                         [[DbManager getSharedInstance] saveContext];
                         
                     }
                     */
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


#pragma mark - private methods
-(NSMutableSet *)processBenefitsData:(NSDictionary *)benefitData {
    NSMutableSet *planBenefits = [[NSMutableSet alloc] init];
    
    NSArray *parentBenefits = [benefitData valueForKey:@"BenefitMaster"];
    NSSet *benefitGroups = [NSSet setWithArray:[parentBenefits valueForKey:@"Group"]];
    
    NSArray *childBenefits = [benefitData valueForKey:@"BenefitChild"];
    
    // loop through groups
    for (NSString *groupTitle in benefitGroups) {
        BenefitGroup *benefitGroup = [NSEntityDescription insertNewObjectForEntityForName:@"BenefitGroup"
                                                                   inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        benefitGroup.grouptitle = groupTitle;
        
        NSPredicate *parentBenefitPredicate = [NSPredicate predicateWithFormat:@"Group ==[c]%@",groupTitle];
        NSArray *filteredParentBenefits = [parentBenefits filteredArrayUsingPredicate:parentBenefitPredicate];
        
        NSMutableSet *parentBenefitSet = [[NSMutableSet alloc] init];
        // loop through parent benefits
        for (NSDictionary *parentBenefit in filteredParentBenefits) {
            Benefit *parentBenefitObj = [NSEntityDescription insertNewObjectForEntityForName:@"Benefit"
                                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
            
            NSString *benefitId = [parentBenefit valueForKey:@"BenefitID"];
            if(!benefitId || benefitId == [NSNull null]) {
                //continue;
                benefitId = 0;
            }
            
            parentBenefitObj.benefitid = benefitId;
            parentBenefitObj.benefitdescription = [parentBenefit valueForKey:@"Description"];
            parentBenefitObj.value = ([[parentBenefit valueForKey:@"Value"] isKindOfClass:[NSString class]])?[parentBenefit valueForKey:@"Value"]:@"0";
            parentBenefitObj.parentid = @"0";
            //benefitObj.parentid = [benefit valueForKey:@"ParentBenefitID"];
            
            [parentBenefitSet addObject:parentBenefitObj];
            
            // loop through child benefits
            NSPredicate *childBenefitPredicate = [NSPredicate predicateWithFormat:@"ParentBenefitID ==[c] %@",benefitId];
            NSArray *filteredChildBenefits = [childBenefits filteredArrayUsingPredicate:childBenefitPredicate];
            for (NSDictionary *childBenefit in filteredChildBenefits) {
                Benefit *childBenefitObj = [NSEntityDescription insertNewObjectForEntityForName:@"Benefit"
                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                
                if(![[childBenefit valueForKey:@"BenefitID"] isKindOfClass:[NSNull class]])
                    childBenefitObj.benefitid = [childBenefit valueForKey:@"BenefitID"];
                childBenefitObj.benefitdescription = [childBenefit valueForKey:@"Description"];
                
                if(![[childBenefit valueForKey:@"Value"] isKindOfClass:[NSNull class]])
                    childBenefitObj.value = [childBenefit valueForKey:@"Value"];
                
                if(![[childBenefit valueForKey:@"ParentBenefitID"] isKindOfClass:[NSNull class]])
                    childBenefitObj.parentid = [childBenefit valueForKey:@"ParentBenefitID"];
                
                [parentBenefitSet addObject:childBenefitObj];
            }
            
        }
        benefitGroup.benefits = parentBenefitSet;
        [planBenefits addObject:benefitGroup];
    }
    
    return planBenefits;
}
@end
