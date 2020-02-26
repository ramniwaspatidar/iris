//
//  BloodSugarStatesViewController.m
//  Iris
//
//  Created by apptology on 25/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "BloodSugarStatesViewController.h"
#import "BloodSugarStatesCollectionViewCell.h"
#import "Utility.h"
#import "DbManager.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "Localization.h"
#import "AppDelegate.h"
#import "HBAStatesCollectionViewCell.h"
#import "BloodSugarDeleteViewController.h"
#import "BloodSuagarChartViewController.h"
#import "HBAChartViewController.h"
#import "BloodSugar+CoreDataProperties.h"
#import "Reachability.h"
#import "HB1AC+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"

@interface BloodSugarStatesViewController (){
    Reachability * internetReachability;
    BOOL hasInternet;
}
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@property (strong, nonatomic) NSDateFormatter *saveDateFormatter;

@end

@implementation BloodSugarStatesViewController
#define itemSize CGSizeMake(28,40)
#define mediumitemSize CGSizeMake(38,40)
#define bigitemSize CGSizeMake(40,40)
#define dateitemSize CGSizeMake(66,40)
#define deleteitemSize CGSizeMake(20,40)

#define hbdateitemSize CGSizeMake(100,40)
#define hbitemSize CGSizeMake(70,40)
#define hbdeleteitemSize CGSizeMake(60,40)
static NSInteger previousPage = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    internetReachability=[Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    previousPage = 5;
    // [Localization languageSelectedStringForKey:@"all"]
    selectedHBFilter = [Localization languageSelectedStringForKey:@"all"];
    selectedSugarFilter = [Localization languageSelectedStringForKey:@"all"];
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
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Stats"];
        [bloodsugarBtn setTitle:[Localization languageSelectedStringForKey:@"BLOOD SUGAR"] forState:UIControlStateNormal];
         [hbBtn setTitle:[Localization languageSelectedStringForKey:@"HB1AC"] forState:UIControlStateNormal];

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
        bloodstatLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Stats"];
        [bloodsugarBtn setTitle:[Localization languageSelectedStringForKey:@"BLOOD SUGAR"] forState:UIControlStateNormal];
        [hbBtn setTitle:[Localization languageSelectedStringForKey:@"HB1AC"] forState:UIControlStateNormal];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    allOptionButton.selected = YES;
    self.shouldReloadData = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    self.saveDateFormatter = [[NSDateFormatter alloc] init];

    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
    }
    // Do any additional setup after loading the view.
    [_collectionView registerNib:[UINib nibWithNibName:@"BloodSugarStatesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BloodSugarStatesCollectionIdentifier"];
    
    [_hbCollectionView registerNib:[UINib nibWithNibName:@"HBAStatesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HBAStatesCollectionIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.tag = 5;
    [_hbCollectionView setCollectionViewLayout:flowLayout1];
    _hbCollectionView.tag = 4;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _hbCollectionView.backgroundColor = [UIColor clearColor];
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Date"],@"6am-10am",@"10am-2pm",@"2pm-6pm",@"6pm-10pm",@"10pm-2am",@"2am-6am", nil];
    //_actualTitleArray = [[NSMutableArray alloc] initWithObjects:@"Date",@"0-4",@"4-8",@"8-12",@"12-16",@"16-20",@"20-24", nil];
    _hbTitleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Date"],@"HBA1C",@"X",nil];
    
    _bloodSugarStatsArray = [[NSMutableArray alloc] init];
    _hbStatsArray = [[NSMutableArray alloc] init];
    _sortedDateArray = [[NSMutableArray alloc] init];
     tableContainerViewWidthCons.constant = (self.view.frame.size.width *2);
    _scrollView.contentSize = CGSizeMake(tableContainerViewWidthCons.constant, self.view.frame.size.height);
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.shouldReloadData)
        [self loadBloodSugarData];
    
    self.shouldReloadData = YES;
}



-(void)loadBloodSugarData{
    
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            _bloodSugarStatsArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"BloodSugar" withPredicate:nil sortKey:nil ascending:NO].mutableCopy;
            
            for(int i = 0; i< _bloodSugarStatsArray.count; i++)
            {
                NSString *dateString = [[_bloodSugarStatsArray objectAtIndex:i] valueForKey:@"date"];
                if(![_bloodSugarStatsArray containsObject:dateString])
                    [_sortedDateArray addObject:dateString];
            }
            _sortedDateArray = [[_sortedDateArray valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]] mutableCopy];

            NSArray *arrKeys = [_sortedDateArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                    
                    [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                 
                    
                }else{
                    
                    [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
                  
                }
                [df setDateFormat:@"dd MMM yyyy"];
                NSDate *d1 = [df dateFromString:(NSString*) obj1];
                NSDate *d2 = [df dateFromString:(NSString*) obj2];
                return [d2 compare: d1];
            }];
            [_sortedDateArray removeAllObjects];
            [_sortedDateArray addObjectsFromArray:[arrKeys mutableCopy]];
            [_collectionView reloadData];

            break;
        }
        case ReachableViaWiFi:
        {
            
            [self callBloodSugarStatListAPI];
            break;
        }
        case ReachableViaWWAN:
        {
            [self callBloodSugarStatListAPI];
            break;
        }
    }
}





