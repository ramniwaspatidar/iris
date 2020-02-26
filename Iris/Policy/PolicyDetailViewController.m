//
//  PolicyDetailViewController.m
//  Iris
//
//  Created by apptology on 19/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "PolicyDetailViewController.h"
#import "PolicyListDetailTableViewCell.h"
#import "UILabel+CustomLabel.h"
#import "DbManager.h"
#import "Utility.h"
#import "DependentViewController.h"
#import "Constant.h"
#import "ConnectionManager.h"
 #import "Localization.h"
#import "BenefitGroup+CoreDataProperties.h"
#import "Benefit+CoreDataProperties.h"
#import "Dependent+CoreDataProperties.h"
#import "AppDelegate.h"
#import "MainSideMenuViewController.h"
@interface PolicyDetailViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) NSSet *benefits;

@property (strong) UIView *expandedSectionHeader;
@property (assign) NSInteger expandedSectionHeaderNumber;

@property (strong) UITableView *childBenefitsTableView;

@end

@implementation PolicyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    _mainTableView.backgroundColor = [UIColor clearColor];
    [_mainTableView setSeparatorStyle:(UITableViewCellSeparatorStyleSingleLine)];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 500;
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        defaultLbl.text =  [Localization languageSelectedStringForKey:@"Default Policy"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        defaultLbl.text =  [Localization languageSelectedStringForKey:@"Default Policy"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    self.expandedSectionHeaderNumber = -1;
    
    _benefits = self.userPolicyDetails.policydetail.benefitgroup;
    
    _policyNumberLabel.text = self.userPolicyDetails.policydetail.policyno;
    
    if([self.userPolicyDetails.defaultpolicyholder isEqualToString:@"True"])
    {
        defaultPolicyButton.selected = YES;
        defaultPolicyButton.userInteractionEnabled = NO;
    }
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    //if(self.policyDetails)
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[Localization languageSelectedStringForKey:@"Policy Detail"]
    [Utility trackGoogleAnalystic: [Localization languageSelectedStringForKey:@"Policy Detail"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
// benefit group
-(BenefitGroup *)getBenefitGroupsAtIndex:(NSInteger)index {
    
    NSArray *benefitArray = [self.benefits allObjects];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"groupid" ascending:YES];
    NSArray *sortedBenefits = [benefitArray sortedArrayUsingDescriptors:@[descriptor]];
    return (BenefitGroup *)[sortedBenefits objectAtIndex:index];
}

-(NSInteger)getBenefitCountForGroupIndex:(NSInteger)groupIndex {
    BenefitGroup * benefitGroup = (BenefitGroup *)[[self.benefits allObjects] objectAtIndex:groupIndex];
    return benefitGroup.benefits.count;
}

// Parent benefits
-(NSArray *)getBenefitsForBenefitGroupIndex:(NSInteger)groupIndex andParentId:(NSString *)parentId {
    BenefitGroup *benefitGroup = [self getBenefitGroupsAtIndex:groupIndex];
    NSArray *benefits = [benefitGroup.benefits allObjects];
    NSPredicate *parentBenefitPredicate = [NSPredicate predicateWithFormat:@"parentid ==[c]%@",parentId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"benefitid" ascending:YES];
    return [[benefits filteredArrayUsingPredicate:parentBenefitPredicate] sortedArrayUsingDescriptors:@[descriptor]];
}

-(NSInteger)getParentBenefitCountForBenefitGroupIndex:(NSInteger)groupIndex {
    NSArray *parentBenefits = [self getBenefitsForBenefitGroupIndex:groupIndex andParentId:@"0"];
    return parentBenefits.count;
}

-(Benefit *)getParentBenefitAtIndex:(NSInteger)index forBenefitGroupIndex:(NSInteger)groupIndex {
    NSArray *parentBenefits = [self getBenefitsForBenefitGroupIndex:groupIndex andParentId:@"0"];
    return (Benefit *)[parentBenefits objectAtIndex:index];
}

// Child benefits
-(NSInteger)getChildBenefitCountForParentId:(NSString *)parentId andBenefitGroupIndex:(NSInteger)groupIndex {
    NSArray *childBenefits = [self getBenefitsForBenefitGroupIndex:groupIndex andParentId:parentId];
    return childBenefits.count;
}

-(Benefit *)getChildBenefitAtIndex:(NSInteger)index withParentId:(NSString *)parentId andBenefitGroupIndex:(NSInteger)groupIndex {
    NSArray *childBenefits = [self getBenefitsForBenefitGroupIndex:groupIndex andParentId:parentId];
    return (Benefit *)[childBenefits objectAtIndex:index];
}


#pragma mark - Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+self.benefits.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section > 0) {
        if(section == self.expandedSectionHeaderNumber) {
            NSInteger parentBenefitCount = [self getParentBenefitCountForBenefitGroupIndex:section-1];
            return parentBenefitCount;
        } else {
            return 0;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section > 0)?44.0:0.01;
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section > 0) {
        UIView *headerView = [_mainTableView viewWithTag:section];
        if(!headerView) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44.0)];
        headerView.backgroundColor = [UIColor colorWithRed:0.086 green:0.462 blue:0.868 alpha:1.0];
        headerView.tag = section;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, headerView.bounds.size.width-44, 44)];
        BenefitGroup *benefitGroup = [self getBenefitGroupsAtIndex:(section-1)];
        titleLabel.text = benefitGroup.grouptitle;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
            
        [headerView addSubview:titleLabel];
        
        CGRect sepFrame = CGRectMake(0, headerView.frame.size.height-1, headerView.frame.size.width, 1);
        UIView *seperatorView =[[UIView alloc] initWithFrame:sepFrame];
        seperatorView.backgroundColor = [UIColor colorWithWhite:224.0/255.0 alpha:1.0];
        [headerView addSubview:seperatorView];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width-30, ((headerView.frame.size.height-20)/2), 20, 20)];
        accessoryImageView.image = [UIImage imageNamed:@"white_downarrow"];
        accessoryImageView.tag = 101;
        [headerView addSubview:accessoryImageView];
