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

@interface ClubIRISViewController ()

@end

@implementation ClubIRISViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    static NSString *cellIdentifier  =@"ClbIRISCell";
    ClbIRISCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ClbIRISCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
        cell.backgroundColor = [UIColor redColor];
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


@end
