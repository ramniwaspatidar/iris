//
//  PolicyViewController.m
//  Iris
//
//  Created by apptology on 19/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "PolicyViewController.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "PolicyTableViewCell.h"
#import "Utility.h"
#import "DbManager.h"
#import "PolicyDetails+CoreDataProperties.h"
#import "Constant.h"
#import "PolicyDetailViewController.h"
#import "NotificationViewController.h"
 #import "Localization.h"
#import "MainSideMenuViewController.h"
@interface PolicyViewController ()

@end

@implementation PolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _policyArray = [[NSMutableArray alloc] init];
    
    [self initialSetupView];
    
    NSDictionary *loginInfoDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[loginInfoDictionary valueForKey:@"emiratesid"]];
    
    //_policyArray = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:nil sortKey:nil ascending:NO] mutableCopy];
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[Localization languageSelectedStringForKey:@"Policy"]
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Policy"]];
    
    if(_policyArray)
        [_policyArray removeAllObjects];
    
    _policyArray = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:nil sortKey:nil ascending:NO] mutableCopy];
    
    if(self.personDetailDictionary)
        [self.personDetailDictionary removeAllObjects];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    [_mainTableView reloadData];
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         policyLbl.text =  [Localization languageSelectedStringForKey:@"Policy"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        policyLbl.text =  [Localization languageSelectedStringForKey:@"Policy"];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    
}

#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _policyArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"PolicyCellIdentifier";
    PolicyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PolicyDetails *policyDetail = [[_policyArray objectAtIndex:indexPath.row] valueForKey:@"policydetail"];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PolicyTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.tag = indexPath.row;
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        cell.topImg.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ #%@",[[_policyArray objectAtIndex:indexPath.row] valueForKey:@"insurancecompany"],[policyDetail valueForKey:@"policyno"]];
    
    if([[[_policyArray objectAtIndex:indexPath.row] valueForKey:@"defaultpolicyholder"]boolValue] == true){
        cell.dependentIcon.hidden = false;
    }else{
        cell.dependentIcon.hidden = true;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:kPolicyDetailIdentifier sender:[_policyArray objectAtIndex:indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kPolicyDetailIdentifier])
    {
        PolicyDetailViewController *policyDetailViewController = segue.destinationViewController;
        policyDetailViewController.userPolicyDetails = sender;
    }
    
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