//        accessoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [headerView addGestureRecognizer:recognizer];
        }
        return headerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section > 0) {
        UITableViewCell *cell = [self getParentPolicyCellForTableview:tableView atIndexPath:indexPath];
        cell.clipsToBounds = YES;
        
        BenefitGroup *benefitGroup = [self getBenefitGroupsAtIndex:indexPath.section-1];
        if(benefitGroup.benefits.count) {
            Benefit *parentBenefit = [self getParentBenefitAtIndex:indexPath.row forBenefitGroupIndex:(indexPath.section-1)];
            // display benefit description
            
            UIFont *defaultFont = [UIFont systemFontOfSize:14];

            NSString *content = @"";//[NSString stringWithFormat:@"<h1><b>Primary Holder</b></h1>"];

            content = [content stringByAppendingFormat:@"<html><head>\
                       <style type='text/css'>\
                       h1 { margin: -15px 10px 10px 10px; font-family:'%@' font-size: %fpx;}\
                       body { margin:0px; padding:0px; font-family:'%@' font-size: %fpx; }\
                       table {border-collapse: collapse; width:100%%; margin:0px; padding:0px; }\
                       table.child, th.child, td.child { border: 1px solid LightGray; }\
                       th { background-color: #E3E3E3; font-weight:bold; }\
                       th.child, td.child { text-align:center; }\
                       td.parent { font-weight:bold; }\
                       </style>\
                       </head>\
                       <body><table class='parent'>", defaultFont.fontName, defaultFont.pointSize,defaultFont.fontName, defaultFont.pointSize];
            
            if([parentBenefit.value isEqualToString:@"0"])
            {
                content = [content stringByAppendingFormat:@"<tr>\
                           <td class='parent'>%@</td></tr>",parentBenefit.benefitdescription];
            }
            else
            {
                if(indexPath.section == 5)
                {
                    content = [content stringByAppendingFormat:@"<tr>\
                               <td class='parent'>%@</td><td style = 'width:25%% ; text-align:right' class='parent'>%@</td></tr>",parentBenefit.benefitdescription, parentBenefit.value];
                }
                else
                {
                    content = [content stringByAppendingFormat:@"<tr>\
                               <td class='parent'>%@</td><td style = 'width:18%% ; text-align:right' class='parent'>%@</td></tr>",parentBenefit.benefitdescription, parentBenefit.value];
                }
                
            }
            
            //content = [content stringByAppendingString:@"</table>"];
            
            //[NSString stringWithFormat:@"<div>%@</div>", parentBenefit.benefitdescription]
            //cell.textLabel.text = parentBenefit.benefitdescription;
            
            // get child benefits
            NSInteger childBenefitCount = [self getChildBenefitCountForParentId:parentBenefit.benefitid andBenefitGroupIndex:indexPath.section-1];
            if(childBenefitCount > 0) {
                content = [content stringByAppendingString:@"<tr><td colspan='2'>"];

                //content = [content stringByAppendingString:@"<h1><b>Dependent</h1></b>"];
                content = [content stringByAppendingString:@"<table class='child' style='margin: 4px 0px 0px 15px;' > <tr>\
                           <th class='child' style='width:10%%'>SN</th>\
                           <th class='child' style='width:75%'>Description</th>\
                           <th class='child' style='width:15%%'>Value</th>\
                           </tr>"];

                // loop through child benefits
                NSArray *childBenefits = [self getBenefitsForBenefitGroupIndex:indexPath.section-1 andParentId:parentBenefit.benefitid];
                for (int i=0; i<childBenefits.count; i++) {
                    
                    Benefit *childBenefit = [childBenefits objectAtIndex:i];
                    content = [content stringByAppendingFormat:@"<tr>\
                               <td class='child'>%d</td><td class='child'>%@</td><td class='child'>%@</td></tr>",(i+1), childBenefit.benefitdescription, childBenefit.value];
                }
                // close table
                content = [content stringByAppendingString:@"</table></td></tr>"];
                
            }
            // close table
            content = [content stringByAppendingString:@"</table></body></html>"];

            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            UIFont *regularFont = [UIFont systemFontOfSize:14];
            [attrStr beginEditing];
            [attrStr enumerateAttribute:NSFontAttributeName
                            inRange:NSMakeRange(0, attrStr.length)
                            options:0
                         usingBlock:^(id value, NSRange range, BOOL *stop) {
                             if (value) {
                                 UIFont *oldFont = (UIFont *)value;
                                 UIFont *newFont;
                                 if([oldFont.fontName rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location == NSNotFound)
                                 {
                                     newFont = [UIFont systemFontOfSize:12];
                                 } else {
                                     newFont = [UIFont boldSystemFontOfSize:12];
                                 }
                                 [attrStr addAttribute:NSFontAttributeName value:newFont range:range];
                             }
                         }];
            [attrStr endEditing];
//            [attrStr setAttributes:@{ NSFontAttributeName: regularFont } range:NSMakeRange(0, attrStr.length)];
            // find textview from cell.
            UITextView *textView = (UITextView *)[cell viewWithTag:9999];
            //textView.font = regularFont;
            // add attributed text to textview.
            textView.attributedText = attrStr;
            
        }
        NSLog(@">>> index: %ld-%d, class %@",(long)indexPath.section, indexPath.row, [cell class]);
        for (UIView *v in cell.subviews) {
            if(v.tag && v.tag == indexPath.section)
                [v removeFromSuperview];
        }
        cell.contentView.clipsToBounds = YES;
        cell.clipsToBounds = YES;
        return cell;
    } else {
        return [self getPolicyHeaderCellForTable:tableView atIndexPath:indexPath];
    }
    return nil;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 1)
