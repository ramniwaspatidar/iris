//
//  BloodSuagarChartViewController.h
//  Iris
//
//  Created by apptology on 16/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSuagarChartViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet NSLayoutConstraint *_chartWidthCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet UIButton *topBtn;
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
    __weak IBOutlet UILabel *_bloodSugarLabel;
    
    
    __weak IBOutlet UILabel *bloodLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *daysLbl;
    
    

}
@property(nonatomic,strong)NSMutableArray *bloodsugarArray;

@end
