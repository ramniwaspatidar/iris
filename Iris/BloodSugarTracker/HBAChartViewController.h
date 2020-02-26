//
//  HBAChartViewController.h
//  Iris
//
//  Created by apptology on 17/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBAChartViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *_chartWidthCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    NSString *selectedMonth;
    NSString *selectedYear;
    __weak IBOutlet UIButton *_yearButton;
    __weak IBOutlet UITableView *_yearTableView;
    NSArray* _months;
    __weak IBOutlet UIView *monthView;
    __weak IBOutlet UIView *yearView;
    __weak IBOutlet UIButton *topBtn;
    NSMutableArray *_yearsArray;
    __weak IBOutlet UILabel *hb1acLabel;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    __weak IBOutlet UILabel *graphLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *daysLbl;
    
    
    
}
@property(nonatomic,strong)NSMutableArray *bloodsugarArray;
@end
