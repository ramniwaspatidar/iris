//
//  BMIDetailViewController.h
//  Iris
//
//  Created by apptology on 21/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UICollectionView *_collectionView;
    NSMutableArray *_titleArray;
    NSMutableArray *_bmiStatsArray;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    __weak IBOutlet UIButton *topBtn;
    NSString *fromDate;
    NSString *selectedFilter;
    
    __weak IBOutlet UIView *_filterListContainerView;
    __weak IBOutlet UIButton *sixMonthOptionButton;
    __weak IBOutlet UIButton *threeMonthOptionButton;
    __weak IBOutlet UIButton *oneMonthOptionButton;
    __weak IBOutlet UIButton *allOptionButton;
    
    __weak IBOutlet UILabel *allLbl;
    __weak IBOutlet UILabel *lastoneLbl;
    __weak IBOutlet UILabel *lastthreeLbl;
    __weak IBOutlet UILabel *lastSixLbl;
    
    __weak IBOutlet UILabel *dateLbl;
    __weak IBOutlet UILabel *wieghtLbl;
    __weak IBOutlet UILabel *heightLbl;
    __weak IBOutlet UILabel *bmiLbl;
    __weak IBOutlet UILabel *categoryLbl;
    
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UILabel *bmiCatLbl;
    __weak IBOutlet UILabel *uderweightLbl;
    __weak IBOutlet UILabel *normalLbl;
    __weak IBOutlet UILabel *overweightLbl;
    __weak IBOutlet UILabel *obesityLbl;
    __weak IBOutlet UILabel *bmistateLbl;
    
    
    
    
    
}
@end
