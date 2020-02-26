//
//  VerifyViewController.h
//  Iris
//
//  Created by apptology on 29/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyViewController : UIViewController<UITextFieldDelegate>
{
    NSTimer *timer;
    int remainingTime;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *_verifyButton;

    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *verfiyLbl;
    __weak IBOutlet UILabel *vcodeLbl;
    __weak IBOutlet UIButton *resendBtn;
    __weak IBOutlet UIButton *verifyBtn;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
}
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UILabel *verifyTopMessageLabel;
@property(nonatomic,strong) NSString *verifyMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property(nonatomic,strong)NSDictionary *requestDictionary;

@end
