//
//  AboutUsViewController.m
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "AboutUsViewController.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    // Do any additional setup after loading the view.
    
    appVersionLabel.text =[NSString stringWithFormat:@"App Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];//[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"About Us"]];
}

#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        aboutLbl.text = [Localization languageSelectedStringForKey:@"About Us"];
        staticLbl.text =  [Localization languageSelectedStringForKey:@"The Iris Health app is exclusively designed for our members to allow them easy access to their policy details, insurance plan benefits, medical claim history and status of reimbursements. It is designed to simplify the process of following one's own medical insurance policy. Iris Health members will no longer need to spend time on gathering information related to claims and policies.The app is loaded with resourceful features to help you track your medical history, set reminders for future appointments, medication alerts and access previous treatment details. To further enhance user experience, the app will also help find clinics under eligible policy networks, doctors as per their specialties and give members access to promotions on medical procedures. These services have been provided by IRIS Health Services, a leading third party administrator. The unparalleled technical efficiency has further benefited our clients allowing them to entrust us with the administration of their medical insurance policy. IRIS prides itself on the enthusiastic team who is focused on letting our clients know that You Matter"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        aboutLbl.text = [Localization languageSelectedStringForKey:@"About Us"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
             staticLbl.text =  [Localization languageSelectedStringForKey:@"The Iris Health app is exclusively designed for our members to allow them easy access to their policy details, insurance plan benefits, medical claim history and status of reimbursements. It is designed to simplify the process of following one's own medical insurance policy. Iris Health members will no longer need to spend time on gathering information related to claims and policies.The app is loaded with resourceful features to help you track your medical history, set reminders for future appointments, medication alerts and access previous treatment details. To further enhance user experience, the app will also help find clinics under eligible policy networks, doctors as per their specialties and give members access to promotions on medical procedures. These services have been provided by IRIS Health Services, a leading third party administrator. The unparalleled technical efficiency has further benefited our clients allowing them to entrust us with the administration of their medical insurance policy. IRIS prides itself on the enthusiastic team who is focused on letting our clients know that You Matter"];
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