//        return;
//}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 144;
 }*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - table view helper methods
-(UITableViewCell *)getPolicyHeaderCellForTable:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier  =@"PolicyListDetailCellIdentifier";
    PolicyListDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PolicyListDetailTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.tag = indexPath.row;
    //tapHereButton
    
    if(cell.tapHereButton)
    {//[Localization languageSelectedStringForKey:@"Not Available"]
        if(self.userPolicyDetails.depend.count) {
            [cell.tapHereButton setTitle: [Localization languageSelectedStringForKey:@"SHOW"] forState:(UIControlStateNormal)];
            [cell.tapHereButton addTarget:self
                                   action:@selector(showDependentAction:)
                         forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.tapHereButton setTitle:[Localization languageSelectedStringForKey:@"No Dependents"] forState:(UIControlStateNormal)];
        }
    }
    PolicyDetails *policyDetail = self.userPolicyDetails.policydetail;
    cell.policyNumber.text = policyDetail.policyno;
    
    if(policyDetail.startdate)
        cell.startDate.text = policyDetail.startdate;
    else
    {
        cell.startDate.text = [Localization languageSelectedStringForKey:@"Not Available"];
    }
    
    if(policyDetail.enddate)
        cell.endDate.text = policyDetail.enddate;
    else
    {
        cell.endDate.text =  [Localization languageSelectedStringForKey:@"Not Available"];
    }
    cell.insuranceCompanyName.text = policyDetail.insurancecompanyname;
    cell.masterContact.text = policyDetail.mastercontractname;
    cell.companyName.text = policyDetail.companyname;
    
    cell.planName.text = policyDetail.productname;
    cell.status.text = policyDetail.policystatus;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.contentView.clipsToBounds = YES;
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    cell.clipsToBounds = YES;
    return cell;
}

