//
//  AddReimbursmentViewController.m
//  Iris
//
//  Created by apptology on 10/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "AddReimbursmentViewController.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import "AddReimbusmentTableViewCell.h"
#import "Utility.h"
#import "UploadFileTableViewCell.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSData+Base64.h"
#import "DbManager.h"
#import "Dependent+CoreDataProperties.h"
#import "FileNameTableViewCell.h"
#import "AddReimbusmentTableViewCell1.h"
#import "MainSideMenuViewController.h"
#import "UILabel+CustomLabel.h"
#import "Localization.h"

@interface AddReimbursmentViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@end

@implementation AddReimbursmentViewController
#define  MAX_LENGTH 15
#define  MAX_OTHER_LENGTH 40
static NSInteger previousPage = 0;

typedef enum _cameraMode
{
    typeCamera = 0,
    typeLibrary = 1
    
} cameraMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    previuosStack.layer.cornerRadius = 5.0;
    previuosStack.layer.borderWidth = 1.0;
    previuosStack.layer.borderColor =  [[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    previuosStack.clipsToBounds = YES;
    
    nextStack.layer.cornerRadius = 5.0;
    nextStack.layer.borderWidth = 1.0;
    nextStack.layer.borderColor =  [[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    nextStack.clipsToBounds = YES;
   
//    _nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
//    _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          addreimburLbl.text =  [Localization languageSelectedStringForKey:@"Add Reimbursement"];
         helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        [_previousButton setTitle:[Localization languageSelectedStringForKey:@"Previous"] forState:UIControlStateNormal];

        [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
        [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];

        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"en"]];
       // [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Save"] forState:UIControlStateNormal];

    }
    else{
        [doneBtn setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
       // [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Save"] forState:UIControlStateNormal];
 helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        [_trackerDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        addreimburLbl.text =  [Localization languageSelectedStringForKey:@"Add Reimbursement"];
        
        [_previousButton setTitle:[Localization languageSelectedStringForKey:@"Previous"] forState:UIControlStateNormal];
        
        [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    previuosStack.hidden = YES;
    _scrollView.delaysContentTouches = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    previousPage = 0;
    
    _trackerDatePicker.maximumDate = [NSDate date];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    

    self.dateFormatter1.dateFormat = @"dd/MM/yyyy";
    
    self.dateFormatter2 = [[NSDateFormatter alloc] init];
    self.dateFormatter2.dateFormat = @"dd MMMM yyyy";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateFormatter2  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

    }else{
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateFormatter2  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];

        
    }
    
    _uploadFileArray = [[NSMutableArray alloc] init];
    _countryInfoArray = [[NSMutableArray alloc] init];
    _page1TitleArray = [[NSMutableArray alloc] initWithObjects: [Localization languageSelectedStringForKey:@"Select Member"], [Localization languageSelectedStringForKey:@"Treatment Date"] ,[Localization languageSelectedStringForKey:@"Treatment Country"]  ,[Localization languageSelectedStringForKey:@"Claim Amount"] ,[Localization languageSelectedStringForKey:@"Currency"] ,[Localization languageSelectedStringForKey:@"Towards"], nil];
    _page2TitleArray = [[NSMutableArray alloc] initWithObjects: [Localization languageSelectedStringForKey:@"Account Name"], [Localization languageSelectedStringForKey:@"Bank Name"], [Localization languageSelectedStringForKey:@"Branch Name"],@"IBAN",@"Swift Code",nil];
    
    _page1InputArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"", nil];
    
    _page2InputArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    
    _userNameArray = [[NSMutableArray alloc] init];
    _towardArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"individual"],[Localization languageSelectedStringForKey:@"company"], nil];
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];

    NSString *emiratesId = [userInfoDic valueForKey:@"emiratesid"];
    NSString *defaultPolicy = @"True";
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",emiratesId,defaultPolicy];
    _currentUser = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    
    [_userNameArray addObject:_currentUser.fullname];
    for(Dependent *dependent in [_currentUser.depend allObjects])
    {
        [_userNameArray addObject:dependent.fullname];
    }
    
    [self callGetCountryCurrencyAPI];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
        buttonBottomViewCons.constant = -35;
    }
    
}
//Localization languageSelectedStringForKey:@"company"]
#pragma mark Keyboard notification
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic: [Localization languageSelectedStringForKey:@"Add Reimbursement"]];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!isSecondTime)
    {
        [self setScrollViewContent];
        //[self.view layoutIfNeeded];
    }
    isSecondTime = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



