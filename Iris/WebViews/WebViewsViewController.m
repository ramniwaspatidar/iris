//
//  WebViewsViewController.m
//  Iris
//
//  Created by apptology on 1/30/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "WebViewsViewController.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
 #import "Localization.h"
@interface WebViewsViewController ()

@end

@implementation WebViewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];


    // Do any additional setup after loading the view.
}

-(void)initialSetupView
{
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         feedbackLbl.text =  [Localization languageSelectedStringForKey:@"Feedback"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        feedbackLbl.text =  [Localization languageSelectedStringForKey:@"Feedback"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ezyclaim.com/MobileApp/MobileFeedback.html"]];
    [_contentWebView loadRequest:requestObj];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    // Do any additional setup after loading the view.
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}



@end
