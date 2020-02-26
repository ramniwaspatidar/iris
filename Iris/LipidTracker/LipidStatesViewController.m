//
//  BMIDetailViewController.m
//  Iris
//
//  Created by apptology on 21/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "LipidStatesViewController.h"
#import "LipidStatesCollectionViewCell.h"
#import "Utility.h"
#import "DbManager.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "LipidChartViewController.h"
#import "Lipid+CoreDataProperties.h"
#import "Reachability.h"
#import "UILabel+CustomLabel.h"

#import "MainSideMenuViewController.h"
#import "Localization.h"

#define cholestrolitemSize CGSizeMake(50,38)
#define DateItemSize CGSizeMake(48,38)
#define trigItemSize CGSizeMake(64,38)
#define hdlItemSize CGSizeMake(44,38)
#define ldltemSize CGSizeMake(44,38)
#define DeletetemSize CGSizeMake(28,38)


@interface LipidStatesViewController (){
    Reachability * internetReachability;

}
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateFormatter;

@end

@implementation LipidStatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    internetReachability=[Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    
    selectedFilter = [Localization languageSelectedStringForKey:@"all"];
    allOptionButton.selected = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.saveDateFormatter = [[NSDateFormatter alloc] init];

    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [  self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [  self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [  self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
    }else{
        
        [  self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [  self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [  self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
    }
    // Do any additional setup after loading the view.
    [_collectionView registerNib:[UINib nibWithNibName:@"LipidStatesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LipidStatesCollectionCellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];

    _titleArray = [[NSMutableArray alloc] initWithObjects:
                   [Localization languageSelectedStringForKey:@"Date"], [Localization languageSelectedStringForKey:@"Choles-terol"],[Localization languageSelectedStringForKey:@"LDL"],[Localization languageSelectedStringForKey:@"HDL"],[Localization languageSelectedStringForKey:@"Trigly-cerides"],@"X", nil];
    
    _lipidStatsArray = [[NSMutableArray alloc] init];
    [self loadData];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([Utility IsiPhoneX])
    {
        topViewCons.constant = 0;
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        allLbl.text =  [Localization languageSelectedStringForKey:@"All"];
        lastoneLbl.text =  [Localization languageSelectedStringForKey:@"Last One Month"];
        lastThreeLbl.text =  [Localization languageSelectedStringForKey:@"Last Three Month"];
        lastSixLbl.text =  [Localization languageSelectedStringForKey:@"Last Six Month"];
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Stats"];
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
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Stats"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[Localization languageSelectedStringForKey:@"Lipid Stats"]
    [Utility trackGoogleAnalystic: [Localization languageSelectedStringForKey:@"Lipid Stats"]];
}

-(void)loadData{
    
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            _lipidStatsArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"Lipid" withPredicate:nil sortKey:nil ascending:NO].mutableCopy;
            break;
        }
        case ReachableViaWiFi:
        {
            [self callLipidStatListAPI];
            break;
        }
        case ReachableViaWWAN:
        {
            [self callLipidStatListAPI];
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
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if(_lipidStatsArray.count > 0)
        return _lipidStatsArray.count + 1;
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LipidStatesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LipidStatesCollectionCellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.deleteButton.hidden = YES;
    cell.titleHeightConstant.constant = 40;
    cell.title.numberOfLines = 2;
    
    // add border to the cell
    [self addBorderToCell:cell atIndexPath:indexPath];

    if(indexPath.section == 0)
    {
        cell.title.text = _titleArray[indexPath.row];
        cell.title.font = [UIFont boldSystemFontOfSize:12];
    }
    else
    {
        cell.title.font = [UIFont systemFontOfSize:11];
        cell.deleteButton.hidden = YES;
        
        if(indexPath.row == 0)
        {
            //NSDate *date = [self.previousDateFormatter dateFromString:[_lipidStatsArray[indexPath.section] valueForKey:@"date"]];
            
            NSString *dateString = [_lipidStatsArray[indexPath.section - 1] valueForKey:@"date"];
            
            cell.title.text = dateString;
        }
        else if(indexPath.row == 1)
        {
            cell.title.text = [NSString stringWithFormat:@"%@\n%@",[_lipidStatsArray[indexPath.section - 1] valueForKey:@"cholestrol"],[_lipidStatsArray[indexPath.section - 1] valueForKey:@"lipidunit"]] ;
        }
        else if(indexPath.row == 2)
            cell.title.text = [NSString stringWithFormat:@"%@\n%@",[_lipidStatsArray[indexPath.section - 1] valueForKey:@"ldl"],[_lipidStatsArray[indexPath.section - 1] valueForKey:@"lipidunit"]];
        else if(indexPath.row == 3)
            cell.title.text = [NSString stringWithFormat:@"%@\n%@",[_lipidStatsArray[indexPath.section - 1] valueForKey:@"hdl"],[_lipidStatsArray[indexPath.section - 1] valueForKey:@"lipidunit"]];
        else if(indexPath.row == 4)
        {
            //cell.title.numberOfLines = 2;
            //cell.titleHeightConstant.constant = 40;
            cell.title.text = [NSString stringWithFormat:@"%@\n%@",[_lipidStatsArray[indexPath.section - 1] valueForKey:@"triglycerides"],[_lipidStatsArray[indexPath.section - 1] valueForKey:@"lipidunit"]];;
        }
        else if(indexPath.row == 5)
        {
            cell.backgroundColor = [UIColor clearColor];
            if(cell.deleteButton)
            {
                cell.deleteButton.tag = indexPath.section - 1;
                [cell.deleteButton addTarget:self
                                    action:@selector(deleteAction:)
                          forControlEvents:UIControlEventTouchUpInside];
                cell.title.text = @"";
                cell.deleteButton.hidden = NO;
            }
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return DateItemSize;
    else if(indexPath.row == 1)
        return cholestrolitemSize;
    else if(indexPath.row == 2)
        return ldltemSize;
    else if(indexPath.row == 3)
        return hdlItemSize;
    else if(indexPath.row == 4)
        return trigItemSize;
    else if(indexPath.row == 5)
        return DeletetemSize;
    return  CGSizeZero;
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
    
    float leftmargin = (self.view.frame.size.width - (DateItemSize.width+cholestrolitemSize.width+ldltemSize.width+hdlItemSize.width+trigItemSize.width + DeletetemSize.width))/2;
    return UIEdgeInsetsMake(0,leftmargin,0,0);  // top, left, bottom, right
}


#pragma mark- Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteAction:(id)sender
{
    UIButton *button = sender;
    NSDictionary *rowDictionary = [_lipidStatsArray objectAtIndex:(int)button.tag];
    [self callLipidDeleteAPI:rowDictionary];
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

- (IBAction)viewChartButtonAction:(id)sender {
    if(_lipidStatsArray.count > 0)
        [self performSegueWithIdentifier:kLipidChartIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kLipidChartIdentifier])
    {
        LipidChartViewController *lipidChartViewController = segue.destinationViewController;
        lipidChartViewController.lipidArray = [_lipidStatsArray copy];
    }
    
}


-(IBAction)filterDataButtonAction:(id)sender
{

    UIButton *selectedButton = sender;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    if(selectedButton.tag == 1)
    {
        if(allOptionButton.selected)
            return;
        selectedFilter = [Localization languageSelectedStringForKey:@"all"];
        allOptionButton.selected = YES;
        fromDate = nil;
        _filterListContainerView.hidden = YES;
        [self callLipidStatListAPI];
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
    [self callLipidStatListAPI];


}

-(void)callLipidStatListAPI
{
    if([[self.navigationController.viewControllers lastObject] isEqual:self])
    {
   NSDictionary *loginDictionary  = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];;
    NSLog(@"Token: %@",[loginDictionary valueForKey:@"token"]);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[loginDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    //[dictionary setValue:[loginDictionary valueForKey:@"memberid"] forKey:@"principalmemberid"];
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
            
            [ dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
       
        }else{
            
            [ dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
          
        }
        NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [dictionary setValue:toDateString forKey:@"dateto"];
    }

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"LipidTrackerList"];
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
                     [_lipidStatsArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"lipidtracker"]).count > 0)
                     {
                         //[_historyInfoDictionary setValue:[responseDictionary valueForKey:@"claims"] forKey:@"claims"];
                         [_lipidStatsArray addObjectsFromArray:[responseDictionary valueForKey:@"lipidtracker"]];
                         
                         NSArray *arrKeys = [_lipidStatsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                                 
                                 [  df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                                 
                             }else{
                                 
                                 [  df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
                                 
                             }
                             [df setDateFormat:@"dd MMM yyyy"];
                             NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"date"]];
                             NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"date"]];
                             return [d2 compare: d1];
                         }];
                         [_lipidStatsArray removeAllObjects];
                         [_lipidStatsArray addObjectsFromArray:arrKeys];
                         
                         [self saveDataInCoreData:_lipidStatsArray];
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


-(void)saveDataInCoreData:(NSArray *)bmiData{
    
    [[DbManager getSharedInstance] deleteObjectsForEntity:@"Lipid" withPredicate:nil];

    for (NSDictionary *data in bmiData) {

        Lipid *lip = [NSEntityDescription insertNewObjectForEntityForName:@"Lipid"
                                                 inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
        lip.cholestrol = [data valueForKey:@"cholestrol"];
        lip.hdl = [data valueForKey:@"hdl"];
        lip.date = [data valueForKey:@"date"];
        lip.lipidid = [data valueForKey:@"id"];
        lip.time = [data valueForKey:@"time"];
        lip.lipidunit = [data valueForKey:@"lipidunit"];
        lip.ldl = [data valueForKey:@"ldl"];
        lip.triglycerides = [data valueForKey:@"triglycerides"];

        [[DbManager getSharedInstance] saveContext];
    }
}








-(void)callLipidDeleteAPI:(NSDictionary *)inputDictionary
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[inputDictionary valueForKey:@"id"] forKey:@"lipidtrackerid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[inputDictionary valueForKey:@"cholestrol"] forKey:@"cholestrol"];
    [dictionary setValue:[inputDictionary valueForKey:@"ldl"] forKey:@"ldl"];
    [dictionary setValue:[inputDictionary valueForKey:@"hdl"] forKey:@"hdl"];
    [dictionary setValue:[inputDictionary valueForKey:@"triglycerides"] forKey:@"triglycerides"];
    [dictionary setValue:[inputDictionary valueForKey:@"lipidunit"] forKey:@"lipidunit"];
    
   NSDate *date = [self.previousDateFormatter dateFromString:[inputDictionary valueForKey:@"date"]];
    self.saveDateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateFormatter stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSString *timeString = [inputDictionary valueForKey:@"time"];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"delete" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveLipidTracker"];
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
                     [_lipidStatsArray removeObject:inputDictionary];

                     [_collectionView reloadData];
                     
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Deleted Successfully!"]  block:^(int index)
                      {
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
