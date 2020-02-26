//
//  BloodPressureStatesViewController.m
//  Iris
//
//  Created by apptology on 22/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "BloodPressureStatesViewController.h"
#import "BloodPressureStatesCollectionViewCell.h"
#import "Utility.h"
#import "DbManager.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "BloodPressureChartViewController.h"
#import "Reachability.h"
#import "MainSideMenuViewController.h"
#import "BloodPressure+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "Localization.h"
@interface BloodPressureStatesViewController (){
    Reachability * internetReachability;

}
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateFormatter;

@end

@implementation BloodPressureStatesViewController
#define itemSize CGSizeMake(75,40)
#define pulseitemSize CGSizeMake(35,40)
#define dateitemSize CGSizeMake(70,40)
#define deleteitemSize CGSizeMake(20,40)


- (void)viewDidLoad {
    [super viewDidLoad];
    //[Localization languageSelectedStringForKey:@"all"]
    selectedFilter = [Localization languageSelectedStringForKey:@"all"];
    allOptionButton.selected = YES;
    
    internetReachability=[Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        allLbl.text =  [Localization languageSelectedStringForKey:@"All"];
        lastoneLbl.text =  [Localization languageSelectedStringForKey:@"Last One Month"];
        lastThreeLbl.text =  [Localization languageSelectedStringForKey:@"Last Three Month"];
        lastSixLbl.text =  [Localization languageSelectedStringForKey:@"Last Six Month"];
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Stats"];
       
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        allLbl.text =  [Localization languageSelectedStringForKey:@"All"];
        lastoneLbl.text =  [Localization languageSelectedStringForKey:@"Last One Month"];
        lastThreeLbl.text =  [Localization languageSelectedStringForKey:@"Last Three Month"];
        lastSixLbl.text =  [Localization languageSelectedStringForKey:@"Last Six Month"];
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Stats"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    self.saveDateFormatter = [[NSDateFormatter alloc] init];

    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
    }
    // Do any additional setup after loading the view.
    [_collectionView registerNib:[UINib nibWithNibName:@"BloodPressureStatesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BloodPressureStatesCollectionCellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    //[Localization languageSelectedStringForKey:@"DIA(mmHG)"]
    _titleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Date"],[Localization languageSelectedStringForKey:@"SYS(mmHG)"],[Localization languageSelectedStringForKey:@"DIA(mmHG)"],[Localization languageSelectedStringForKey:@"Pulse"],@"X", nil];
    
    _bloodPressureStatsArray = [[NSMutableArray alloc] init];
    
    [self loadData];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}



-(void)loadData{
    
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            _bloodPressureStatsArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"BloodPressure" withPredicate:nil sortKey:nil ascending:NO].mutableCopy;
            break;
        }
        case ReachableViaWiFi:
        {
            [self callBloodPressureStatListAPI];
            break;
        }
        case ReachableViaWWAN:
        {
            [self callBloodPressureStatListAPI];
            break;
        }
    }
}

#pragma mark - private & utility methods
-(void)addBorderToCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // create layers for all four sides
    UIView *topLine = (UIView *)[cell viewWithTag:101];
    if(!topLine) {
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
        topLine.tag = 101;
        topLine.backgroundColor = [UIColor grayColor];
    } else {
        [topLine removeFromSuperview];
        topLine.frame = CGRectMake(0, 0, cell.frame.size.width, 1);
    }
    
    UIView *leftLine = (UIView *)[cell viewWithTag:102];
    if(!leftLine) {
        leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cell.frame.size.height)];
        leftLine.tag = 102;
        leftLine.backgroundColor = [UIColor grayColor];
    } else {
        [leftLine removeFromSuperview];
        leftLine.frame = CGRectMake(0, 0, 1, cell.frame.size.height);
    }
    
    UIView *bottomLine = (UIView *)[cell viewWithTag:103];
    if(!bottomLine) {
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1)];
        bottomLine.tag = 103;
        bottomLine.backgroundColor = [UIColor grayColor];
    } else {
        [bottomLine removeFromSuperview];
        bottomLine.frame = CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1);
    }
    
    UIView *rightLine = (UIView *)[cell viewWithTag:104];
    if(!rightLine) {
        rightLine = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-1, 0, 1, cell.frame.size.height)];
        rightLine.tag = 104;
        rightLine.backgroundColor = [UIColor grayColor];
    } else {
        [rightLine removeFromSuperview];
        rightLine.frame = CGRectMake(cell.frame.size.width-1, 0, 1, cell.frame.size.height);
    }
    
    // add border layers to the cell
    if(indexPath.section == 0) {
        // add only 3 sides (top, right and bottom) to most of cells
        [cell addSubview:topLine];
        [cell addSubview:rightLine];
        [cell addSubview:bottomLine];
        // add left border only to first cell
        if(indexPath.row == 0) {
            [cell addSubview:leftLine];
        }
    } else {
        // add only 2 sides (right and bottom) to most of the cells
        [cell addSubview:rightLine];
        [cell addSubview:bottomLine];
        // add left border only to first cell
        if(indexPath.row == 0) {
            [cell addSubview:leftLine];
        }
    }
}


