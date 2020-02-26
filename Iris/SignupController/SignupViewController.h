//
//  SignupViewController.h
//  Iris
//
//  Created by apptology on 29/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIPRootViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface SignupViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,coropImageDelegate,UITextFieldDelegate>
{
    float keyboardHeight;
    NSString *_tokenString;
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    NSUInteger capturedMode;
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *topBtn;
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    BOOL isInfoBoxOpen;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    UIView *customAccessoryView;
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *signupLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
}
//@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
//@property (weak, nonatomic) IBOutlet UIButton *infoButton;
//@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
//@property (weak, nonatomic) IBOutlet UITextField *emiratesIdTextField;
//@property (weak, nonatomic) IBOutlet UITextField *passportNumberTextField;
//@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *infoBoxLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoBoxBgImageView;
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong) NSString *encodedImageString;
@property(nonatomic,strong) UIImage *capturedImage;

@end