-(UITableViewCell *)getParentPolicyCellForTableview:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BenefitsTableCellIdentifier";
    
    UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.contentView.clipsToBounds = YES;
    cell.clipsToBounds = YES;
    return cell;
}

#pragma mark - table view expand/collapse methods

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)recognizer
{
    UIView *headerView = (UIView *)recognizer.view;
    NSInteger section = headerView.tag;
    self.expandedSectionHeader = headerView;
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section];
    } else {
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section];
            self.expandedSectionHeader = nil;
        } else {
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber];
            [self tableViewExpandSection:section];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section {
    NSInteger parentBenefitCount = [self getParentBenefitCountForBenefitGroupIndex:section-1];
//    NSInteger parentBenefitCount = [self getBenefitCountForGroupIndex:section-1];

    self.expandedSectionHeaderNumber = -1;
    if (parentBenefitCount == 0) {
        return;
    } else {
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< parentBenefitCount; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [_mainTableView beginUpdates];
        [_mainTableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationNone];
        [_mainTableView endUpdates];
        
//        UIImageView *accessoryImageView = (UIImageView *)[self.expandedSectionHeader viewWithTag:101];
//        accessoryImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)tableViewExpandSection:(NSInteger)section {
    NSInteger parentBenefitCount = [self getParentBenefitCountForBenefitGroupIndex:section-1];
//    NSInteger parentBenefitCount = [self getBenefitCountForGroupIndex:section-1];

    if (parentBenefitCount == 0) {
        self.expandedSectionHeaderNumber = -1;
        return;
    } else {
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< parentBenefitCount; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        self.expandedSectionHeaderNumber = section;
        [_mainTableView beginUpdates];
        [_mainTableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationNone];
        [_mainTableView endUpdates];
        
//        UIImageView *accessoryImageView = (UIImageView *)[self.expandedSectionHeader viewWithTag:101];
//        accessoryImageView.transform = CGAffineTransformMakeRotation(M_PI - 3.14159);
    }
}

#pragma mark - UITextView delegate
- (void)textViewDidChange:(UITextView *)textView {
    [_mainTableView beginUpdates];
    [_mainTableView endUpdates];
}

#pragma mark - Button Action -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showDependentAction:(id)sender
{
    [self performSegueWithIdentifier:kDependentViewIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kDependentViewIdentifier])
    {
        NSSet *dependentSet = self.userPolicyDetails.depend;
        NSArray *dependentArray = [dependentSet allObjects];
        
        DependentViewController *dependentsViewController = segue.destinationViewController;
        dependentsViewController.dependentsArray = [dependentArray mutableCopy];
    }
    
}

