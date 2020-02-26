//
//  LipidChartViewController.h
//  Iris
//
//  Created by apptology on 15/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LipidChartViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
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
    
    __weak IBOutlet UIView *mgView;
    __weak IBOutlet UIButton *_mgButton;
    __weak IBOutlet UITableView *_mgTableView;
    NSString *selectedUnit;
    __weak IBOutlet UILabel *_lipidUnitLabel;
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *lipidLbl;
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *monthsLbl;
    __weak IBOutlet UILabel *ldlLbl;
    __weak IBOutlet UILabel *cholestrolLbl;
    __weak IBOutlet UILabel *hdlLbl;
    __weak IBOutlet UILabel *trigLbl;
    
    
    
    
    

}
@property(nonatomic,strong)NSMutableArray *lipidArray;
@end

