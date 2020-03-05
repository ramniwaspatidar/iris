//
//  ClubIRISViewController.m
//  Iris
//
//  Created by Ramniwas Patidar on 03/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import "ClubIRISViewController.h"
#import "MainSideMenuViewController.h"
#import "RevealViewController.h"
#import "Localization.h"
#import "UIImage+animatedGIF.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "Utility.h"


@interface ClubIRISViewController ()

@end

@implementation ClubIRISViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getClubList];
    [self showHeaderLogo];
    [self initialSetupView];
}

-(void)initialSetupView
{
    [self addGestureonView];
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        titleLabel.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];
        [menuButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        titleLabel.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];

        [menuButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)showHeaderLogo{
    NSString *assetLocalPath = [[NSBundle mainBundle] pathForResource:@"logo_aniamtion" ofType:@"gif"];
    NSURL *assetURL = [[NSURL alloc] initFileURLWithPath:assetLocalPath];
    headerImageView.image = [UIImage animatedImageWithAnimatedGIFURL:assetURL];
    
    allTextField.placeholder = [Localization languageSelectedStringForKey:@"All"];
    countryTextFiled.placeholder = [Localization languageSelectedStringForKey:@"Select Country"];
    searchTextField.placeholder = [Localization languageSelectedStringForKey:@"Search here"];
    
    
    bgView1.layer.masksToBounds = true;
    bgView1.layer.cornerRadius = 5;
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bgView1.layer.shadowColor = [[UIColor blackColor] CGColor];
    bgView1.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    bgView1.layer.shadowOpacity = 0.5;
    bgView1.layer.shadowRadius = 1.0;
    
    bgView2.layer.masksToBounds = true;
    bgView2.layer.cornerRadius = 5;
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bgView2.layer.shadowColor = [[UIColor blackColor] CGColor];
    bgView2.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    bgView2.layer.shadowOpacity = 0.5;
    bgView2.layer.shadowRadius = 1.0;
    
    bgView3.layer.masksToBounds = true;
    bgView3.layer.cornerRadius = 5;
    bgView3.layer.borderWidth = 1;
    bgView3.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bgView3.layer.shadowColor = [[UIColor blackColor] CGColor];
    bgView3.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    bgView3.layer.shadowOpacity = 0.5;
    bgView3.layer.shadowRadius = 1.0;
    
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



#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [clubArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier  =@"ClbIRISCell";
    ClbIRISCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ClbIRISCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
       [cell getClubData:[[clubArray objectAtIndex:indexPath.row] valueForKey:@"voucherimageslist"] title:[[clubArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
    
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
    
//    ClbIRISCell *cell = (ClbIRISCell*)textField.superview.superview;
//    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
//    if(textField.text)
//    {
//        [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
//    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
//    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
//    //cell.titleLabel.hidden = YES;
//    if(indexPath.row == 1)
//    {
//        [textField resignFirstResponder];
//        return YES;
//    }
//
//    activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
//    [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
//
//    cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
//    if(cell)
//    {
//        activeCellIndexPath = indexPath;
//        for(id view in cell.contentView.subviews)
//            if([view isKindOfClass:[UITextField class]])
//            {
//                UITextField *textField1 = view;
//                [textField1 becomeFirstResponder];
//            }
//    }
//    else
//    {
//        [textField resignFirstResponder];
//    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
//    ProfileDetailTableViewCell *cell = (ProfileDetailTableViewCell*)textField.superview.superview;
//    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
//
//    if(indexPath.row == 1)
//    {
//        NSUInteger newLength = [textField.text length] + [string length];
//
//        if(newLength > MAX_OTP_LENGTH){
//            return NO;
//        }
//    }
//    else if(indexPath.row == 0)
//    {
//        NSUInteger newLength = [textField.text length] + [string length];
//
//        if(newLength > MAX_LENGTH){
//            return NO;
//        }
//
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        NSString *expression = @"^([a-zA-Z0-9]+)?(\\.([0-9]{1,2})?)?$";
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
//                                                                               options:NSRegularExpressionCaseInsensitive
//                                                                                 error:nil];
//        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
//                                                            options:0
//                                                              range:NSMakeRange(0, [newString length])];
//        if (numberOfMatches == 0)
//            return NO;
//    }
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


- (IBAction)allButtonAction:(id)sender {
}

- (IBAction)countryButton:(id)sender {
}


-(void)getClubList{
    
   NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
   
   
   NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:@"" forKey:@"Category"];
    [dictionary setValue:@"" forKey:@"Country"];
    [dictionary setValue:@"" forKey:@"BuyOneAndGetOneFree"];
    [dictionary setValue:@"" forKey:@"PromoCode"];
    [dictionary setValue:@"" forKey:@"HotDeal"];
    [dictionary setValue:@"" forKey:@"NewlyAdded"];


   
   NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetAllClubIrisVoucherList"];
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
//                     [self callShowProfileAPI];
                     
                     self->clubArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"listofvouchers"]];
                     [self->_mainTableView reloadData];

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
