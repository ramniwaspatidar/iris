//
//  VerifyViewController.m
//  Iris
//
//  Created by apptology on 29/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "VerifyViewController.h"
#import "ConnectionManager.h"
#import "Constant.h"
#import "Utility.h"
#import "CompleteProfileViewController.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController
#define MAX_LENGTH 8

- (void)viewDidLoad {
    [super viewDidLoad];
    self.verifyTopMessageLabel.text = self.verifyMessage;
    [_verifyButton setButtonCornerRadious];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    [self startTimerCoundown];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
         verfiyLbl.text =  [Localization languageSelectedStringForKey:@"Verify Your Phone Number"];
          vcodeLbl.text =  [Localization languageSelectedStringForKey:@"Verification Code"];
        
        [resendBtn setTitle:[Localization languageSelectedStringForKey:@"Resend Code"] forState:UIControlStateNormal];
 [verifyBtn setTitle:[Localization languageSelectedStringForKey:@"Verify"] forState:UIControlStateNormal];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        verfiyLbl.text =  [Localization languageSelectedStringForKey:@"Verify Your Phone Number"];
        vcodeLbl.text =  [Localization languageSelectedStringForKey:@"Verification Code"];
        
        [resendBtn setTitle:[Localization languageSelectedStringForKey:@"Resend Code"] forState:UIControlStateNormal];
        [verifyBtn setTitle:[Localization languageSelectedStringForKey:@"Verify"] forState:UIControlStateNormal]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    // Do any additional setup after loading the view.
}

-(void)startTimerCoundown
{
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    _verifyButton.enabled = YES;
    _verifyButton.alpha = 1.0;
    remainingTime = 150;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
}

-(void)stopTimer
{
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    remainingTime = 0;
    _verifyTextField.text = @"";
    _verifyButton.enabled = NO;
    _verifyTextField.alpha = 0.7;
    self.timeLabel.text = [NSString stringWithFormat:@"%d sec",remainingTime];}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:@"Verification"];
}

-(void)updateTime:(id)sender
{
    remainingTime--;
    if(remainingTime >= 0)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%d sec",remainingTime];
    }
    else
    {
        if(timer && [timer isValid])
        {
            [timer invalidate];
            timer = nil;
        }
        _verifyButton.alpha = 0.8;
        _verifyButton.enabled = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verifyButtonAction:(id)sender {
    
    if([Utility trimString:_verifyTextField.text].length > 0)
    {
        [self callVerifyOTPAPI];
    }
}

- (IBAction)resendCodeButtonAction:(id)sender {
    [self callSignupAPI];
}


- (IBAction)backButtonAction:(id)sender {
    
    if(timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callSignupAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[self.requestDictionary valueForKey:@"emiratesid"] forKey:@"emiratesid"];
    [dictionary setValue:[self.requestDictionary valueForKey:@"passportno"] forKey:@"passportno"];
    [dictionary setValue:[self.requestDictionary valueForKey:@"mobileno"] forKey:@"mobileno"];
    [dictionary setValue:@"m.ali@iris.healthcare" forKey:@"otpemail"];//m.ali@iris.healthcare
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"RegisterUser"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJson:url json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [self startTimerCoundown];
                     
                     self.verifyTextField.text = @"";
                     [self.requestDictionary setValue:[responseDictionary valueForKey:@"token"] forKey:@"token"];
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:[Localization languageSelectedStringForKey:@"Verification code sent successfully."] delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                     [alert show];
                     return;
                     
                 }
                 else
                 {
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:serverMsg delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil];
                     [alert show];
                     return;
                 }
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}


-(void)callVerifyOTPAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:_verifyTextField.text forKey:@"otp"];
    [dictionary setValue:[self.requestDictionary valueForKey:@"mobileno"] forKey:@"mobileno"];
    //[dictionary setValue:self.tokenString forKey:@"token"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"RegisterOTP"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.requestDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [self stopTimer];
                     [self performSegueWithIdentifier:kCompleteProfileIdentifier sender:[responseDictionary valueForKey:@"policyholder"]];
                     
                     return;
                     
                 }
                 else
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                     }];
                 }
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}



#pragma mark- UITextField Delegate methods

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.verificationCodeLabel.hidden = YES;
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == _verifyTextField)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kCompleteProfileIdentifier])
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        [dictionary addEntriesFromDictionary:[sender firstObject]];
        [dictionary setValue:[self.requestDictionary valueForKey:@"token"] forKey:@"token"];
        [dictionary setValue:[self.requestDictionary valueForKey:@"mobileno"] forKey:@"mobileno"];
        [dictionary setValue:[self.requestDictionary valueForKey:@"profileimage"] forKey:@"profileimage"];


        CompleteProfileViewController *completeViewController = segue.destinationViewController;
        completeViewController.responseDictionary = dictionary;
        completeViewController.responseArray = sender;
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
    
    NSUInteger newLength = [textField.text length] + [string length];
    
    if(newLength > MAX_LENGTH){
        return NO;
    }
        
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)verifyTextField:(id)sender {
}
@end
