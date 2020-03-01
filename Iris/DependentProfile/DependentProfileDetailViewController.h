//
//  DependentProfileDetailViewController.h
//  Iris
//
//  Created by apptology on 12/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataProperties.h"
#import "HIPRootViewController.h"
#import "PolicyDetails+CoreDataProperties.h"

@interface DependentProfileDetailViewController : UIViewController
{
    __weak IBOutlet UIImageView *_userImageView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *switchToDependentButton;
    
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_emailLabel;
    __weak IBOutlet UILabel *_emritidLabel;
    __weak IBOutlet UILabel *_memberidLabel;
    __weak IBOutlet UILabel *_passportNoLabel;
    __weak IBOutlet UILabel *_resigenceLabel;
    __weak IBOutlet UILabel *_nationalityLabel;
    __weak IBOutlet UILabel *_genderLabel;
    __weak IBOutlet UILabel *_relationLabel;
    //NSMutableDictionary *_inputDictionary;

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    
    __weak IBOutlet UILabel *dependLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *genderLbl;
    __weak IBOutlet UILabel *emiratesLbl;
    __weak IBOutlet UILabel *memberLbl;
    __weak IBOutlet UILabel *passportLbl;
    __weak IBOutlet UILabel *emailLbl;
    __weak IBOutlet UILabel *relationLbl;
    
    __weak IBOutlet UILabel *residentLbl;
    __weak IBOutlet UILabel *nationality;
    __weak IBOutlet UILabel *switchToLbl;
    
       NSUInteger capturedMode;
    
    
    
    
    
}
@property(nonatomic,assign)BOOL showMenuIcon;
@property(nonatomic,weak) IBOutlet UIButton *backButton;
@property(nonatomic,strong) UIImagePickerController *imagePicker;

@property(nonatomic,strong)Dependent *dependentUser;
@property(nonatomic,strong)User *userPolicyDetails;


@end