-(void)loadHB1ACData{
    
    NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            hasInternet = false;
            _hbStatsArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"HB1AC" withPredicate:nil sortKey:nil ascending:NO].mutableCopy;
            [_hbCollectionView reloadData];
            
            break;
        }
        case ReachableViaWiFi:
        {
            hasInternet = true;
            [self callHBStatListAPI];
            break;
        }
        case ReachableViaWWAN:
        {
            hasInternet = true;
            [self callHBStatListAPI];
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
    if(collectionView.tag == 5)
    {
        if(_sortedDateArray.count > 0)
            return 7;
    }
    else
        if(_hbStatsArray.count > 0)
            return 3;
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    if(collectionView.tag == 5)
    {
        if(_sortedDateArray.count > 0)
            return _sortedDateArray.count + 1;
        else
            return 0;
    }
    else
    {
        if(_hbStatsArray.count > 0)
            return _hbStatsArray.count + 1;
        else
            return 0;
    }
    return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Section.. %d  Row... %d",indexPath.section, indexPath.row);

    if(indexPath.row == 2)
    {
        NSLog(@"hi");
    }
    if(collectionView.tag == 5)
    {
        
        BloodSugarStatesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BloodSugarStatesCollectionIdentifier" forIndexPath:indexPath];
        
        cell.backgroundColor=[UIColor clearColor];

        NSArray *filteredArray = nil;
        cell.deleteButton.hidden = YES;
        cell.bottomItemLineView.hidden = YES;
        //cell.titleLabel.textColor = [UIColor blackColor];
        
        // add border to the cell
        [self addBorderToCell:cell atIndexPath:indexPath];

        if(_sortedDateArray.count == 0)
            return cell;
        
        cell.titleLabel.backgroundColor = [UIColor clearColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        
        if(_sortedDateArray.count > 0 && indexPath.section > 0 && indexPath.row > 0 && indexPath.row < 7)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date == %@ AND SELF.slot == %@",[_sortedDateArray objectAtIndex:indexPath.section - 1],[_titleArray objectAtIndex:indexPath.row]];
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
            
            filteredArray = [[_bloodSugarStatsArray filteredArrayUsingPredicate:predicate]
                                sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
           
            if(filteredArray.count > 1) {
                cell.bottomItemLineView.hidden = NO;
                cell.titleLabel.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(96.0/255.0) blue:(175.0/255.0) alpha:1.0];
                cell.titleLabel.textColor = [UIColor whiteColor];
            } else {
                cell.titleLabel.backgroundColor = [UIColor clearColor];
                cell.titleLabel.textColor = [UIColor blackColor];
            }
        }
        
        if(indexPath.section == 0)
        {
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.titleLabel.text = _titleArray[indexPath.row];
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            
//            cell.layer.borderWidth = 1.0;
//            cell.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        }
        else
        {
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];

            cell.titleLabel.font = [UIFont systemFontOfSize:10];
            if(indexPath.row == 0)
            {
                NSDate *date = [self.previousDateFormatter dateFromString:_sortedDateArray[indexPath.section - 1]];
                
                NSString *dateString = _sortedDateArray[indexPath.section - 1]; //[self.dateFormatter stringFromDate:date];
                
                cell.titleLabel.text = dateString;
            }
            else if(indexPath.row < 7)
            {
                if(filteredArray.count > 0)
                    cell.titleLabel.text = [[filteredArray lastObject] valueForKey:@"bloodsugar"];
                else
                    cell.titleLabel.text = [Localization languageSelectedStringForKey:@"N/A"];
            }
            else
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
    else
    {
        HBAStatesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"HBAStatesCollectionIdentifier" forIndexPath:indexPath];
        
        cell.deleteButton.hidden = YES;
        cell.backgroundColor=[UIColor clearColor];
        
        // add border to the cell
        [self addBorderToCell:cell atIndexPath:indexPath];

        if(_hbStatsArray.count == 0)
            return cell;
        
        if(indexPath.section == 0)
        {
            cell.titleLabel.text = _hbTitleArray[indexPath.row];
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        }
        else
        {
            cell.titleLabel.font = [UIFont systemFontOfSize:12];
            
            if(indexPath.row == 0)
            {
                NSDate *date = [self.previousDateFormatter dateFromString:[_hbStatsArray[indexPath.section - 1]valueForKey:@"date"]];
                
                NSString *dateString = [_hbStatsArray[indexPath.section - 1]valueForKey:@"date"];//[self.dateFormatter stringFromDate:date];
                
                cell.titleLabel.text = dateString;
            }
            else if(indexPath.row == 1)
            {
                if(hasInternet == true){
                    cell.titleLabel.text = [_hbStatsArray[indexPath.section - 1]valueForKey:@"HBA1C"];
                }else{
                    cell.titleLabel.text = [_hbStatsArray[indexPath.section - 1]valueForKey:@"hba1c"];
                }
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                if(cell.deleteButton)
                {
                    cell.deleteButton.tag = indexPath.section - 1;
                    [cell.deleteButton addTarget:self
                                          action:@selector(deleteHbAction:)
                                forControlEvents:UIControlEventTouchUpInside];
                    cell.titleLabel.text = @"";
                    cell.deleteButton.hidden = NO;
                }
            }
        }
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag ==5)
    {
        if(indexPath.row == 0)
            return dateitemSize;
        else if(indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5)
            return bigitemSize;
        else if(indexPath.row == 3 || indexPath.row == 6)
            return mediumitemSize;

        /*
        if(indexPath.row == 0)
            return dateitemSize;
        else if(indexPath.row == 1 || indexPath.row == 5)
            return mediumitemSize;
        else if(indexPath.row == 3 || indexPath.row == 2 || indexPath.row == 4)
        {
            return bigitemSize;
        }
        else if( indexPath.row == 6)
            return itemSize;
        else if(indexPath.row == 7)
            return deleteitemSize;
         */
    }
    else
    {
        if(indexPath.row ==0)
            return hbdateitemSize;
        else if(indexPath.row == 1)
            return hbitemSize;
        else
            return hbdeleteitemSize;
    }
    
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
    //return UIEdgeInsetsMake(0,(self.view.frame.size.width - (DateItemSize.width+HeighttemSize.width+WeightitemSize.width+BMIItemSize.width+CategoryItemSize.width))/6,0,0);  // top, left, bottom, right
    float margin = 0;
    if(collectionView.tag == 5)
    {
        margin = (self.view.frame.size.width - ((mediumitemSize.width *2) + (bigitemSize.width *4) + dateitemSize.width))/2;
    }
    else
    {
        margin = (self.view.frame.size.width - (hbdateitemSize.width + hbitemSize.width + hbdeleteitemSize.width))/2;
        

    }
    return UIEdgeInsetsMake(0,margin,0,margin);  // top, left, bottom, right

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // always reload the selected cell, so we will add the border to that cell
    if(indexPath.section > 0 && indexPath.row > 0)
    {
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date == %@ AND SELF.slot == %@",[_sortedDateArray objectAtIndex:indexPath.section - 1],[_titleArray objectAtIndex:indexPath.row]];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
        
        NSMutableArray *filteredArray = [[[_bloodSugarStatsArray filteredArrayUsingPredicate:predicate]
                                          sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]mutableCopy] ;
        
        NSLog(@"Hello");
        if(filteredArray.count > 0)
            [self performSegueWithIdentifier:kSugarDeleteIdentifier sender:filteredArray];
    }
    /*if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            
            self.selectedItemIndexPath = nil;
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        
        self.selectedItemIndexPath = indexPath;
    }
    */
    // and now only reload only the cells that need updating
    
    
    

    
    //[collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kSugarDeleteIdentifier])
    {
        NSMutableArray *senderArray = sender;
        BloodSugarDeleteViewController *bloodSugarDeleteViewController = segue.destinationViewController;
        bloodSugarDeleteViewController.bloodSugarStatsArray = sender;
        if([_titleArray containsObject:[[senderArray firstObject] valueForKey:@"slot"]])
        {
            int indexValue = (int)[_titleArray indexOfObject:[[senderArray firstObject] valueForKey:@"slot"]];
            bloodSugarDeleteViewController.displaySlot = [_titleArray objectAtIndex:indexValue];
        }
        
    }
    if ([segue.identifier isEqualToString:kBloodSugarChartIdentifier])
    {
        self.shouldReloadData = NO;
        BloodSuagarChartViewController *bloodSugarChartViewController = segue.destinationViewController;
        bloodSugarChartViewController.bloodsugarArray = [_bloodSugarStatsArray copy];
    }
    if ([segue.identifier isEqualToString:kHBAChartIdentifier])
    {
        self.shouldReloadData = NO;
        HBAChartViewController *hbaChartViewController = segue.destinationViewController;
        hbaChartViewController.bloodsugarArray = [_hbStatsArray copy];
    }
    
}

#pragma mark- Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)viewChartButtonAction:(id)sender {
    
    if(_scrollView.contentOffset.x > 100)
    {
        if(_hbStatsArray.count > 0)
            [self performSegueWithIdentifier:kHBAChartIdentifier sender:nil];
    }
    else
    {
        if(_bloodSugarStatsArray.count > 0)
            [self performSegueWithIdentifier:kBloodSugarChartIdentifier sender:nil];
    }
}


