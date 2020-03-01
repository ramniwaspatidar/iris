

//
//  FilterViewController.h
//  Iris
//
//  Created by apptology on 05/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController<UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_doctorTableView;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIPickerView *_pickerView;
    NSString *currentPicker;
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    NSMutableArray *_doctorNameArray;
    NSMutableArray *_doctorSearchArray;
    NSMutableArray *_proximityArray;
    NSMutableArray *_facilityArray;
    __weak IBOutlet UIButton *topBtn;
    NSMutableArray *_specialityArray;
    NSMutableArray *_languageArray;
    NSMutableArray *_genderArray;


    NSIndexPath *_activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    BOOL _isSearching;
    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;
    __weak IBOutlet NSLayoutConstraint *_searchTableBottomCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UILabel *_pickerTitleLabel;
    __weak IBOutlet UIButton *_submitButton;
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *filterLbl;
    __weak IBOutlet UIButton *doneBtn;
    
}
@property(nonatomic,strong)NSString *tokenString;
@property(nonatomic,weak)id customDelegate;

@end
