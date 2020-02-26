//
//  AddReimbursmentViewController.h
//  Iris
//
//  Created by apptology on 10/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIPRootViewController.h"
#import "User+CoreDataProperties.h"

@interface AddReimbursmentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,coropImageDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *_previousButton;
    __weak IBOutlet UIButton *_nextButton;
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet NSLayoutConstraint *buttonBottomViewCons;
    NSMutableArray *_page1InputArray;
    NSMutableArray *_page2InputArray;

    NSMutableArray *_page1TitleArray;
    NSMutableArray *_page2TitleArray;
    
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    float keybaordHeight;
    __weak IBOutlet NSLayoutConstraint *_scrollViewBottomCons;
    
    __weak IBOutlet UIDatePicker *_trackerDatePicker;
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    
    __weak IBOutlet UIButton *doneBtn;
    NSUInteger capturedMode;

    __weak IBOutlet UIStackView *nextStack;
    __weak IBOutlet UIStackView *previuosStack;
    NSMutableArray *_uploadFileArray;
    
    NSMutableArray *_countryInfoArray;
    NSMutableArray *_userNameArray;
    NSMutableArray *_towardArray;
    NSString *selectedPicker;
    
    NSString *selectedCountryId;
    __weak IBOutlet UIButton *topBtn;
    
    User *_currentUser;
    BOOL isSecondTime;
    
    
    __weak IBOutlet UILabel *addreimburLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
    
    
    
}

@property(nonatomic,strong)UIImagePickerController *imagePicker;

@end
