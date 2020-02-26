//
//  PromotionViewController.h
//  Iris
//
//  Created by apptology on 04/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionViewController : UIViewController
{
    IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray * _promotionListArray;
    __weak IBOutlet UILabel *_phoneLabel;
    
    NSString *fromDate;
    NSString *selectedFilter;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIView *_filterListContainerView;
    __weak IBOutlet UIButton *sixMonthOptionButton;
    __weak IBOutlet UIButton *threeMonthOptionButton;
    __weak IBOutlet UIButton *oneMonthOptionButton;
    __weak IBOutlet UIButton *allOptionButton;
    
    __weak IBOutlet UILabel *allLbl;
    __weak IBOutlet UILabel *lastsixLbl;
    __weak IBOutlet UILabel *lastOneLbl;
    __weak IBOutlet UILabel *lastThreeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *promotionLbl;
    
    
    
    
    
}
@end
