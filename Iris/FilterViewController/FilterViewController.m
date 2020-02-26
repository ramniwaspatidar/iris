//
//  FilterViewController.m
//  Iris
//
//  Created by apptology on 05/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "DoctorSearchCell.h"
#import "Utility.h"
#import "SearchViewController.h"
#import "UIButton+CustomButton.h"
#import "AppDelegate.h"
#import "UILabel+CustomLabel.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"
@interface FilterViewController ()

@end

@implementation FilterViewController
#define MAX_LENGTH 40

- (void)viewDidLoad {
    [super viewDidLoad];
    [_submitButton setButtonCornerRadious];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        filterLbl.text =  [Localization languageSelectedStringForKey:@"Filter"];
        
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
        
        filterLbl.text =  [Localization languageSelectedStringForKey:@"Filter"];
        
        [_submitButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Clinic Name/Doctor Name"],[Localization languageSelectedStringForKey:@"Specialization"],[Localization languageSelectedStringForKey:@"Proximity"], nil];
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    [self initializeProximityData];
    //_proximityArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    _doctorNameArray = [[NSMutableArray alloc] init];
    _doctorSearchArray = [[NSMutableArray alloc] init];
    _facilityArray = [[NSMutableArray alloc] init];
    _specialityArray = [[NSMutableArray alloc] init];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _doctorTableView.backgroundColor = [UIColor clearColor];
    _doctorTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self callGetDoctorClinicsAPI];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    // Do any additional setup after loading the view.
    //_pickerView //Choose Proximity (KM)
}