-(IBAction)showFilterOptionList:(id)sender
{
    _filterListContainerView.hidden = NO;
    allOptionButton.selected = NO;
    oneMonthOptionButton.selected = NO;
    threeMonthOptionButton.selected = NO;
    sixMonthOptionButton.selected = NO;
    
    if(_scrollView.contentOffset.x > 0)
    {
        [self setSelectedFilter: selectedHBFilter];
    }
    else
    {
        [self setSelectedFilter: selectedSugarFilter];
    }
}

-(void)setSelectedFilter:(NSString *)previousSelectedFilter
{
    if([previousSelectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"all"]])
    {
        allOptionButton.selected = YES;
    }
    else if([previousSelectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"1 month"]])
    {
        oneMonthOptionButton.selected = YES;
    }
    else if([previousSelectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"3 month"]])
    {
        threeMonthOptionButton.selected = YES;
    }
    else if([previousSelectedFilter isEqualToString:[Localization languageSelectedStringForKey:@"6 month"]])
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
        allOptionButton.selected = YES;
        fromDate = nil;
        
        if(_scrollView.contentOffset.x > 0)
        {
            if([selectedHBFilter isEqualToString:[Localization languageSelectedStringForKey:@"all"]])
                return;
            selectedHBFilter = [Localization languageSelectedStringForKey:@"all"];
            [self loadHB1ACData];
        }
        else
        {
            if([selectedSugarFilter isEqualToString:[Localization languageSelectedStringForKey:@"all"]])
                return;
            selectedSugarFilter = [Localization languageSelectedStringForKey:@"all"];
            //[self callBloodSugarStatListAPI];
              [self loadBloodSugarData];
        }
        _filterListContainerView.hidden = YES;

        return;
        
    }
    else if(selectedButton.tag == 2)
    {
        if(_scrollView.contentOffset.x > 0)
        {
            if([selectedHBFilter isEqualToString:[Localization languageSelectedStringForKey:@"1 month"]])
                return;
            selectedHBFilter = [Localization languageSelectedStringForKey:@"1 month"];
        }
        else
        {
            if([selectedSugarFilter isEqualToString:[Localization languageSelectedStringForKey:@"1 month"]])
                return;
            selectedSugarFilter = [Localization languageSelectedStringForKey:@"1 month"];
        }

        oneMonthOptionButton.selected = YES;
        [dateComponents setMonth:-1];
    }
    else if(selectedButton.tag == 3)
    {
        if(_scrollView.contentOffset.x > 0)
        {
            if([selectedHBFilter isEqualToString:[Localization languageSelectedStringForKey:@"3 month"]])
                return;
            
            selectedHBFilter = [Localization languageSelectedStringForKey:@"3 month"];
        }
        else
        {
            if([selectedSugarFilter isEqualToString:[Localization languageSelectedStringForKey:@"3 month"]])
                return;
            selectedSugarFilter = [Localization languageSelectedStringForKey:@"3 month"];
        }

        threeMonthOptionButton.selected = YES;
        [dateComponents setMonth:-3];
        
        
    }
    else if(selectedButton.tag == 4)
    {
        if(_scrollView.contentOffset.x > 0)
        {
            if([selectedHBFilter isEqualToString:[Localization languageSelectedStringForKey:@"6 month"]])
                return;
            selectedHBFilter = [Localization languageSelectedStringForKey:@"6 month"];
        }
        else
        {
            if([selectedSugarFilter isEqualToString:[Localization languageSelectedStringForKey:@"6 month"]])
                return;
            selectedSugarFilter = [Localization languageSelectedStringForKey:@"6 month"];
        }

        sixMonthOptionButton.selected = YES;
        [dateComponents setMonth:-6];
        
        
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    fromDate = [self.dateFormatter stringFromDate:newDate];
    
    _filterListContainerView.hidden = YES;
    if(_scrollView.contentOffset.x > 0)
        [self loadHB1ACData];
    else
      //  [self callBloodSugarStatListAPI];
          [self loadBloodSugarData];
}


