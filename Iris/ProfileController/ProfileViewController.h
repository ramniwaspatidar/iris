//
//  ProfileViewController.h
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataProperties.h"

@interface ProfileViewController : UIViewController
{
    __weak IBOutlet UILabel *noDependentLabel;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIImageView *_userImageView;
    __weak IBOutlet UILabel *_userName;
    __weak IBOutlet UILabel *_userEmail;
    __weak IBOutlet UILabel *_userPhoneNumber;
    __weak IBOutlet UIScrollView *_scrollView;
    User *currentUser;
    
    
    __weak IBOutlet UILabel *profileLbl;
    __weak IBOutlet UIButton *editBtn;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *dependantsLbl;
    
    
}
@end

