//
//  BloodSugarStatesViewController.h
//  Iris
//
//  Created by apptology on 25/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarStatesViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    __weak IBOutlet NSLayoutConstraint *bottomBarLeadingCons;
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet NSLayoutConstraint *tableContainerViewWidthCons;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UICollectionView *_hbCollectionView;
    
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet UIButton *topBtn;
    NSMutableArray *_titleArray;
    //NSMutableArray *_actualTitleArray;
    NSMutableArray *_hbTitleArray;
    NSMutableArray *_bloodSugarStatsArray;
    NSMutableArray *_hbStatsArray;
    NSMutableArray *_sortedDateArray;
    
    NSString *fromDate;
    NSString *selectedSugarFilter;
    NSString *selectedHBFilter;
    
    __weak IBOutlet UIView *_filterListContainerView;
    __weak IBOutlet UIButton *sixMonthOptionButton;
    __weak IBOutlet UIButton *threeMonthOptionButton;
    __weak IBOutlet UIButton *oneMonthOptionButton;
    __weak IBOutlet UIButton *allOptionButton;
    
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    __weak IBOutlet UILabel *allLbl;
    __weak IBOutlet UILabel *lastoneLbl;
    __weak IBOutlet UILabel *lastThreeLbl;
    __weak IBOutlet UILabel *lastSixLbl;
    
    __weak IBOutlet UIButton *bloodsugarBtn;
    __weak IBOutlet UIButton *hbBtn;
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *bloodstatLbl;
    
    
    
    
}
@property(nonatomic,assign)BOOL shouldReloadData;

@end

