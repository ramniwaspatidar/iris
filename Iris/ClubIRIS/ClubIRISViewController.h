//
//  ClubIRISViewController.h
//  Iris
//
//  Created by Ramniwas Patidar on 03/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClbIRISCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClubIRISViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    __weak IBOutlet UIButton *menuButton;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIImageView *headerImageView;
    
    __weak IBOutlet UIView *bgView1;
    __weak IBOutlet UIView *bgView2;
    __weak IBOutlet UIView *bgView3;
    
    __weak IBOutlet UITextField *allTextField;
    __weak IBOutlet UITextField *countryTextFiled;
    __weak IBOutlet UITextField *searchTextField;
    __weak IBOutlet UILabel *voucherHeader;
    
    NSMutableArray *clubArray;
    NSMutableArray *storeClubArray;

    NSMutableArray *filterArray;
    NSMutableArray *filterSelectedArray;
    NSMutableArray *_countryInfoArray;
    NSMutableArray *_categoryArray;
    
    NSString *selectedCategoryId;
    NSString *selectedCountryId;


    
    __weak IBOutlet UIPickerView *_pickerView;
    NSString *currentPicker;
    __weak IBOutlet UILabel *_pickerTitleLabel;

    __weak IBOutlet NSLayoutConstraint *_pickerViewBottomCons;

    __weak IBOutlet UITableView *filterTable;
    


    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    float keybaordHeight;
    
    NSString *searchString;
    NSString *promocode;
    NSString *flatDiscount;
    NSString *discount;
    NSString *latestVoucher;
    
}
- (IBAction)allButtonAction:(id)sender;
- (IBAction)countryButton:(id)sender;
- (IBAction)filterButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
