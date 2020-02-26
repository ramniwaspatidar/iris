//
//  BloodPressureTrackerViewController.h
//  Iris
//
//  Created by apptology on 22/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureTrackerViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    IBOutlet UIPickerView *mainPickerView;
    __weak IBOutlet UIButton *_saveButton;
    __weak IBOutlet UIButton *_viewStatusButton;
    __weak IBOutlet UIButton *_sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIDatePicker *_trackerDatePicker;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    __weak IBOutlet UIImageView *notificationIconImageView;
    
    
    __weak IBOutlet UILabel *bloodPLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UIButton *doneBtn;
    
}
@end
