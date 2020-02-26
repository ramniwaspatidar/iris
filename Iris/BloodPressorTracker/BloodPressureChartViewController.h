//
//  BloodPressureChartViewController.h
//  Iris
//
//  Created by apptology on 15/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureChartViewController : UIViewController
{
    __weak IBOutlet UILabel *_bloodPressureLabel;

    __weak IBOutlet NSLayoutConstraint *_chartWidthCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    
    __weak IBOutlet UILabel *pulseLbl;
    __weak IBOutlet UILabel *systolicLbl;
    __weak IBOutlet UILabel *diastolioLbl;
    __weak IBOutlet UILabel *daysLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *bloodpreserLbl;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    NSString *selectedMonth;
    NSString *selectedYear;
    __weak IBOutlet UIButton *_yearButton;
    __weak IBOutlet UIButton *_monthButton;
    __weak IBOutlet UITableView *_yearTableView;
    __weak IBOutlet UITableView *_monthTableView;
    NSArray* _months;
    __weak IBOutlet UIView *monthView;
    __weak IBOutlet UIView *yearView;
    NSMutableArray *_yearsArray;
    
}
@property(nonatomic,strong)NSMutableArray *bloodptrssureArray;
@end

