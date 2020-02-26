//
//  BloodSugarDeleteViewController.m
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "BloodSugarDeleteViewController.h"
#import "BloodSugarStatesCollectionViewCell.h"
#import "Utility.h"
#import "DbManager.h"
#import "Constant.h"
#import "Localization.h"
#import "ConnectionManager.h"
#import "AppDelegate.h"
#import "HBAStatesCollectionViewCell.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
@interface BloodSugarDeleteViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

@property (strong, nonatomic) NSDateFormatter *saveDateFormatter;
@property (strong, nonatomic) NSDateFormatter *timeSavedFormatter;


@end

@implementation BloodSugarDeleteViewController
#define dateitemSize CGSizeMake(80,30)
#define itemSize CGSizeMake(140,30)
#define deleteitemSize CGSizeMake(80,30)


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bloodsugerLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Stats"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
       bloodsugerLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Stats"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd/MM/yyyy";
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    self.timeFormatter.dateFormat = @"dd MMM yyyy";
    
    self.timeSavedFormatter = [[NSDateFormatter alloc] init];
    self.timeSavedFormatter.dateFormat = @"HH:mm";
    
    self.saveDateFormatter = [[NSDateFormatter alloc] init];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.timeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.timeSavedFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
    }else{
        
        [self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.timeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.timeSavedFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.saveDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
    }
    NSArray *arrKeys = [self.bloodSugarStatsArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
            
            [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
          
            
        }else{
            
            [df  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
          
        }
        [df setDateFormat:@"HH:mm"];
        NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"time"]];
        NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"time"]];
        return [d2 compare: d1];
    }];
    [self.bloodSugarStatsArray removeAllObjects];
    [self.bloodSugarStatsArray addObjectsFromArray:arrKeys];
    
    _dateLabel.text = [NSString stringWithFormat:@"Date: %@",[[self.bloodSugarStatsArray firstObject] valueForKey:@"date"]];
    _slotLabel.text = [NSString stringWithFormat:@"Slot: %@",self.displaySlot];
    // Do any additional setup after loading the view.
    [_collectionView registerNib:[UINib nibWithNibName:@"BloodSugarStatesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BloodSugarStatesCollectionIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.tag = 5;
    
    _collectionView.backgroundColor = [UIColor clearColor];
    //[Localization languageSelectedStringForKey:@"Blood Sugar"]
    _titleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Time"],[Localization languageSelectedStringForKey:@"Blood Sugar"],@"X", nil];

    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    //_bloodSugarStatsArray = [[NSMutableArray alloc] init];
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
    if(self.bloodSugarStatsArray.count > 0)
        return 3;
    else
        return 0;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    if(self.bloodSugarStatsArray.count > 0)
        return self.bloodSugarStatsArray.count + 1;
    else
        return 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Section.. %d  Row... %d",indexPath.section, indexPath.row);
    
    BloodSugarStatesCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"BloodSugarStatesCollectionIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    cell.deleteButton.hidden = YES;
    cell.bottomItemLineView.hidden = YES;
    
    // add border to the cell
    [self addBorderToCell:cell atIndexPath:indexPath];

    if(indexPath.section == 0)
    {
        if(indexPath.row == 1)
            cell.titleLabel.text = self.displaySlot;
        else
            cell.titleLabel.text = _titleArray[indexPath.row];
        
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    }
    else
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.titleLabel.font = [UIFont systemFontOfSize:10];
        if(indexPath.row == 0)
        {
            NSString *timeString = [self.bloodSugarStatsArray[indexPath.section - 1] valueForKey:@"time"];
            self.timeSavedFormatter.dateFormat = @"HH:mm";
            NSDate *timeDate = [self.timeSavedFormatter dateFromString:timeString];
            self.timeSavedFormatter.dateFormat = @"hh:mm a";
            timeString = [self.timeSavedFormatter stringFromDate:timeDate];
            cell.titleLabel.text = timeString;
        }
        else if(indexPath.row == 1)
        {
            cell.titleLabel.text = [[self.bloodSugarStatsArray objectAtIndex:indexPath.section - 1] valueForKey:@"bloodsugar"];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return dateitemSize;
    else if(indexPath.row == 1)
        return itemSize;
    else if(indexPath.row == 2)
    {
        return deleteitemSize;
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
    
    float margin = (self.view.frame.size.width - (itemSize.width + dateitemSize.width +  deleteitemSize.width))/2;
    
    return UIEdgeInsetsMake(0,margin,0,margin);  // top, left, bottom, right

}


#pragma mark- Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)deleteAction:(id)sender
{
    UIButton *button = sender;
    
    NSDictionary *rowDictionary = [self.bloodSugarStatsArray objectAtIndex:button.tag];
    [self callBloodSugarDeleteAPI:rowDictionary];
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
                     //[Localization languageSelectedStringForKey:@"Deleted Successfully!"]
                     [Utility showAlertViewControllerIn:self title:nil message: [Localization languageSelectedStringForKey:@"Deleted Successfully!"] block:^(int index)
                      {
                          [self.navigationController popViewControllerAnimated:true];
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


