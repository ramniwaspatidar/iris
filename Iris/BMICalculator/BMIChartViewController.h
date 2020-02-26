//
//  BMIChartViewController.h
//  Iris
//
//  Created by apptology on 10/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIChartViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *_bmiLabel;

    __weak IBOutlet NSLayoutConstraint *_chartWidthCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    
    __weak IBOutlet UIButton *topBtn;
    NSString *selectedYear;
    __weak IBOutlet UIButton *_yearButton;
    __weak IBOutlet UITableView *_yearTableView;
    NSArray* _months;
    __weak IBOutlet UIView *yearView;
    NSMutableArray *_yearsArray;
    
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *bmiLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *avgLbl;
    __weak IBOutlet UILabel *bmiNLbl;
    
    
    
}
@property(nonatomic,strong)NSMutableArray *statesArray;
@end