- (IBAction)bloodSugarButtonAction:(id)sender {
    bottomBarLeadingCons.constant = 0;
    _scrollView.contentOffset = CGPointMake(0, 0);
   // [self loadBloodSugarData];
}

- (IBAction)hb1acButtonAction:(id)sender {
    bottomBarLeadingCons.constant = self.view.frame.size.width/2;
    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
}



-(void)deleteHbAction:(id)sender
{
    UIButton *button = sender;
    NSDictionary *rowDictionary = [_hbStatsArray objectAtIndex:(int)button.tag];
    [self callHBADeleteAPI:rowDictionary];
}

-(void)deleteAction:(id)sender
{
    UIButton *button = sender;
    
    for(int i = 1; i < _titleArray.count - 1; i++)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date == %@ AND SELF.slot == %@",[_sortedDateArray objectAtIndex:(int)button.tag],[_titleArray objectAtIndex:i]];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
        
        NSArray *filteredArray = [[_bloodSugarStatsArray filteredArrayUsingPredicate:predicate]
                         sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        NSDictionary *rowDictionary = [filteredArray firstObject];
        [self callBloodSugarDeleteAPI:rowDictionary];
    }
}


-(void)callBloodSugarStatListAPI
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
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
        }
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [dictionary setValue:toDateString forKey:@"dateto"];
    }
    

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"BloodSugarList"];
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
                     [_bloodSugarStatsArray removeAllObjects];
                     [_sortedDateArray removeAllObjects];
                     NSArray *responseArray = [responseDictionary valueForKey:@"bloodsugar"];
                     if(responseArray.count > 0)
                     {
                         [_bloodSugarStatsArray addObjectsFromArray:[responseArray mutableCopy]];
                     
                         for(int i = 0; i< _bloodSugarStatsArray.count; i++)
                         {
                             NSString *dateString = [[_bloodSugarStatsArray objectAtIndex:i] valueForKey:@"date"];
                             if(![_bloodSugarStatsArray containsObject:dateString])
                                 [_sortedDateArray addObject:dateString];
                         }
                         _sortedDateArray = [[_sortedDateArray valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"self"]] mutableCopy];
                         
                         /*_sortedDateArray = [[_sortedDateArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
                          */
                         
                         NSArray *arrKeys = [_sortedDateArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                                 
                                 
                             }else{
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
                                 
                             }
                             [df setDateFormat:@"dd MMM yyyy"];
                             NSDate *d1 = [df dateFromString:(NSString*) obj1];
                             NSDate *d2 = [df dateFromString:(NSString*) obj2];
                             return [d2 compare: d1];
                         }];
                         [_sortedDateArray removeAllObjects];
                         [_sortedDateArray addObjectsFromArray:[arrKeys mutableCopy]];
                         [self saveDataInCoreData:_bloodSugarStatsArray];
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