- (IBAction)setDefaultPolicyButtonAction:(id)sender {
    if(!defaultPolicyButton.selected)
    {
        defaultPolicyButton.selected = YES;
        
        NSArray *usersArray = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:nil sortKey:nil ascending:NO] mutableCopy];
        
        for(int i = 0; i < usersArray.count; i++)
        {
            User *user = [usersArray objectAtIndex:i];
            if([self.userPolicyDetails.policydetail.policyno isEqualToString:user.policydetail.policyno])
            {
                user.defaultpolicyholder = [Localization languageSelectedStringForKey:@"True"];
                [self updateLocalUserDefault:user];
            }
            else
            {
                user.defaultpolicyholder =  [Localization languageSelectedStringForKey:@"False"];
            }
            [[DbManager getSharedInstance] saveContext];
        }
        
//        NSArray *usersArray1 = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:nil sortKey:nil ascending:NO] mutableCopy];
//        NSLog(@"");
        
    }
}


-(void)updateLocalUserDefault:(User *)user
{
    NSMutableDictionary *loginDictionary = [[NSMutableDictionary alloc] init];
    if(user.name)
        [loginDictionary setValue:user.name forKey:@"name"];
    else
        [loginDictionary setValue:user.mobileno forKey:@"name"];

    [loginDictionary setValue:user.email forKey:@"email"];
    [loginDictionary setValue:user.emiratesid forKey:@"emiratesid"];
    [loginDictionary setValue:user.memberid forKey:@"memberid"];
    [loginDictionary setValue:@"True" forKey:@"defaultpolicyholder"];
    [loginDictionary setValue:user.fullname forKey:@"fullname"];
    [loginDictionary setValue:user.profileimage forKey:@"profileimage"];
    [loginDictionary setValue:user.token forKey:@"token"];
    [loginDictionary setValue:user.insurancecompany forKey:@"insurancecompany"];
    [loginDictionary setValue:user.mobileno forKey:@"mobileno"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:loginDictionary] forKey:@"login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self callUpdateProfileAPI];
}

#pragma mark- Calling APIs-

