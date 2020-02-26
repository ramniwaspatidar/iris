//
//  BMICalculatorViewController.h
//  Iris
//
//  Created by apptology on 20/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMICalculatorViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    __weak IBOutlet UITextField *bmiResultTextField;
    __weak IBOutlet UIButton *_saveButton;
    __weak IBOutlet UIButton *_calculateButton;
    NSIndexPath *activeCellIndexPath;
    __weak IBOutlet UIButton *viewStatsButton;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    __weak IBOutlet UIDatePicker *_trackerDatePicker;
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    __weak IBOutlet UIImageView *notificationIconImageView;
    
    __weak IBOutlet UILabel *bmiLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UIButton *doneBtn;
    
    

}
@end