#pragma mark- CollectionView datasouce methods -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1 + _bloodPressureStatsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BloodPressureStatesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BloodPressureStatesCollectionCellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.deleteButton.hidden = YES;
    
    // add border to the cell
    [self addBorderToCell:cell atIndexPath:indexPath];

    if(indexPath.section == 0)
    {
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    else
    {
        cell.titleLabel.font = [UIFont systemFontOfSize:11];
        if(indexPath.row == 0)
        {
            NSDate *date = [self.previousDateFormatter dateFromString:[_bloodPressureStatsArray[indexPath.section - 1] valueForKey:@"date"]];
            
            NSString *dateString = [_bloodPressureStatsArray[indexPath.section - 1] valueForKey:@"date"]; //[self.dateFormatter stringFromDate:date];
            
            cell.titleLabel.text = dateString;
        }
        
        else if(indexPath.row == 1)
            cell.titleLabel.text = [_bloodPressureStatsArray[indexPath.section - 1] valueForKey:@"systolic"];
        else if(indexPath.row == 2)
            cell.titleLabel.text = [_bloodPressureStatsArray[indexPath.section - 1] valueForKey:@"diastolic"];
        else if(indexPath.row == 3)
            cell.titleLabel.text = [_bloodPressureStatsArray[indexPath.section - 1] valueForKey:@"pulse"];
        else if(indexPath.row == 4)
        {
            cell.backgroundColor = [UIColor clearColor];
            if(cell.deleteButton)
            {
                cell.deleteButton.tag = indexPath.section - 1;
                [cell.deleteButton addTarget:self
                                      action:@selector(deleteAction:)
                            forControlEvents:UIControlEventTouchUpInside];
                cell.titleLabel.text = @"";
                cell.deleteButton.hidden = NO;
            }
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return dateitemSize;
    else if(indexPath.row == 3)
        return pulseitemSize;
    else if(indexPath.row == 4)
        return deleteitemSize;
    return  itemSize;
}

// Layout: Set spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    //return UIEdgeInsetsMake(0,(self.view.frame.size.width - (DateItemSize.width+HeighttemSize.width+WeightitemSize.width+BMIItemSize.width+CategoryItemSize.width))/6,0,0);  // top, left, bottom, right
    
    return UIEdgeInsetsMake(0,(self.view.frame.size.width - ((itemSize.width * 2) + pulseitemSize.width + dateitemSize.width + deleteitemSize.width))/2,0,0);  // top, left, bottom, right
}


#pragma mark- Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewChartButtonAction:(id)sender {
    
    if(_bloodPressureStatsArray.count > 0)
        [self performSegueWithIdentifier:kBloodPressureChartIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kBloodPressureChartIdentifier])
    {
        BloodPressureChartViewController *bloodPressureChartViewController = segue.destinationViewController;
        bloodPressureChartViewController.bloodptrssureArray = [_bloodPressureStatsArray copy];
    }
    
}

-(IBAction)showFilterOptionList:(id)sender
{
    _filterListContainerView.hidden = NO;
    allOptionButton.selected = NO;
    oneMonthOptionButton.selected = NO;
    threeMonthOptionButton.selected = NO;
    sixMonthOptionButton.selected = NO;
    //[Localization languageSelectedStringForKey:@"all"]
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
        if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"all"]])
            return;
        selectedFilter = [Localization languageSelectedStringForKey:@"all"];
        allOptionButton.selected = YES;
        fromDate = nil;
        _filterListContainerView.hidden = YES;
        [self callBloodPressureStatListAPI];
        return;
        
    }
    else if(selectedButton.tag == 2)
    {
        if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"1 month"]])
            return;
        selectedFilter = [Localization languageSelectedStringForKey:@"1 month"];
        oneMonthOptionButton.selected = YES;
        [dateComponents setMonth:-1];
        
        
    }
    else if(selectedButton.tag == 3)
    {
        if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"3 month"]])
            return;
        
        selectedFilter = [Localization languageSelectedStringForKey:@"3 month"];
        threeMonthOptionButton.selected = YES;
        [dateComponents setMonth:-3];
        
        
    }
    else if(selectedButton.tag == 4)
    {
        if([selectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"6 month"]])
            return;
        selectedFilter = [Localization languageSelectedStringForKey:@"6 month"];
        sixMonthOptionButton.selected = YES;
        [dateComponents setMonth:-6];
        
        
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    fromDate = [self.dateFormatter stringFromDate:newDate];
    
    _filterListContainerView.hidden = YES;
    [self callBloodPressureStatListAPI];
    
    
}


