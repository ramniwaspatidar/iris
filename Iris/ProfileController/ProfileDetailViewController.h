//
//  ProfileDetailViewController.h
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataProperties.h"

@interface ProfileDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_profileOptionsArray;
    float _keyboardHeight;
    NSMutableDictionary *_inputDictionary;
    __weak IBOutlet UITableView *_mainTableView;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    NSIndexPath *activeCellIndexPath;
    NSMutableArray *genderArray;
    NSMutableArray *countryArray;
    __weak IBOutlet UIButton *topBtn;
    NSString *currentPicker;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet NSLayoutConstraint *_rangeViewBottomConstraint;
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet NSLayoutConstraint *_bottomViewHeightCons;
    __weak IBOutlet UIButton *switchToDependentButton;
    NSUInteger capturedMode;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    __weak IBOutlet UILabel *editPLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *switchLbl;
    
    
    
    
    
    
    
    
}
@property(nonatomic,strong)NSDictionary *inputDictionary;
@property(nonatomic,strong)User *currentUser;
@property(nonatomic,strong)Dependent *dependentUser;
@property (assign) BOOL isDependentProfile;

@property(nonatomic,strong) UIImagePickerController *imagePicker;


@end
