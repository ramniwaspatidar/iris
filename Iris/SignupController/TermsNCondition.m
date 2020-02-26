//
//  TermsNCondition.m
//  Iris
//
//  Created by apptology on 1/30/18.
//  Copyright © 2018 apptology. All rights reserved.
//
#import "Localization.h"

#import "TermsNCondition.h"
#import "UILabel+CustomLabel.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "MainSideMenuViewController.h"
@interface TermsNCondition ()

@end

@implementation TermsNCondition

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"terms-conditions" ofType:@"html"]];
    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ezyclaim.com/MobileApp/MobileTermsandConditions.html"]]];
    // Do any additional setup after loading the view.
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        termLbl.text =  [Localization languageSelectedStringForKey:@"Term & Conditions"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        termLbl.text =  [Localization languageSelectedStringForKey:@"Term & Conditions"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Terms & Conditions"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:notificationVC animated:YES];
}


@end