-(void)callUpdateProfileAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:@"updatepolicyholder" forKey:@"mode"];
    [dictionary setValue:@"" forKey:@"email"];
    [dictionary setValue:@"" forKey:@"fullname"];
    [dictionary setValue:@"" forKey:@"gender"];
    [dictionary setValue:@"" forKey:@"nationality"];
    [dictionary setValue:@"" forKey:@"residence"];
    [dictionary setValue:[userInfoDic valueForKey:@"mobileno"] forKey:@"mobileno"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[userInfoDic valueForKey:@"name"] forKey:@"username"];
    [dictionary setValue:@"" forKey:@"password"];
    [dictionary setValue:@"" forKey:@"profileimage"];
    
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
                     //[Localization languageSelectedStringForKey:@"default policy updated."];
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"default policy updated."] block:^(int index) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"update_profile_notification"                                                                object:nil userInfo:nil];
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
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary1 setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"]
                      forKey:@"memberid"];
    }
    
    [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"principalmemberid"];
    
    NSString *token = [userInfoDic valueForKey:@"token"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ShowProfile"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary1 options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                    NSString *policyNumber = self.userPolicyDetails.policydetail.policyno;
                     [[DbManager getSharedInstance] clearTable:@"User"];

                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Dependent" withPredicate:nil];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"PolicyDetails" withPredicate:nil];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"BenefitGroup" withPredicate:nil];
                     
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Benefit" withPredicate:nil];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults removeObjectForKey:@"login"];
                     [defaults synchronize];
                     
                     NSMutableDictionary *updatedDictionary = [[NSMutableDictionary alloc] init];
                     
                     NSString *defaultPolicy = @"True";
                     NSPredicate *predicate =
                     [NSPredicate predicateWithFormat:@"SELF.defaultpolicyholder == %@",defaultPolicy];
                     NSArray *allPolicyHolderArray = [dictionary valueForKey:@"policyholder"];
                     NSArray *defaultArray = [allPolicyHolderArray filteredArrayUsingPredicate:predicate];
                     
                     if(defaultArray.count > 0)
                         [updatedDictionary addEntriesFromDictionary:[defaultArray firstObject]];
                     else
                         [updatedDictionary addEntriesFromDictionary:[allPolicyHolderArray firstObject]];
                     
                     [updatedDictionary setValue:token forKey:@"token"];
                     
                     [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:updatedDictionary] forKey:@"login"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                     NSArray *policyHolderArray = [dictionary valueForKey:@"policyholder"];
                     
                     
                     for(int i = 0; i< policyHolderArray.count; i++)
                     {
                         User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                                    inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                         
                         user.email = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"email"];
                         user.fullname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"fullname"];
                         user.gender = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"gender"];
                         user.memberid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"memberid"];
                         user.residence = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"residence"];
                         user.nationality = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"nationality"];
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"])
                             user.mobileno = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"mobileno"];
                         user.company = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                         user.insurancecompany = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                         if([[[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"] isKindOfClass:[NSString class]])
                         {
                             user.defaultpolicyholder = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"defaultpolicyholder"];
                         }
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                             user.emiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                         
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] && ![[[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                             user.profileimage = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"profileimage"];
                         
                         user.token = token;
                         
                         if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"])
                         {
                             PolicyDetails *policyDetail = [NSEntityDescription insertNewObjectForEntityForName:@"PolicyDetails"
                                                                                         inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                             
                             NSDictionary *policyDetailDic = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"policydetails"];
                             if([policyDetailDic valueForKey:@"emiratesid"])
                                 policyDetail.emiratesid = [policyDetailDic valueForKey:@"emiratesid"];
                             policyDetail.memberid = [policyDetailDic valueForKey:@"memberid"];
                             policyDetail.policyno = [policyDetailDic valueForKey:@"policynumber"];
                             policyDetail.policyperiod = [policyDetailDic valueForKey:@"policyperiod"];
                             policyDetail.policystatus = [policyDetailDic valueForKey:@"status"];
                             policyDetail.premiumamount = [policyDetailDic valueForKey:@"premiumamount"];
                             policyDetail.mastercontractname = [policyDetailDic valueForKey:@"mastercontractname"];
                             policyDetail.productname = [policyDetailDic valueForKey:@"productname"];
                             policyDetail.insurancecompanyname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"insurancecompany"];
                             policyDetail.companyname = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"company"];
                             
                             if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                 policyDetail.parentemiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                             
                             
                             if([policyDetailDic valueForKey:@"policystartdate"])
                                 policyDetail.startdate = [policyDetailDic valueForKey:@"policystartdate"];
                             
                             if([policyDetailDic valueForKey:@"policyenddate"])
                                 policyDetail.enddate = [policyDetailDic valueForKey:@"policyenddate"];
                             
                             //[[DbManager getSharedInstance] saveContext];
                             
                             // process and generate plan benefits data
                             policyDetail.benefitgroup = [self processBenefitsData:[policyDetailDic valueForKey:@"planbenefits"]];
                             
                             user.policydetail = policyDetail;
                             
                         if([policyNumber isEqualToString:user.policydetail.policyno])
                            {
                                self.userPolicyDetails = user;
                                
                                _benefits = self.userPolicyDetails.policydetail.benefitgroup;
                                [_mainTableView reloadData];
                            }
                             
                         }
                         NSArray *dependentArray = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"dependents"];
                         
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
                                 if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"])
                                     dependent.parentemiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                                 [dependentSet addObject:dependent];
                                 //[[DbManager getSharedInstance] saveContext];
                             }
                             user.depend = dependentSet;
                         }
                         [[DbManager getSharedInstance] saveContext];
                     }
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
                                        parentBenefitObj.sortid = [parentBenefit valueForKey:@"Sortid"];
                                        benefitGroup.groupid = parentBenefitObj.sortid;
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
                                            
                                            childBenefitObj.sortid = [childBenefit valueForKey:@"Sortid"];
                                            [parentBenefitSet addObject:childBenefitObj];
                                        }
                                        
                                    }
                                    benefitGroup.benefits = parentBenefitSet;
                                    [planBenefits addObject:benefitGroup];
                                }
                                
                                return planBenefits;
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