-(void)saveDataInCoreData:(NSArray *)bloodSugarData{
    
    [[DbManager getSharedInstance] deleteObjectsForEntity:@"BloodSugar" withPredicate:nil];

    for (NSDictionary *data in bloodSugarData) {
        
        BloodSugar *bloodSugar = [NSEntityDescription insertNewObjectForEntityForName:@"BloodSugar"
                                                 inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
    
        bloodSugar.bloodsugar = [data valueForKey:@"bloodsugar"];
        bloodSugar.date = [data valueForKey:@"date"];
        bloodSugar.bloodsugarid = [data valueForKey:@"id"];
        bloodSugar.time = [data valueForKey:@"time"];
        bloodSugar.slot = [data valueForKey:@"slot"];
        bloodSugar.tag = [data valueForKey:@"tag"];
        bloodSugar.notes = [data valueForKey:@"notes"];
        
        [[DbManager getSharedInstance] saveContext];
    }
}




-(void)callHBStatListAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiritId = [userInfoDic valueForKey:@"emiratesid"];
    
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
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
            
            
        }else{
            
            [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
            
        }
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        NSString *toDateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [dictionary setValue:toDateString forKey:@"dateto"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"HBA1CList"];
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
                     [_hbStatsArray removeAllObjects];
                     if(((NSArray*)[responseDictionary valueForKey:@"hba1c"]).count > 0)
                     {
                         [_hbStatsArray addObjectsFromArray:[responseDictionary valueForKey:@"hba1c"]];
                         
                         NSArray *arrKeys = [_hbStatsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                             NSDateFormatter *df = [[NSDateFormatter alloc] init];
                             [df setDateFormat:@"dd MMM yyyy"];
                             if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                                 
                                 
                             }else{
                                 
                                 [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
                                 
                             }
                             NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"date"]];
                             NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"date"]];
                             return [d2 compare: d1];
                             }];

                         [_hbStatsArray removeAllObjects];
                         [_hbStatsArray addObjectsFromArray:arrKeys];
                         
                         [self saveDataInCoreDataHBA: _hbStatsArray];
                     }
                     [_hbCollectionView reloadData];
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



