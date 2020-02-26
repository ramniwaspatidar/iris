//
//  ReimbursmentViewController.m
//  Iris
//
//  Created by apptology on 17/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "ReimbursmentViewController.h"
#import "ReimbursmentTableViewCell.h"
#import "Constant.h"
#import "Utility.h"
#import "DbManager.h"
#import "ConnectionManager.h"
#import "TestReportViewController.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "PendingReimbursmentTableViewCell.h"
#import "FileDetailViewController.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface ReimbursmentViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *pendingDateFormatter;
@property (nonatomic,strong)NSDictionary *personDetailDictionary;


@end

@implementation ReimbursmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    shouldLoadReimbursemenent = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delaysContentTouches = YES;
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd/MMM/yyyy";
    
    self.pendingDateFormatter = [[NSDateFormatter alloc] init];
    self.pendingDateFormatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.pendingDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
    }else{
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.pendingDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    _reimbursmentApprovedArray = [[NSMutableArray alloc] init];
    _reimbursmentPendingArray = [[NSMutableArray alloc] init];

    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 160;
    
    _pendingTableView.backgroundColor = [UIColor clearColor];
    _pendingTableView.rowHeight = UITableViewAutomaticDimension;
    _pendingTableView.estimatedRowHeight = 160;
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    [self initialSetupView];
}
/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(shouldLoadReimbursemenent)
        [self callUserReimbursementHistoryAPI];
    
    shouldLoadReimbursemenent = YES;
}*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[Localization languageSelectedStringForKey:@"Reimbursement"];
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Reimbursement"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(shouldLoadReimbursemenent && [self.tabBarController.selectedViewController.childViewControllers.lastObject isEqual:self])
    {
        [self callUserReimbursementHistoryAPI];
    }
    shouldLoadReimbursemenent = YES;
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
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          reimburLbl.text =  [Localization languageSelectedStringForKey:@"Reimbursement"];
        [approveBtn setTitle:[Localization languageSelectedStringForKey:@"APPROVED"] forState:UIControlStateNormal];
        [pendingBtn setTitle:[Localization languageSelectedStringForKey:@"PENDING"] forState:UIControlStateNormal];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        reimburLbl.text =  [Localization languageSelectedStringForKey:@"Reimbursement"];
        [approveBtn setTitle:[Localization languageSelectedStringForKey:@"APPROVED"] forState:UIControlStateNormal];
        [pendingBtn setTitle:[Localization languageSelectedStringForKey:@"PENDING"] forState:UIControlStateNormal];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    tableContainerViewWidthCons.constant = (self.view.frame.size.width *2);
    
    _scrollView.contentSize = CGSizeMake(tableContainerViewWidthCons.constant, self.view.frame.size.height);
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _mainTableView)
    {
        return _reimbursmentApprovedArray.count;
    }
    else
    {
        return _reimbursmentPendingArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _mainTableView)
    {
        static NSString *cellIdentifier  =@"ReimbursementCellIdentifier";
        ReimbursmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReimbursmentTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDate *date = [self.dateFormatter1 dateFromString:[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"treatmentdate"]];
        
        self.dateFormatter.dateFormat = @"dd MMM yyyy";
        NSString *treatmentDateString = [self.dateFormatter stringFromDate:date];
        cell.treatmentDate.text = treatmentDateString;
        
        NSString *claimedPaymentDateString = [[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"claimedpaymentdate"];
        //[Localization languageSelectedStringForKey:@"Claim ID"]
        cell.claimId.text = [NSString stringWithFormat:@"%@:                            %@", [Localization languageSelectedStringForKey:@"Claim ID"],[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"claimid"]];
        cell.providerName.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"providername"]];
        cell.claimType.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"claimtype"]];
        cell.treatmentDetail.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"treatmentdetails"]];
        cell.approvedAmount.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"approvedamount"]];
        cell.claimedCurrency.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"claimedcurrency"]];
        
        cell.diagnosisDetail.text = [NSString stringWithFormat:@"%@",[[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"icddescription"]];
        cell.claimedPaymentDate.text = [NSString stringWithFormat:@"%@",claimedPaymentDateString];
        NSArray *labTestArray = [[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"labtests"];
        if(labTestArray.count > 0)
        {
            cell.labTestHeightCons.constant = 16.5;
        }
        else
        {
            cell.labTestHeightCons.constant = 0;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier  =@"PendingReimbursmentCellIdentifier";
        PendingReimbursmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PendingReimbursmentTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDate *date = [self.pendingDateFormatter dateFromString:[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"treatmentdate"]];
        
        self.dateFormatter.dateFormat = @"dd MMM yyyy";
        NSString *treatmentDateString = [self.dateFormatter stringFromDate:date];
        cell.treatmentDate.text = treatmentDateString;
        //[Localization languageSelectedStringForKey:@"Reimbursement ID"]
        cell.memberId.text = [NSString stringWithFormat:@"%@:  %@",[Localization languageSelectedStringForKey:@"Reimbursement ID"],[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"reimbursementid"]];
        //cell.principalMemberId.text = [NSString stringWithFormat:@"%@",[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"principalmemberid"]];
        cell.countryOfTreatment.text = [NSString stringWithFormat:@"%@",[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"countryoftreatment"]];
        cell.claimedAmount.text = [NSString stringWithFormat:@"%@",[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"claimedamount"]];
       
        cell.claimCurrency.text = [NSString stringWithFormat:@"%@",[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"claimedcurrency"]];
        
        cell.toward.text = [[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"towards"];
        
        if([[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"towards"] isEqualToString:@"individual"])
        {
            cell.labTestHeightCons.constant = 105;
            
            cell.bankName.text = [NSString stringWithFormat:@"%@",[[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"bankdetails"] valueForKey:@"bankname"]];
            
            cell.branchName.text = [NSString stringWithFormat:@"%@",[[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"bankdetails"] valueForKey:@"branchname"]];
            
            cell.accountName.text = [NSString stringWithFormat:@"%@",[[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"bankdetails"] valueForKey:@"accountname"]];
            
            cell.iban.text = [NSString stringWithFormat:@"%@",[[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"bankdetails"] valueForKey:@"iban"]];
            
            cell.swiftcode.text = [NSString stringWithFormat:@"%@",[[[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"bankdetails"] valueForKey:@"swiftcode"]];
        }
        else
            cell.labTestHeightCons.constant = 0;

        
        NSArray *uploadedFilesArray = [[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"uploadedfiles"];
        
        for(id view in cell.fileView.subviews)
        {
            if([view isKindOfClass:[UIButton class]])
            {
                UIButton *button = view;
                //label.text = @"";
                [button setAttributedTitle:[[NSMutableAttributedString alloc] initWithString:@""] forState:UIControlStateNormal];

//                [button setTitle:@"" forState:UIControlStateNormal];
            }
        }
        if(uploadedFilesArray.count > 0)
        {
            int yAxis = 20;
            for(int i = 0; i < uploadedFilesArray.count; i++)
            {
                UIButton *fileButton = [UIButton buttonWithType:UIButtonTypeCustom];

                [fileButton addTarget:self
                           action:@selector(showFileAction:)
                 forControlEvents:UIControlEventTouchUpInside];
               // [fileButton setTitle:[[uploadedFilesArray objectAtIndex:i] valueForKey:@"filename"] forState:UIControlStateNormal];
                fileButton.frame = CGRectMake(5, yAxis, cell.frame.size.width - 15, 25);
                [fileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [fileButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
                fileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                
                NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:[[uploadedFilesArray objectAtIndex:i] valueForKey:@"filename"]];
                [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];

                NSRange range = (NSRange){0,[commentString length]};
                [commentString enumerateAttribute:NSFontAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                    UIFont *replacementFont =  [UIFont systemFontOfSize:10.0];
                    [commentString addAttribute:NSFontAttributeName value:replacementFont range:range];
                }];

                UIColor* textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
                [commentString setAttributes:@{NSForegroundColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
                [fileButton setAttributedTitle:commentString forState:UIControlStateNormal];
                

                fileButton.tag = (1000*indexPath.row) + i;

                [cell.fileView addSubview:fileButton];
                yAxis = yAxis + 20;
            }
            cell.filedetailViewHeightCons.constant = yAxis ;
        }
        else
        {
            cell.filedetailViewHeightCons.constant = 0;
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(void)showFileAction:(id)sender
{
    
    [self performSegueWithIdentifier:kFileViewIdentifier sender:sender];
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _mainTableView)
    {
        NSArray *labTestArray = [[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"labtests"];
        if(labTestArray.count > 0)
        {
            return 230;
        }
        else
        {
            return 213;
        }
    }
    else
    {
        if(_reimbursmentPendingArray.count > 0)
        {
            NSArray *labTestArray = [[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"labtests"];
            if(labTestArray.count > 0)
            {
                return 230;
            }
            else
            {
                return 213;
            }
        }
    }
    return 0;
}*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    //NSString *string =[_headerTitleArray objectAtIndex:section];
    /* Section header is in 0th index... */
    //[label setText:string];
    //[view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kTestReportIdentifier])
    {
        NSArray *testReportArray = (NSArray*)sender;
        TestReportViewController *testReportViewControllerViewController = segue.destinationViewController;
        testReportViewControllerViewController.reportsArray = [testReportArray mutableCopy];
    }
    else if ([segue.identifier isEqualToString:kAddReimbursementIdentifier])
    {
        
    }
    else if ([segue.identifier isEqualToString:kFileViewIdentifier])
    {
        shouldLoadReimbursemenent = NO;
        UIButton *button = sender;
        int cellIndex = (int)button.tag /1000;
        int fileIndex = (int)button.tag % 1000;
        
        NSDictionary *currentDictionary = [_reimbursmentPendingArray objectAtIndex:cellIndex];
        
        NSArray *fileInfoArray = [currentDictionary valueForKey:@"uploadedfiles"];
        
        FileDetailViewController *fileDetailController = segue.destinationViewController;
        fileDetailController.fileInfoDic = [[fileInfoArray objectAtIndex:fileIndex] copy];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *labTestArray = nil;
    if(tableView == _mainTableView)
        labTestArray = [[_reimbursmentApprovedArray objectAtIndex:indexPath.row] valueForKey:@"labtests"];
    else
        labTestArray = [[_reimbursmentPendingArray objectAtIndex:indexPath.row] valueForKey:@"labtests"];

    if(labTestArray.count > 0)
    {
        [self performSegueWithIdentifier:kTestReportIdentifier sender:labTestArray];
    }
}

#pragma mark - Button Actions -


- (IBAction)approvedReimButtonAction:(id)sender {
    bottomBarLeadingCons.constant = 0;
    _scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)pendingReimButtonAction:(id)sender {
    bottomBarLeadingCons.constant = self.view.frame.size.width/2;
    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    
}

- (IBAction)addReimbusmentButtonAction:(id)sender {
    [self performSegueWithIdentifier:kAddReimbursementIdentifier sender:nil];
}


#pragma mark - Server API Call -

-(void)callUserReimbursementHistoryAPI
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiritId = [userInfoDic valueForKey:@"emiratesid"];
    
    //NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",userEmiritId];
    
    //User *currentUser = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    //NSLog(@"Token: %@",currentUser.token);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary setValue:[userInfoDic valueForKey:@"memberid"]
                      forKey:@"memberid"];
    }
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"principalmemberid"];
    [dictionary setValue:[NSNumber numberWithInt:10000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"datafilter"];
    [dictionary setValue:@"" forKey:@"datefrom"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
    }else{
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dictionary setValue:toDateString forKey:@"dateto"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetReimbursementHistory"];
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
                     [_reimbursmentApprovedArray removeAllObjects];
                     [_reimbursmentPendingArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"reimbursements"]).count > 0)
                     {
                         [_reimbursmentApprovedArray addObjectsFromArray:[[responseDictionary valueForKey:@"reimbursements"] valueForKey:@"approvedreimbursements"] ];
                         
                         
                         [_reimbursmentPendingArray addObjectsFromArray:[[responseDictionary valueForKey:@"reimbursements"] valueForKey:@"pendingreimbursements"] ];
                     }
                     [_mainTableView reloadData];
                     [_pendingTableView reloadData];
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


#pragma mark- Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if(_scrollView == scrollView)
    {
        static NSInteger previousPage = 0;
        CGFloat pageWidth = scrollView.frame.size.width;
        float fractionalPage = scrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        if (previousPage != page) {
            // Finally, update previous page
            previousPage = page;
            //_scrollView.contentOffset = CGPointMake(page*self.view.frame.size.width,0);
            if(page == 1)
            {
                bottomBarLeadingCons.constant = self.view.frame.size.width/2;
            }
            else if(page == 0)
                bottomBarLeadingCons.constant = 0;
        }
    }
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
