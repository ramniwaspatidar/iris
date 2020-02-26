//
//  MyHistoryViewController.m
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "MyHistoryViewController.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "User+CoreDataProperties.h"
#import "DbManager.h"
#import "RevealViewController.h"
#import "HistoryClaimTableViewCell.h"
#import "TestReportViewController.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"
@interface MyHistoryViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@end

@implementation MyHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd/MMM/yyyy";
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
        
    }else{
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];

        
        
    }
    _historyInfoDictionary = [[NSMutableDictionary alloc] init];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 160;
    //_mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    [self callUserHistoryAPI];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Claim History"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        claimhistoryLbl.text =  [Localization languageSelectedStringForKey:@"Claim History"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        claimhistoryLbl.text =  [Localization languageSelectedStringForKey:@"Claim History"];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *claimCount = [_historyInfoDictionary valueForKey:@"claims"];
    return claimCount.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *cellIdentifier  =@"HistoryClaimCellIdentifier";
        HistoryClaimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HistoryClaimTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
   
        NSDate *date = [self.dateFormatter1 dateFromString:[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"treatmentdate"]];
        
        self.dateFormatter.dateFormat = @"EEEE";
        NSString *stringDay = [self.dateFormatter stringFromDate:date];
        cell.day.text = stringDay;
        
        self.dateFormatter.dateFormat = @"dd MMM";
        NSString *stringMonth = [self.dateFormatter stringFromDate:date];
        cell.month.text = stringMonth;
        
        self.dateFormatter.dateFormat = @"yyyy";
        NSString *stringYear = [self.dateFormatter stringFromDate:date];
        cell.year.text = stringYear;
        
        cell.claimId.text = [NSString stringWithFormat:@"%@: %@", [Localization languageSelectedStringForKey:@"Claim ID"],[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"claimid"]];
        cell.providerName.text = [NSString stringWithFormat:@"%@",[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"providername"]];
        cell.claimType.text = [NSString stringWithFormat:@"%@",[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"claimtype"]];
        cell.treatmentDetail.text = [NSString stringWithFormat:@"%@",[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"treatmentdetails"]];
        cell.approvedAmount.text = [NSString stringWithFormat:@"%@",[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"approvedamount"]];
        cell.diagnosisDetail.text = [NSString stringWithFormat:@"%@",[[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"icddescription"]];
        
        NSArray *labTestArray = [[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"labtests"];
        if(labTestArray.count > 0)
        {
            cell.labTestHeightCons.constant = 17;
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
    else if(indexPath.section == 1)
    {
        
    }
    return nil;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *labTestArray = [[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"labtests"];
    if(labTestArray.count > 0)
    {
        return 170;
    }
    else
    {
        return 153;
    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSArray *labTestArray = [[[_historyInfoDictionary valueForKey:@"claims"] objectAtIndex:indexPath.row] valueForKey:@"labtests"];
    if(labTestArray.count > 0)
    {
        [self performSegueWithIdentifier:kTestReportIdentifier sender:labTestArray];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kTestReportIdentifier])
    {
        NSArray *testReportArray = (NSArray*)sender;
        TestReportViewController *testReportViewControllerViewController = segue.destinationViewController;
        testReportViewControllerViewController.reportsArray = [testReportArray mutableCopy];
    }
    
}

#pragma mark - Server API Call -

-(void)callUserHistoryAPI
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiritId = [userInfoDic valueForKey:@"emiratesid"];

    //NSPredicate *predicate =
    //[NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",userEmiritId];
    
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
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
    }else{
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dictionary setValue:toDateString forKey:@"dateto"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetClaimHistory"];
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
                     [_historyInfoDictionary removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"claims"]).count > 0)
                     {
                         [_historyInfoDictionary setValue:[responseDictionary valueForKey:@"claims"] forKey:@"claims"];
                     }
                     [_mainTableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
