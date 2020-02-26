//
//  CompleteProfileViewController.h
//  Iris
//
//  Created by apptology on 30/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *_profileOptionsArray;
    float _keyboardHeight;
    NSMutableDictionary *_inputDictionary;
    __weak IBOutlet UIButton *topBtn;
    
    __weak IBOutlet UITableView *_mainTableView;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    NSIndexPath *activeCellIndexPath;
    NSMutableArray *genderArray;
    NSMutableArray *countryArray;
    NSMutableArray *policyArray;
    NSString *currentPicker;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet NSLayoutConstraint *_rangeViewBottomConstraint;
    __weak IBOutlet UIButton *_submitButton;
    
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *doneBtn;
    
    __weak IBOutlet UILabel *completPLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
    
}
@property(nonatomic,strong)NSMutableDictionary *responseDictionary;
@property(nonatomic,strong)NSMutableArray *responseArray;


@end
