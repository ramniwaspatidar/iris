//
//  ViewController.h
//  Iris
//
//  Created by apptology on 27/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    __weak IBOutlet UITextField *_emailTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UIScrollView *_bottomScrollView;
    __weak IBOutlet UIPageControl *_pageController;
    NSArray *_imageUrlArray;
    
    __weak IBOutlet UIButton *_loginButton;
    
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet NSLayoutConstraint *_logoTopSpaceCons;
    __weak IBOutlet NSLayoutConstraint *websiteViewBottomCons;
    
    __weak IBOutlet UILabel *userNameLbl;
    __weak IBOutlet UILabel *passwordLbl;
    __weak IBOutlet UIButton *forgotpwdLbl;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UILabel *dontLbl;
    __weak IBOutlet UIButton *signUpBtn;
    __weak IBOutlet UILabel *hrlpLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
}
//@property(nonatomic,weak) IBOutlet UITextField *emailTextField;
//@property(nonatomic,weak) IBOutlet UITextField *passwordTextField;
- (IBAction)loginButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;
-(void)callLoginAPI:(NSString *)email andPassword:(NSString*)password;
@end