-(void)setScrollViewContent
{
    CGFloat x = 0;
    CGFloat y = 0;
    //CGRect scrollViewFrame = _scrollView.frame;
    //scrollViewFrame.size.height = scrollViewFrame.size.height + 30;
    //_scrollView.frame = scrollViewFrame;
    for(int i = 0; i < 3; i++)
    {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = _scrollView.frame.size.height;
        CGRect tableFrame = CGRectMake(x, y, width, height);
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = YES;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.userInteractionEnabled = YES;
        
        tableView.bounces = YES;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 65;
        tableView.tag = i+10;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_scrollView addSubview:tableView];
        x = x + width;
        _scrollView.contentSize = CGSizeMake(x, 100);
        
    }
}


#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 10)
        return _page1TitleArray.count;
    else if(tableView.tag == 11)
        return _page2TitleArray.count;
    else
        return _uploadFileArray.count + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if(tableView.tag == 12)
     {
         if(_uploadFileArray.count > indexPath.row)
             return 40;
         return 320;
     }
     return 65;
 }

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 10)
    {
        
        static NSString *cellIdentifier  =@"AddReimbursementCellIdentifier";
        AddReimbusmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddReimbusmentTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row;
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        if(cell.inputTextField)
        {
            cell.inputTextField.tag = 100 + (int)indexPath.row;
            cell.inputTextField.delegate = self;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        cell.inputTextField.enabled = YES;
        cell.calendarButtonWidthCons.constant = 0;
        
        
            if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 0 || indexPath.row == 5)
            {
                cell.inputTextField.enabled = NO;
                cell.calendarButtonWidthCons.constant = 30;
#if 0
                if(indexPath.row == 0)
                {
                    if([_userNameArray count] == 1)
                    {
                        [_page1InputArray replaceObjectAtIndex:0 withObject:[_userNameArray firstObject]];
                        cell.calendarButtonWidthCons.constant = 0;
                    }
                }
#endif
                if(cell.calendarButton)
                {
                    if(indexPath.row == 1)
                    {
                        [cell.calendarButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
                    }
                    else
                    {
                        [cell.calendarButton setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];
                    }
                }
            }
            else if(indexPath.row == 3)
            {
                cell.inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
            
            
            cell.titleLabel.text = [_page1TitleArray objectAtIndex:indexPath.row];
            cell.inputTextField.placeholder = [_page1TitleArray objectAtIndex:indexPath.row];
            
            if(![[_page1InputArray objectAtIndex:indexPath.row] isEqualToString:@""])
            {
                
                cell.inputTextField.text = [_page1InputArray objectAtIndex:indexPath.row];
                cell.titleLabel.hidden = NO;
                
                if(indexPath.row == 1)
                {
                    NSString *dateSt = [_page1InputArray objectAtIndex:indexPath.row];
                    NSDate *dateObj = [self.dateFormatter1 dateFromString:dateSt];
                    NSString *newDateString = [self.dateFormatter2 stringFromDate:dateObj];
                    cell.inputTextField.text = newDateString;
                }
            }
            else
            {
                cell.inputTextField.text = @"";
                cell.titleLabel.hidden = YES;
            }
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            cell.inputTextField.textAlignment  = NSTextAlignmentLeft;

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
    else if(tableView.tag == 11){
        
        static NSString *cellIdentifier  =@"AddReimbursementCellIdentifier1";
        AddReimbusmentTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddReimbusmentTableViewCell1" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row;
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        if(cell.inputTextField)
        {
            cell.inputTextField.tag = 1000 + (int)indexPath.row;
            cell.inputTextField.delegate = self;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        cell.inputTextField.enabled = YES;
        //cell.calendarButtonWidthCons.constant = 0;
        {
            
            cell.titleLabel.text = [_page2TitleArray objectAtIndex:indexPath.row];
            
            cell.inputTextField.placeholder = [_page2TitleArray objectAtIndex:indexPath.row];
            
            if(![[_page2InputArray objectAtIndex:indexPath.row] isEqualToString:@""])
            {
                cell.inputTextField.text = [_page2InputArray objectAtIndex:indexPath.row];
                cell.titleLabel.hidden = NO;
            }
            else
            {
                cell.inputTextField.text = @"";
                cell.titleLabel.hidden = YES;
            }
        }
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            cell.inputTextField.textAlignment  = NSTextAlignmentLeft;

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
    else if(tableView.tag == 12)
    {
        //filenameidentifier
        if(_uploadFileArray.count > 0 && indexPath.row < _uploadFileArray.count)
        {
            static NSString *cellIdentifier  =@"filenameidentifier";
            FileNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FileNameTableViewCell" owner:self options:nil];
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
            }
            
            if(cell.deleteButton)
            {
                cell.deleteButton.tag = indexPath.row;
                [cell.deleteButton addTarget:self
                                    action:@selector(deleteButtonAction:)
                          forControlEvents:UIControlEventTouchUpInside];
            }
            cell.filename.text = [[_uploadFileArray objectAtIndex:indexPath.row] valueForKey:@"filename"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        static NSString *cellIdentifier  =@"UploadFileCellIdentifier";
        UploadFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UploadFileTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        if(cell.saveButton)
        {
            [cell.saveButton addTarget:self
                                      action:@selector(saveButtonAction:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        if(cell.uploadFileButton)
        {
            [cell.uploadFileButton addTarget:self
                                      action:@selector(uploadFileAction:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.tag = indexPath.row;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];

    if((indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5  || indexPath.row == 0) && tableView.tag == 10)
    {
        [self.view endEditing:YES];
#if 0
        if(indexPath.row == 0 && [_userNameArray count] == 1)
        {
            return;
        }
#endif
                
        [_trackerDatePicker setDatePickerMode:UIDatePickerModeDate];
        
        activeCellIndexPath = indexPath;
        
        if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5)
        {
            _pickerView.hidden = NO;
            _trackerDatePicker.hidden = YES;
            if(indexPath.row == 0)
            {
                selectedPicker = @"user";
            }
            else if(indexPath.row == 2)
            {
                selectedPicker = @"country";
            }
            else
            {
                selectedPicker = @"toward";
            }
            [_pickerView reloadAllComponents];
            
        }
        else
        {
            _pickerView.hidden = YES;
            _trackerDatePicker.hidden = NO;
            [_trackerDatePicker reloadInputViews];
        }
        
        [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
            _pickerViewBottomCons.constant = -46;
        }
                         completion:^(BOOL finished)
         {
             [_trackerDatePicker setDate:[NSDate date]];
         }];
    }
    
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 20)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    UITableView *currentTableView1 = [self.view viewWithTag:10];
    UITableView *currentTableView2 = [self.view viewWithTag:11];
    UITableView *currentTableView3 = [self.view viewWithTag:12];

    NSString *headerString = nil;
    if(tableView == currentTableView1)
    {
        headerString = [Localization languageSelectedStringForKey:@"Treatment Details"];
    }
    else if(tableView == currentTableView2)
    {
        headerString = [Localization languageSelectedStringForKey:@"Bank Details"];
    }
    else if(tableView == currentTableView3)
    {
        headerString = [Localization languageSelectedStringForKey:@"File Details"];
    }
    /* Section header is in 0th index... */
    [label setText:headerString];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}


#pragma mark - Button Action Methods -

-(IBAction)uploadFileAction:(id)sender
{
    [self openCamera];
}

-(void)openCamera
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"Please select"] message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addPhotoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Library"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         capturedMode = typeLibrary;
                                         UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                         [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                         [imagePicker setDelegate:self];
                                         [imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
                                         [self presentViewController:imagePicker animated:YES completion:nil];
                                     }];
    
    UIAlertAction *addVideoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Camera"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                                         {
                                             capturedMode = typeCamera;
                                             
                                             UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                             [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                             imagePicker.showsCameraControls = YES;
                                             [imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
                                             
                                             [imagePicker setDelegate:self];
                                             [self presentViewController:imagePicker animated:YES completion:nil];
                                         }
                                         else
                                         {
                                             [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"This feature is not supported by your device."] block:^(int index)
                                              {
                                              }];
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

-(IBAction)saveButtonAction:(id)sender
{
    BOOL isEmptyField = [self validateForm];
    
    if(!isEmptyField)
    {
        [self callSaveAddReimbursementAPI];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtn_Clicked:(id)sender
{
    NSString *dateString = nil;
    NSMutableArray *indexArray = [[NSMutableArray alloc] initWithObjects:activeCellIndexPath, nil];
    if(activeCellIndexPath.row == 1)
    {
        dateString = [self.dateFormatter1 stringFromDate:_trackerDatePicker.date];
        
        [_page1InputArray replaceObjectAtIndex:activeCellIndexPath.row withObject:dateString];
    }
    else if(activeCellIndexPath.row == 0 || activeCellIndexPath.row == 2 || activeCellIndexPath.row == 5)
    {
        int selectedRangeRow = (int)[_pickerView selectedRowInComponent:0];
        if(activeCellIndexPath.row == 0)
        {
            [_page1InputArray replaceObjectAtIndex:activeCellIndexPath.row withObject:[_userNameArray objectAtIndex:selectedRangeRow]];
        }
        else if(activeCellIndexPath.row == 2)
        {
           NSDictionary *countryDictionary = [_countryInfoArray objectAtIndex:selectedRangeRow];
            [_page1InputArray replaceObjectAtIndex:activeCellIndexPath.row withObject:[countryDictionary valueForKey:@"countryname"]];
           
            if([[[countryDictionary valueForKey:@"currencies"] firstObject]valueForKey:@"currencycode"] && (![[[[countryDictionary valueForKey:@"currencies"] firstObject]valueForKey:@"currencycode"] isEqualToString:@""]))
            {
                [_page1InputArray replaceObjectAtIndex:4 withObject:[[[countryDictionary valueForKey:@"currencies"] firstObject]valueForKey:@"currencycode"]];
            }
            [indexArray addObject:[NSIndexPath indexPathForRow:4 inSection:0]];
            selectedCountryId = [countryDictionary valueForKey:@"countryID"];
        }
        else
        {
            [_page1InputArray replaceObjectAtIndex:activeCellIndexPath.row withObject:[_towardArray objectAtIndex:selectedRangeRow]];
        }
    }
    
    UITableView *currentTableView = [self.view viewWithTag:10];
    
    [currentTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
    
    AddReimbusmentTableViewCell *cell = [currentTableView cellForRowAtIndexPath:activeCellIndexPath];
    cell.titleLabel.hidden = NO;
    
    [UIView animateWithDuration:2.5 delay:0.1 options: UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerViewBottomCons.constant = -263;
    }
                     completion:^(BOOL finished)
     {
     }];
}


- (IBAction)previousButtonAction:(id)sender {
    
    int xPosition = _scrollView.contentOffset.x - _scrollView.frame.size.width;
    
    [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
 
//    _nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
//    _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    _nextButton.hidden = NO;
    if(_scrollView.contentOffset.x > 0) {
        if(![[_page1InputArray objectAtIndex:5] isEqualToString:[Localization languageSelectedStringForKey:@"individual"]]) {
            xPosition -= _scrollView.frame.size.width;
        }
        [_scrollView setContentOffset:CGPointMake(xPosition, 0) animated:NO];
    }
    
    if(xPosition == 0)
    {
        previuosStack.hidden = YES;
    }
    
}

-(void)deleteButtonAction:(id)sender
{
    UIButton *buttton = sender;
    int index = (int)buttton.tag;
    [_uploadFileArray removeObjectAtIndex:index];
    
    UITableView *currentTableView = [self.view viewWithTag:12];
    
    [currentTableView reloadData];
}
- (IBAction)nextButtonAction:(id)sender {
    
    BOOL isEmptyField = NO;
    NSString *fieldName = nil;
    if(previousPage == 0)
    {
        for(int i = 0; i<_page1InputArray.count; i++)
        {
            if([[Utility trimString:[_page1InputArray objectAtIndex:i]] isEqualToString:@""])
            {
                isEmptyField = YES;
                fieldName = [_page1TitleArray objectAtIndex:i];
                fieldName = [NSString stringWithFormat:@"%@ %@ %@.",[Localization languageSelectedStringForKey:@"Please fill"],fieldName, [Localization languageSelectedStringForKey:@"field"]];
                break;
            }
        }
    }
    else if(previousPage == 1 && [[_page1InputArray objectAtIndex:5] isEqualToString:[Localization languageSelectedStringForKey:@"individual"]])
    {
        for(int i = 0; i<_page2InputArray.count; i++)
        {
            if([[Utility trimString:[_page2InputArray objectAtIndex:i]] isEqualToString:@""])
            {
                isEmptyField = YES;
                fieldName = [_page2TitleArray objectAtIndex:i];
                fieldName = [NSString stringWithFormat:@"%@ %@ %@.",[Localization languageSelectedStringForKey:@"Please fill"],fieldName, [Localization languageSelectedStringForKey:@"field"]];
                break;
            }
        }
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@",fieldName] block:^(int index) {
        }];
        return;
    }
    
    int xPosition =  _scrollView.contentOffset.x + _scrollView.frame.size.width;
    if(previousPage == 0 && ![[_page1InputArray objectAtIndex:5] isEqualToString:[Localization languageSelectedStringForKey:@"individual"]])
        xPosition +=  _scrollView.frame.size.width;
    previuosStack.hidden = NO;
    
    
    
    if(xPosition < _scrollView.contentSize.width)
    {
        [_scrollView setContentOffset:CGPointMake(xPosition, 0) animated:NO];
    }
    else
    {
        [self saveButtonAction:nil];
    }
    if(xPosition + _scrollView.frame.size.width == _scrollView.contentSize.width)
    {
       [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
       
//        _nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
//        _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    }
    
}

-(BOOL)validateForm
{
    BOOL isEmptyField = NO;
    NSString *fieldName = nil;
    for(int i = 0; i<_page1InputArray.count; i++)
    {
        if([[Utility trimString:[_page1InputArray objectAtIndex:i]] isEqualToString:@""])
        {
            isEmptyField = YES;
            fieldName = [_page1TitleArray objectAtIndex:i];
            if(i == 0 || i == 1 || i == 2 || i == 5)
                fieldName = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please select"],[fieldName lowercaseString]];
            fieldName = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString]];
            break;
        }
    }
    if(!isEmptyField)
    {
        if([[_page1TitleArray objectAtIndex:5] isEqualToString:[Localization languageSelectedStringForKey:@"individual"]])
        {
            for(int i = 0; i<_page2InputArray.count; i++)
            {
                if([[Utility trimString:[_page2InputArray objectAtIndex:i]] isEqualToString:@""])
                {
                    isEmptyField = YES;
                    fieldName = [_page2TitleArray objectAtIndex:i];
                    fieldName = [NSString stringWithFormat:@"%@ %@.",[Localization languageSelectedStringForKey:@"Please enter"],[fieldName lowercaseString]];
                    break;
                }
            }
        }
#if 0
        if(!isEmptyField)
        {
            if(_uploadFileArray.count == 0)
            {
                fieldName = [Localization languageSelectedStringForKey:@"Please upload file."];
                isEmptyField = YES;
            }
        }
#endif
    }
    if(isEmptyField)
    {
        [Utility showAlertViewControllerIn:self title:nil message:[NSString stringWithFormat:@"%@",fieldName] block:^(int index) {
        }];
    }
    return isEmptyField;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UIImage *capturedImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *compressedImage = [[self compressImage:capturedImage] copy];
    NSData *imageData = UIImageJPEGRepresentation(compressedImage,0.5);
    compressedImage = [UIImage imageWithData:imageData];
    
    NSString *encodedImageString = [self encodeToBase64String: compressedImage];
    NSMutableDictionary *fileInfoDictionary = [[NSMutableDictionary alloc] init];
    [fileInfoDictionary setValue:encodedImageString forKey:@"filecontent_base64"];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%d",[_page1InputArray objectAtIndex:0],(int)_uploadFileArray.count+1];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMddYYYYmmss"];
    
    [fileInfoDictionary setValue:[NSString stringWithFormat:@"%@.jpg",[dateFormatter stringFromDate:[NSDate date]]] forKey:@"filename"];
    [fileInfoDictionary setValue:@"" forKey:@"reimbursementid"];
    [_uploadFileArray addObject:fileInfoDictionary];
    
    UITableView *currentTableView = [self.view viewWithTag:12];

    [currentTableView reloadData];
    //[self performSelector:@selector(moveToCroperScreen:) withObject:compressedImage afterDelay:0];
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
    float compressionQuality = 0.7;//50 percent compression
    
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
    NSString *encodedImageString = [self encodeToBase64String: capturedImage];
    NSMutableDictionary *fileInfoDictionary = [[NSMutableDictionary alloc] init];
    [fileInfoDictionary setValue:encodedImageString forKey:@"filecontent_base64"];
    [fileInfoDictionary setValue:[NSString stringWithFormat:@"filename.png"] forKey:@"filename"];
    [_uploadFileArray addObject:fileInfoDictionary];
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

#pragma mark- UITextField Delegate methods -

-(void)textFieldDidChange:(UITextField *)textField
{
    if(_scrollView.contentOffset.x < 10)
    {
        AddReimbusmentTableViewCell *cell = (AddReimbusmentTableViewCell*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        if(textField.text)
        {
            if(textField.text.length > 0)
                cell.titleLabel.hidden = NO;
            else
                cell.titleLabel.hidden = YES;
            
            [_page1InputArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
        }
    }
    else
    {
        AddReimbusmentTableViewCell1 *cell = (AddReimbusmentTableViewCell1*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        if(textField.text)
        {
            if(textField.text.length > 0)
                cell.titleLabel.hidden = NO;
            else
                cell.titleLabel.hidden = YES;
            
            [_page2InputArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if(_scrollView.contentOffset.x < 10)
    {
        AddReimbusmentTableViewCell *cell = (AddReimbusmentTableViewCell*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        
        activeCellIndexPath = [tableView indexPathForCell:cell];
    }
    else
    {
        AddReimbusmentTableViewCell1 *cell = (AddReimbusmentTableViewCell1*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        
        activeCellIndexPath = [tableView indexPathForCell:cell];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(_scrollView.contentOffset.x < 10)
    {
        AddReimbusmentTableViewCell *cell = (AddReimbusmentTableViewCell*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        //cell.titleLabel.hidden = YES;
        if((indexPath.row == 5 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) && tableView.tag == 10)
        {
            [textField resignFirstResponder];
            return YES;
        }
        else if(indexPath.row == 4 && tableView.tag == 11)
        {
            [textField resignFirstResponder];
            return YES;
        }
        
        activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        [tableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [tableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
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
    }
    else
    {
        AddReimbusmentTableViewCell1 *cell = (AddReimbusmentTableViewCell1*)textField.superview.superview;
        UITableView *tableView = (UITableView*)cell.superview;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        //cell.titleLabel.hidden = YES;
        if(indexPath.row == 4 && tableView.tag == 11)
        {
            [textField resignFirstResponder];
            return YES;
        }
        
        activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        [tableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [tableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        
        cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
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
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    
    if(textField.tag == 103)
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
    else
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > 40){
            return NO;
        }
    }
    return YES;
}
/*
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
*/

#pragma mark - move view when keyboard comes into play
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if(keyboardShown)
        return;
    
    keyboardShown = YES;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _scrollViewBottomCons.constant = kbSize.height;
    [self.view layoutIfNeeded];
    
    UITableView *currentTableView = nil;
    if(_scrollView.contentOffset.x < 10)
        currentTableView = [self.view viewWithTag:10];
    else
        currentTableView = [self.view viewWithTag:11];
    
    CGRect tableFrame = currentTableView.frame;
    tableFrame.size.height = _scrollView.frame.size.height;
    currentTableView.frame = tableFrame;
    
    return;
    
    /*NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [_scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
    return;
    
    
    // Get the keyboard size
    UITableView *currentTableView = nil;
    if(_scrollView.contentOffset.x < 10)
        currentTableView = [self.view viewWithTag:10];
    else
        currentTableView = [self.view viewWithTag:11];

    UIScrollView *tableView;
    if([currentTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)currentTableView.superview;
    else
        tableView = currentTableView;
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
    */
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
    if(!keyboardShown)
        return;
    
    keyboardShown = NO;
    
    _scrollViewBottomCons.constant = 60.0f;
    [self.view layoutIfNeeded];
    
    UITableView *currentTableView = nil;
    if(_scrollView.contentOffset.x < 10)
        currentTableView = [self.view viewWithTag:10];
    else
        currentTableView = [self.view viewWithTag:11];
    
    CGRect tableFrame = currentTableView.frame;
    tableFrame.size.height = _scrollView.frame.size.height;
    currentTableView.frame = tableFrame;
    
    return;
   
    /*UITableView *currentTableView = nil;
    if(_scrollView.contentOffset.x < 10)
        currentTableView = [self.view viewWithTag:10];
    else
        currentTableView = [self.view viewWithTag:11];
    
    UIScrollView *tableView;
    if([currentTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)currentTableView.superview;
    else
        tableView = currentTableView;
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
     */
    
}

- (void) tableAnimationEnded:(NSString*)animationID finished:(NSNumber *)finished contextInfo:(void *)context
{
    // Scroll to the active cell
    if(activeCellIndexPath)
    {
        UITableView *currentTableView = nil;
        if(_scrollView.contentOffset.x < 10)
            currentTableView = [self.view viewWithTag:10];
        else
            currentTableView = [self.view viewWithTag:11];
        
        [currentTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [currentTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}



#pragma mark- Picker View Methods-

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([selectedPicker isEqualToString:@"user"])
        return _userNameArray.count;
    else if([selectedPicker isEqualToString:@"country"])
        return _countryInfoArray.count;
    else
        return _towardArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([selectedPicker isEqualToString:@"user"])
        return _userNameArray[row];
    else if([selectedPicker isEqualToString:@"country"])
        return [_countryInfoArray[row] valueForKey:@"countryname"];
    else
        return _towardArray[row];

}

#pragma mark- Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == _scrollView)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        if (previousPage != page) {
            // Page has changed, do your thing!
            // ...
            // Finally, update previous page
            if(page == 0)
            {
                previuosStack.hidden = YES;
            }
            else
            {
                previuosStack.hidden = NO;
            }
            if(page == 2)
            {
                //_nextButton.hidden = YES;
                [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
                
//                _nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
//                _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
            }
            else
            {
                [_nextButton setTitle:[Localization languageSelectedStringForKey:@"Next"] forState:UIControlStateNormal];
//                _nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
//                _nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
                //_nextButton.hidden = NO;
            }
            previousPage = page;
        }
    }
    
}


#pragma mark - Server API Call -

-(void)callSaveAddReimbursementAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    //[dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    NSMutableDictionary *bankInfoDic = [[NSMutableDictionary alloc] init];
    
    [bankInfoDic setValue:[_page2InputArray objectAtIndex:0] forKey:@"accountname"];
    [bankInfoDic setValue:[_page2InputArray objectAtIndex:1] forKey:@"bankname"];
    [bankInfoDic setValue:[_page2InputArray objectAtIndex:2] forKey:@"branchname"];
    [bankInfoDic setValue:[_page2InputArray objectAtIndex:3] forKey:@"iban"];
    [bankInfoDic setValue:[_page2InputArray objectAtIndex:4] forKey:@"swiftcode"];
    
    [dictionary setValue:bankInfoDic forKey:@"bankdetails"];
    
    
    
    if([_currentUser.fullname isEqualToString:[_page1InputArray objectAtIndex:0]])
    {
        [dictionary setValue:_currentUser.memberid forKey:@"memberid"];
        [dictionary setValue:_currentUser.memberid forKey:@"principalmemberid"];
    }
    else
    {
        for(Dependent *dependent in [_currentUser.depend allObjects])
        {
            if([dependent.fullname isEqualToString:[_page1InputArray objectAtIndex:0]])
            {
                NSLog(@"Member id %@",dependent.memberid);
                [dictionary setValue:dependent.memberid forKey:@"memberid"];
                [dictionary setValue:_currentUser.memberid forKey:@"principalmemberid"];
                break;
            }
        }
        
    }
    
    [dictionary setValue:[_page1InputArray objectAtIndex:1] forKey:@"treatmentdate"];
    [dictionary setValue:selectedCountryId forKey:@"countryoftreatment"];
    [dictionary setValue:[_page1InputArray objectAtIndex:3] forKey:@"claimedamount"];
    [dictionary setValue:[_page1InputArray objectAtIndex:4] forKey:@"claimedcurrency"];
    [dictionary setValue:[_page1InputArray objectAtIndex:5] forKey:@"towards"];

    if(_uploadFileArray.count > 0)
        [dictionary setValue:_uploadFileArray forKey:@"uploadedfiles"];
    else
        [dictionary setValue:@"" forKey:@"uploadedfiles"];

    

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddReimbursement"];
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
                     for(int i = 0; i < _page1InputArray.count; i++)
                         [_page1InputArray replaceObjectAtIndex:i withObject:@""];
                     
                     for(int i = 0; i < _page2InputArray.count; i++)
                         [_page2InputArray replaceObjectAtIndex:i withObject:@""];
                     [_uploadFileArray removeAllObjects];
                    
                     UITableView * tableView1 = [self.view viewWithTag:10];
                     [tableView1 reloadData];
                    UITableView * tableView2 = [self.view viewWithTag:11];
                     [tableView2 reloadData];
                     UITableView * tableView3 = [self.view viewWithTag:12];
                     [tableView3 reloadData];

                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index)
                      {
                          [self.navigationController popViewControllerAnimated:YES];
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
                     [_countryInfoArray addObjectsFromArray:[dictionary valueForKey:@"Countrys"]];
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
