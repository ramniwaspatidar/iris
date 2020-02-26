//
//  LipidStatesViewController.h
//  Iris
//
//  Created by apptology on 21/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LipidStatesViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet NSLayoutConstraint *topViewCons;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    NSMutableArray *_titleArray;
    NSMutableArray *_lipidStatsArray;
    NSString *fromDate;
    NSString *selectedFilter;
    
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UIView *_filterListContainerView;
    __weak IBOutlet UIButton *sixMonthOptionButton;
    __weak IBOutlet UIButton *threeMonthOptionButton;
    __weak IBOutlet UIButton *oneMonthOptionButton;
    __weak IBOutlet UIButton *allOptionButton;
  
    __weak IBOutlet UILabel *allLbl;
    __weak IBOutlet UILabel *lastoneLbl;
    __weak IBOutlet UILabel *lastThreeLbl;
    __weak IBOutlet UILabel *lastSixLbl;
    
    
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *bloodstatLbl;
}
@end
