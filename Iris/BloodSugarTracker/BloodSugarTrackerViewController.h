//
//  BloodSugarTrackerViewController.h
//  Iris
//
//  Created by apptology on 23/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarTrackerViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *_saveButton;
    __weak IBOutlet UIButton *_viewStatusButton;
    __weak IBOutlet UIButton *_sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIDatePicker *_trackerDatePicker;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet UIImageView *notificationIconImageView;

    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    __weak IBOutlet NSLayoutConstraint *selectedBarLeadingCons;
    
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    NSMutableArray *_inputDisplayDataArray;
    NSMutableArray *_measureArray;
    //NSMutableArray *_measureInputArray;
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *bloddsLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UIButton *doneBtn;
    
    
    
}
@end