-(void)deleteAction:(id)sender
{
    UIButton *button = sender;
    NSDictionary *rowDictionary = [_bloodPressureStatsArray objectAtIndex:(int)button.tag];
    [self callBloodPressureDeleteAPI:rowDictionary];
}

-(void)callBloodPressureStatListAPI
{
    if([[self.navigationController.viewControllers lastObject] isEqual:self])
    {
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiritId = [userInfoDic valueForKey:@"emiratesid"];
    
    NSDictionary *loginDictionary  = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];;
    NSLog(@"Token: %@",[loginDictionary valueForKey:@"token"]);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[loginDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[loginDictionary valueForKey:@"memberid"] forKey:@"principalmemberid"];
    [dictionary setValue:[NSNumber numberWithInt:10000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"datafilter"];
    [dictionary setValue:@"" forKey:@"datefrom"];
    [dictionary setValue:@"" forKey:@"dateto"];

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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"BloodPressureList"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[loginDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [_bloodPressureStatsArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"bloodpressure"]).count > 0)
                     {
                         //[_historyInfoDictionary setValue:[responseDictionary valueForKey:@"claims"] forKey:@"claims"];
                         [_bloodPressureStatsArray addObjectsFromArray:[responseDictionary valueForKey:@"bloodpressure"]];
                         
                         NSArray *arrKeys = [_bloodPressureStatsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                                 
                                 
                                 
                             }else{
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
                                 
                                 
                             }
                             [df setDateFormat:@"dd MMM yyyy"];
                             NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"date"]];
                             NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"date"]];
                             return [d2 compare: d1];
                         }];
                         [_bloodPressureStatsArray removeAllObjects];
                         [_bloodPressureStatsArray addObjectsFromArray:arrKeys];
                         
                         [self saveDataInCoreData:_bloodPressureStatsArray];
                     }
                     [_collectionView reloadData];
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
}



-(void)saveDataInCoreData:(NSArray *)bloodPressureData{
    
    [[DbManager getSharedInstance] deleteObjectsForEntity:@"BloodPressure" withPredicate:nil];

    for (NSDictionary *data in bloodPressureData) {
        
        BloodPressure *bp = [NSEntityDescription insertNewObjectForEntityForName:@"BloodPressure"
                                                 inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        
        bp.date = [data valueForKey:@"date"];
        bp.bloodressureid = [data valueForKey:@"id"];
        bp.diastolic = [data valueForKey:@"diastolic"];
        bp.time = [data valueForKey:@"time"];
        bp.pulse = [data valueForKey:@"pulse"];
        bp.systolic = [data valueForKey:@"systolic"];
        
        [[DbManager getSharedInstance] saveContext];
    }
}







-(void)callBloodPressureDeleteAPI:(NSDictionary *)inputDictionary
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[inputDictionary valueForKey:@"id"] forKey:@"bloodressureid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[inputDictionary valueForKey:@"diastolic"] forKey:@"diastolic"];
    [dictionary setValue:[inputDictionary valueForKey:@"systolic"] forKey:@"systolic"];
    [dictionary setValue:[inputDictionary valueForKey:@"pulse"] forKey:@"pulse"];
    
    NSDate *date = [self.previousDateFormatter dateFromString:[inputDictionary valueForKey:@"date"]];
    self.saveDateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateFormatter stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSString *timeString = [inputDictionary valueForKey:@"time"];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"delete" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveBloodPressure"];
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
                     [_bloodPressureStatsArray removeObject:inputDictionary];
                     
                     [_collectionView reloadData];
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Deleted Successfully!"] block:^(int index)
                      {
                      }];
                     
                 }//[Localization languageSelectedStringForKey:@"Deleted Successfully!"]
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

