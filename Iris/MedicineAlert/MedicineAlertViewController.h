//
//  MedicineAlertViewController.h
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicineAlertViewController : UIViewController<UITextFieldDelegate>
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
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    __weak IBOutlet UIDatePicker *_trackerDatePicker;
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    NSMutableArray *_measureArray;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *previousButton;
    __weak IBOutlet UIButton *nextButton;
    __weak IBOutlet UIImageView *notificationIconImageView;
    
    __weak IBOutlet UILabel *medicinLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
    
    
}
@property (nonatomic,strong)NSDictionary *personDetailDictionary;

@end
