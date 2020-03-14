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
#import "Iris-Swift.h"
#import "ClubFilterCell.h"


@interface ClubIRISViewController ()

@end

@implementation ClubIRISViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    discount  = @"";
    promocode = @"";
    flatDiscount = @"";
    latestVoucher = @"";
    
  
    _countryInfoArray = [[NSMutableArray alloc]init];
    [self getClubList];
    [self showHeaderLogo];
    [self initialSetupView];
}

-(void)initialSetupView
{
    // [self addGestureonView];
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
    
    filterSelectedArray  = [[NSMutableArray alloc]init];
    filterArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Latest Voucher"],[Localization languageSelectedStringForKey:@"Discount(%)"],[Localization languageSelectedStringForKey:@"Flat Discount"],[Localization languageSelectedStringForKey:@"Promocode"], nil];
    
}

-(void)showHeaderLogo{
    NSString *assetLocalPath = [[NSBundle mainBundle] pathForResource:@"logo_aniamtion" ofType:@"gif"];
    NSURL *assetURL = [[NSURL alloc] initFileURLWithPath:assetLocalPath];
    headerImageView.image = [UIImage animatedImageWithAnimatedGIFURL:assetURL];
    
    allTextField.placeholder = [Localization languageSelectedStringForKey:@"All"];
    countryTextFiled.placeholder = [Localization languageSelectedStringForKey:@"Select Country"];
    searchTextField.placeholder = [Localization languageSelectedStringForKey:@"Search here"];
    
    filterTable.layer.masksToBounds = true;
    filterTable.layer.cornerRadius = 5;
    filterTable.layer.borderWidth = 1;
    filterTable.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    filterTable.layer.shadowColor = [[UIColor blackColor] CGColor];
    filterTable.layer.shadowOffset = CGSizeMake(0.0, 0.5);
    filterTable.layer.shadowOpacity = 0.5;
    filterTable.layer.shadowRadius = 2.0;
    
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
    if (tableView == filterTable){
        return filterArray.count;
    }
    return [clubArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == filterTable){
        return 35;
    }
    return 250;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 101){
        
        static NSString *cellIdentifier  =@"ClubFilterCell";
        ClubFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ClubFilterCell" owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.txtLabel.text = [filterArray objectAtIndex:indexPath.row];
        
        if([filterSelectedArray containsObject:[filterArray objectAtIndex:indexPath.row]]){
            cell.imgView.image = [UIImage imageNamed:@"check.png"];
        }
        else {
            cell.imgView.image = [UIImage imageNamed:@"uncheck.png"];
        }
        
        return cell;
    }
    static NSString *cellIdentifier  =@"ClbIRISCell";
    ClbIRISCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ClbIRISCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleDefault;
    cell.nav = self;
    [cell getClubData:[clubArray objectAtIndex:indexPath.row]  title:[[clubArray objectAtIndex:indexPath.row] valueForKey:@"title"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 101){
        
        if (indexPath.row == 0){
            latestVoucher = [filterArray objectAtIndex:indexPath.row];
        }
        else if (indexPath.row == 1){
            flatDiscount = [filterArray objectAtIndex:indexPath.row];
        }
        else  if (indexPath.row == 2){
            discount = [filterArray objectAtIndex:indexPath.row];
        }
        else  if (indexPath.row == 3){
            promocode = [filterArray objectAtIndex:indexPath.row];
        }
        
        if([filterSelectedArray containsObject:[filterArray objectAtIndex:indexPath.row]]){
            [filterSelectedArray removeObject:[filterArray objectAtIndex:indexPath.row]];
        }
        else {
            [filterSelectedArray addObject:[filterArray objectAtIndex:indexPath.row]];
        }
        [filterTable reloadData];
    }
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
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    searchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self getClubList];

    
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
    
    
//    DPPickerManager * manager = [[DPPickerManager alloc]init];
//    
//    [manager showPickerWithTitle:@"Select Category" selected:@"1" strings:@[@"1",@"2",@"3"] completion:^(NSString * _Nullable value, NSInteger index, BOOL cancel) {
//        
//    }];
    
    
}

- (IBAction)countryButton:(id)sender {
    
    NSArray *arrayCountry = [_countryInfoArray valueForKey:@"countryname"];
    DPPickerManager * manager = [[DPPickerManager alloc]init];
    
    [manager showPickerWithTitle:@"Select Country" selected:@"1" strings:arrayCountry completion:^(NSString * _Nullable value, NSInteger index, BOOL cancel) {
        self->countryTextFiled.text = value;
        
    }];
    
}

- (IBAction)filterButtonAction:(id)sender {
    filterTable.hidden = false;
    [filterTable reloadData];
}
- (IBAction)applyButtonAction:(id)sender {
    [filterTable setHidden:true];
    [self getClubList];
}


-(void)getClubList{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:@"" forKey:@"Category"];
    [dictionary setValue:countryTextFiled.text forKey:@"Country"];
    [dictionary setValue:discount forKey:@"BuyOneAndGetOneFree"];
    [dictionary setValue:promocode forKey:@"PromoCode"];
    [dictionary setValue:flatDiscount forKey:@"HotDeal"];
    [dictionary setValue:latestVoucher forKey:@"NewlyAdded"];
    
    
    
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
                    [self callGetCountryCurrencyAPI];

                    
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

-(void)callGetCountryCurrencyAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetCountryCurrency"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url withHeader:[userInfoDic valueForKey:@"token"]  timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [self->_countryInfoArray addObjectsFromArray:[dictionary valueForKey:@"Countrys"]];
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
