//
//  AppointmentReminderViewController.h
//  Iris
//
//  Created by apptology on 08/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentReminderViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_inputDataArray;
    __weak IBOutlet NSLayoutConstraint *deleteButtonWidthCons;
    __weak IBOutlet NSLayoutConstraint *deleteButtonTrailCons;
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;

    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    __weak IBOutlet UIDatePicker *_appointmentDatePicker;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *_saveButton;
    __weak IBOutlet UIButton *_deleteButton;
    NSString *_previousDateString;
    
    __weak IBOutlet UILabel *appointremLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UIButton *doneBtn;
    
}
@property (nonatomic,assign)BOOL canDeleteAppointment;
@property (nonatomic,strong)NSMutableDictionary *appointmentInfoDictionary;
@end