-(void)saveDataInCoreDataHBA:(NSArray *)bloodSugarData{
    
    [[DbManager getSharedInstance] deleteObjectsForEntity:@"HB1AC" withPredicate:nil];
    
    for (NSDictionary *data in bloodSugarData) {

        HB1AC *bloodSugar = [NSEntityDescription insertNewObjectForEntityForName:@"HB1AC"
                                                               inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];

        bloodSugar.hb1id = [data valueForKey:@"id"];
        bloodSugar.date = [data valueForKey:@"date"];
        bloodSugar.hba1c = [data valueForKey:@"HBA1C"];
        
        [[DbManager getSharedInstance] saveContext];
    }
}




-(void)callBloodSugarDeleteAPI:(NSDictionary *)inputDictionary
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[inputDictionary valueForKey:@"id"] forKey:@"bloodsugarid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[inputDictionary valueForKey:@"bloodsugar"] forKey:@"bloodsugar"];
    [dictionary setValue:[inputDictionary valueForKey:@"notes"] forKey:@"notes"];
    [dictionary setValue:[inputDictionary valueForKey:@"slot"] forKey:@"slot"];
    [dictionary setValue:[inputDictionary valueForKey:@"tag"] forKey:@"tag"];
    
    NSDate *date = [self.previousDateFormatter dateFromString:[inputDictionary valueForKey:@"date"]];
    self.saveDateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateFormatter stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSString *timeString = [inputDictionary valueForKey:@"time"];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"delete" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveBloodSugar"];
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
                     [_bloodSugarStatsArray removeObject:inputDictionary];
                     [_collectionView reloadData];
                     
                     [Utility showAlertViewControllerIn:self title:nil message: [Localization languageSelectedStringForKey:@"Deleted Successfully!"] block:^(int index)
                      {
                         
                      }];
                 }
                 else if([[responseDictionary valueForKey:@"status"] intValue] == 3)
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Session expired ,Please login"] block:^(int index)
                      {
                          [self.navigationController popViewControllerAnimated:YES];
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


-(void)callHBADeleteAPI:(NSDictionary *)inputDictionary
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setValue:[inputDictionary valueForKey:@"id"] forKey:@"hba1cid"];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[inputDictionary valueForKey:@"hba1c"] forKey:@"hba1c"];
    
    NSDate *date = [self.previousDateFormatter dateFromString:[inputDictionary valueForKey:@"date"]];
    self.saveDateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString = [self.saveDateFormatter stringFromDate:date];
    [dictionary setValue:dateString forKey:@"date"];
    
    NSString *timeString = [inputDictionary valueForKey:@"time"];
    [dictionary setValue:timeString forKey:@"time"];
    
    [dictionary setValue:@"delete" forKey:@"mode"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"AddRemoveHBA1C"];
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
                     [_hbStatsArray removeObject:inputDictionary];
                     [_hbCollectionView reloadData];
                     
                     [Utility showAlertViewControllerIn:self title:nil message: [Localization languageSelectedStringForKey:@"Deleted Successfully!"] block:^(int index)
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


#pragma mark- Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Finally, update previous page
        previousPage = page;
        _scrollView.contentOffset = CGPointMake(page*self.view.frame.size.width,0);
        if(page == 1)
        {
            bottomBarLeadingCons.constant = self.view.frame.size.width/2;
          //  if(_hbStatsArray.count == 0)
            if(self.shouldReloadData)
                [self loadHB1ACData];
        }
        else if(page == 0)
            bottomBarLeadingCons.constant = 0;
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