-(void)initializeProximityData {
    _proximityArray = [[NSMutableArray alloc] init];
    int rangeStart = 1;
    int rangeEnd = 10;
    for (int i=rangeStart; i<=rangeEnd; i++) {
        [_proximityArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

#pragma mark Keyboard notification
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Filter"];

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

#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _doctorTableView)
    {
        return [_doctorSearchArray count];
    }
    return _placeholderArray.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _mainTableView)
    {
        static NSString *cellIdentifier  =@"FilterTableCellIdentifier";
        FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FilterTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.tag = 1000 + indexPath.row;
        if(cell.inputTextField)
        {
            cell.inputTextField.delegate = self;
            cell.inputTextField.tag =  indexPath.row;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
        }
        
        if(indexPath.row == 0)
        {
            cell.dropdownButtonWidthCons.constant = 0;
            cell.inputTextField.enabled = YES;
        }
        else
        {
            cell.inputTextField.enabled = NO;
            cell.dropdownButtonWidthCons.constant = 25;
        }
        
        cell.titleLabel.text = [_placeholderArray objectAtIndex:indexPath.row];
        
        cell.inputTextField.placeholder = [_placeholderArray objectAtIndex:indexPath.row];
        if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
            cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            
            cell.inputTextField.textAlignment  = UITextAlignmentRight;
            
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
        return cell;
    }
    else
    {
        static NSString *cellIdentifier  =@"DoctorCellIdentifier";
        DoctorSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DoctorSearchCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.titleLabel.text = [_doctorSearchArray objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];

    if(tableView == _doctorTableView)
    {
        FilterTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.inputTextField.text = [_doctorSearchArray objectAtIndex:indexPath.row];
        [_inputDataArray replaceObjectAtIndex:0 withObject:[_doctorSearchArray objectAtIndex:indexPath.row]];
        [cell.inputTextField resignFirstResponder];
        _isSearching = NO;
        _doctorTableView.hidden = YES;
    }
    else
    {
        if(indexPath.row == 1 || indexPath.row == 2)
        {
            [self.view endEditing:YES];
           if(indexPath.row == 1)
           {
                currentPicker = @"speciality";
               _pickerTitleLabel.text = [Localization languageSelectedStringForKey:@"Specialization"];
           }
           else if(indexPath.row == 2)
           {
               currentPicker = @"proximity";
               _pickerTitleLabel.text = [Localization languageSelectedStringForKey:@"Choose Proximity(Km)"];
           }
            
            if(currentPicker)
            {
                [_pickerView reloadAllComponents];
                [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
                    _pickerViewBottomCons.constant = -46;
                }
                                 completion:^(BOOL finished)
                 {
                     
                 }];
            }
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _doctorTableView)
    {
        return 35;
    }
    return 50;
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

#pragma mark - Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitButtonAction:(id)sender {
    if(self.customDelegate)
    {
        NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
        if(![[Utility trimString:[_inputDataArray objectAtIndex:0]] isEqualToString:@""])
        {
            if([_facilityArray containsObject:[_inputDataArray objectAtIndex:0]])
                [searchDictionary setValue:[_inputDataArray objectAtIndex:0] forKey:@"facility"];
            else
                [searchDictionary setValue:[_inputDataArray objectAtIndex:0] forKey:@"doctor"];
        }
        if(![[Utility trimString:[_inputDataArray objectAtIndex:1]] isEqualToString:@""])
        {
            [searchDictionary setValue:[_inputDataArray objectAtIndex:1] forKey:@"specialty"];
        }
        
        if(![[Utility trimString:[_inputDataArray objectAtIndex:2]] isEqualToString:@""])
        {
            [searchDictionary setValue:[_inputDataArray objectAtIndex:2] forKey:@"proximity"];
        }
        
        SearchViewController *searchViewController = self.customDelegate;
        [searchViewController callSearchDoctorsFacilityAPI:searchDictionary];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtn_Clicked:(id)sender
{
    int selectedRangeRow = (int)[_pickerView selectedRowInComponent:0];
    NSIndexPath *indexPath = nil;
    if([currentPicker isEqualToString:@"facility"])
    {
       // [_inputDataArray replaceObjectAtIndex:<#(NSUInteger)#> withObject:<#(nonnull id)#>];
       // indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    }
    else if([currentPicker isEqualToString:@"speciality"])
    {
        [_inputDataArray replaceObjectAtIndex:1 withObject:[_specialityArray objectAtIndex:selectedRangeRow]];
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
    }
    else if([currentPicker isEqualToString:@"proximity"])
    {
        [_inputDataArray replaceObjectAtIndex:2 withObject:[_proximityArray objectAtIndex:selectedRangeRow]];
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        
    }
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
                     completion:^(BOOL finished)
     {
         currentPicker = nil;
         
     }];
}

#pragma mark- UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _isSearching = NO;
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField.tag == 0)
    {
        _isSearching = YES;
        _activeCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_mainTableView selectRowAtIndexPath:_activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        [_mainTableView scrollToRowAtIndexPath:_activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if(textField.tag == 3)
    {
        _activeCellIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        [_mainTableView selectRowAtIndexPath:_activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        [_mainTableView scrollToRowAtIndexPath:_activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if(textField.tag == 0)
    {
        FilterTableViewCell *cell = (FilterTableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
        
        if(textField.text)
        {
            if(textField.text.length > 0)
                cell.titleLabel.hidden = NO;
            else
                cell.titleLabel.hidden = YES;
            
            [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
        }
        
        if([Utility trimString:textField.text].length == 0)
        {
            _isSearching = NO;
            _doctorTableView.hidden = YES;
            [textField resignFirstResponder];
        }
        else
        {
            NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", textField.text];
            _doctorSearchArray = [[_doctorNameArray filteredArrayUsingPredicate:resultPredicate] mutableCopy] ;
            _isSearching = YES;
            _doctorTableView.hidden = NO;
            [_doctorTableView reloadData];
        }
    }
    else if(textField.tag == 3)
    {
        FilterTableViewCell *cell = (FilterTableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
        if(textField.text)
        {
            [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    NSUInteger newLength = [textField.text length] + [string length];
    
    if(newLength > MAX_LENGTH){
        return NO;
    }
    
    if(textField.tag == 3)
    {
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
    _searchTableBottomCons.constant = keyboardRect.size.height;
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
    if(_activeCellIndexPath)
    {
        [_mainTableView scrollToRowAtIndexPath:_activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_mainTableView selectRowAtIndexPath:_activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}


#pragma mark- Picker View Methods-

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([currentPicker isEqualToString:@"facility"])
        return _facilityArray.count;
    else if([currentPicker isEqualToString:@"speciality"])
        return _specialityArray.count;
    else if([currentPicker isEqualToString:@"proximity"])
        return _proximityArray.count;
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([currentPicker isEqualToString:@"facility"])
        return _facilityArray[row];
    else if([currentPicker isEqualToString:@"speciality"])
        return _specialityArray[row];
    else if([currentPicker isEqualToString:@"proximity"])
        return _proximityArray[row];
    return @"";
}


-(void)callGetDoctorClinicsAPI
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetDoctorClinics"];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url withHeader:self.tokenString  timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     if([dictionary valueForKey:@"doctors"])
                     {
                         [_doctorNameArray addObjectsFromArray:[dictionary valueForKey:@"doctors"]];
                     }
                     if([dictionary valueForKey:@"facility"])
                     {
                         [_facilityArray addObjectsFromArray:[dictionary valueForKey:@"facility"]];
                         [_doctorNameArray addObjectsFromArray:[dictionary valueForKey:@"facility"]];
                     }
                     if([dictionary valueForKey:@"speciality"])
                     {
                         [_specialityArray addObjectsFromArray:[dictionary valueForKey:@"speciality"]];
                     }
                     [_mainTableView reloadData];
                 }
                 else if([[dictionary valueForKey:@"status"] intValue] == 3)
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
