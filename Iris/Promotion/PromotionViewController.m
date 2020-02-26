//
//  PromotionViewController.m
//  Iris
//
//  Created by apptology on 04/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "PromotionViewController.h"
#import "PromotionTableViewCell.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "PromotionDetailViewController.h"
#import "NSData+Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainSideMenuViewController.h"
 #import "Localization.h"
@interface PromotionViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    selectedFilter = [Localization languageSelectedStringForKey:@"all"];
    allOptionButton.selected = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    
    self.dateFormatter1 = [[NSDateFormatter alloc] init];
    self.dateFormatter1.dateFormat = @"dd/MM/yyyy";

    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
    }else{
        
        [self.dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
        
        
    }
    _promotionListArray = [[NSMutableArray alloc] init];
    [self initialSetupView];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 100;
    [self callGetPromotionsList];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Promotions"];
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
        
        allLbl.text =  [Localization languageSelectedStringForKey:@"All"];
        
           lastsixLbl.text =  [Localization languageSelectedStringForKey:@"Last Six Month"];
          lastOneLbl.text =  [Localization languageSelectedStringForKey:@"Last One Month"];
        lastThreeLbl.text =  [Localization languageSelectedStringForKey:@"Last Three Month"];
         promotionLbl.text =  [Localization languageSelectedStringForKey:@"Promotions"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        allLbl.text =  [Localization languageSelectedStringForKey:@"All"];
        
        lastsixLbl.text =  [Localization languageSelectedStringForKey:@"Last Six Month"];
        lastOneLbl.text =  [Localization languageSelectedStringForKey:@"Last One Month"];
        lastThreeLbl.text =  [Localization languageSelectedStringForKey:@"Last Three Month"];
        promotionLbl.text =  [Localization languageSelectedStringForKey:@"Promotions"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
}

#pragma mark Table View methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_promotionListArray count];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"PromotionCellIdentifier";
    PromotionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PromotionTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.promotionName.text = [[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promoname"];

    cell.partnerName.text = [[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promopartner"];

    if([[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promopic"])
    {
        [cell.promotionImageView sd_setImageWithURL:[NSURL URLWithString:[[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promopic"]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    }
    
    /*NSData *imageData = [NSData dataFromBase64String:[[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promopic"]];
    UIImage *promoImage = [UIImage imageWithData:imageData];
    
    if(promoImage)
        cell.promotionImageView.image = promoImage;
     */
    
    NSDate *promoDate = [self.dateFormatter dateFromString:[[_promotionListArray objectAtIndex:indexPath.row]valueForKey:@"promoenddate"]];
    
    NSDateFormatter *dateFormattertest = [[NSDateFormatter alloc] init];
    dateFormattertest.dateFormat = @"EEEE";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
        
    }else{
        
        [dateFormattertest  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
        
        
        
    }
    NSString *stringDay = [dateFormattertest stringFromDate:promoDate];
    cell.dayLabel.text = stringDay;
    
    dateFormattertest.dateFormat = @"dd MMM";
    NSString *stringMonth = [dateFormattertest stringFromDate:promoDate];
    cell.monthLabel.text = stringMonth;
    
    dateFormattertest.dateFormat = @"yyyy";
    NSString *stringYear = [dateFormattertest stringFromDate:promoDate];
    cell.yearLabel.text = stringYear;
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
        
    return cell;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kPromotionDetailIdentifier sender:[_promotionListArray objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kPromotionDetailIdentifier])
    {
         PromotionDetailViewController *promotionViewController = segue.destinationViewController;
        promotionViewController.promotionDetail = sender;
    }
    
}


-(IBAction)showFilterOptionList:(id)sender
{
    _filterListContainerView.hidden = NO;
    allOptionButton.selected = NO;
    oneMonthOptionButton.selected = NO;
    threeMonthOptionButton.selected = NO;
    sixMonthOptionButton.selected = NO;
    
    if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"all"]])
    {
        allOptionButton.selected = YES;
    }
    else if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"1 month"]])
    {
        oneMonthOptionButton.selected = YES;
    }
    else if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"3 month"]])
    {
        threeMonthOptionButton.selected = YES;
    }
    else if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"6 month"]])
    {
        sixMonthOptionButton.selected = YES;
    }
}

-(IBAction)filterDataButtonAction:(id)sender
{
    
    UIButton *selectedButton = sender;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if(selectedButton.tag == 1)
    {
        selectedFilter = [Localization languageSelectedStringForKey:@"all"];
        allOptionButton.selected = YES;
        fromDate = nil;
        _filterListContainerView.hidden = YES;
        [self callGetPromotionsList];
        return;
        
    }
    else if(selectedButton.tag == 2)
    {
        selectedFilter = [Localization languageSelectedStringForKey:@"1 month"];
        oneMonthOptionButton.selected = YES;
        [dateComponents setMonth:-1];
        
        
    }
    else if(selectedButton.tag == 3)
    {
        selectedFilter = @"3 month";
        threeMonthOptionButton.selected = YES;
        [dateComponents setMonth:-3];
        
        
    }
    else if(selectedButton.tag == 4)
    {
        selectedFilter = [Localization languageSelectedStringForKey:@"6 month"];
        sixMonthOptionButton.selected = YES;
        [dateComponents setMonth:-6];
        
        
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    //self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    fromDate = [self.dateFormatter1 stringFromDate:newDate];
    
    _filterListContainerView.hidden = YES;
    [self callGetPromotionsList];
    
    
}

#pragma mark - Server API Call -

-(void)callGetPromotionsList
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];

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
    [dictionary setValue:@"" forKey:@"dateto"];
    [dictionary setValue:@"" forKey:@"emirate"];
    [dictionary setValue:@"" forKey:@"maincategory"];
    [dictionary setValue:@"" forKey:@"partner"];
    [dictionary setValue:@"" forKey:@"subcategory"];


    if(fromDate)
    {
        [dictionary setValue:fromDate forKey:@"datefrom"];
        [dictionary setValue:[NSNumber numberWithInt:1] forKey:@"datafilter"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
            
            
        }else{
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
            
            
            
            
            
        }
        NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [dictionary setValue:toDateString forKey:@"dateto"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetPromotionsList"];
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
                     [_promotionListArray removeAllObjects];
                     
                     if(((NSArray*)[responseDictionary valueForKey:@"promotions"]).count > 0)
                     {
                         [_promotionListArray addObjectsFromArray:[responseDictionary valueForKey:@"promotions"]];
                         [_mainTableView reloadData];
                     }
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
