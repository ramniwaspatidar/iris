//
//  DependentProfileDetailViewController.m
//  Iris
//
//  Created by apptology on 12/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "DependentProfileDetailViewController.h"
#import "Dependent+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "Utility.h"
#import "Localization.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "RevealViewController.h"
#import "MainSideMenuViewController.h"
 #import "Localization.h"
@interface DependentProfileDetailViewController ()

@end

@implementation DependentProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
           dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependant"];
        genderLbl.text =  [Localization languageSelectedStringForKey:@"Gender:"];
        
        emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID:"];
        
        memberLbl.text =  [Localization languageSelectedStringForKey:@"Member ID:"];
        
        
        passportLbl.text =  [Localization languageSelectedStringForKey:@"Password Number:"];
           emailLbl.text =  [Localization languageSelectedStringForKey:@"Email:"];
         relationLbl.text =  [Localization languageSelectedStringForKey:@"Relation:"];
         nationality.text =  [Localization languageSelectedStringForKey:@"Nationality:"];
        switchToLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"];
         residentLbl.text =  [Localization languageSelectedStringForKey:@"Residence:"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependant"];
        genderLbl.text =  [Localization languageSelectedStringForKey:@"Gender:"];
        
        emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID:"];
        
        memberLbl.text =  [Localization languageSelectedStringForKey:@"Member ID:"];
        
        
        passportLbl.text =  [Localization languageSelectedStringForKey:@"Password Number:"];
        emailLbl.text =  [Localization languageSelectedStringForKey:@"Email:"];
        relationLbl.text =  [Localization languageSelectedStringForKey:@"Relation:"];
        nationality.text =  [Localization languageSelectedStringForKey:@"Nationality:"];
        switchToLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"];
        residentLbl.text =  [Localization languageSelectedStringForKey:@"Residence:"];
        _backButton.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Dependant"];
}
-(void)initialSetupView
{
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    if(self.showMenuIcon)
    {
        [self.backButton setImage:[UIImage imageNamed:@"revealmenu"] forState:UIControlStateNormal];
        
        RevealViewController *revealController = [self revealViewController];
        [revealController tapGestureRecognizer];
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
         [self.backButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            [self.backButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
    }
    else
    {
        [self.backButton addTarget:self
    action:@selector(backButtonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width/2;
    _userImageView.clipsToBounds = YES;
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        if([self.dependentUser.memberid isEqualToString:activeDependent])
            switchToDependentButton.selected = YES;
    }
    
    /*_inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dependentUser.fullname,@"fullname",self.dependentUser.email,@"email",self.dependentUser.nationality,@"nationality",self.dependentUser.gender,@"gender",self.dependentUser.memberid,@"memberid",self.dependentUser.residence,@"residence",self.dependentUser.profileimage,@"profileimage",self.dependentUser.passport,@"passport",self.dependentUser.emiratesid,@"emiratesid",self.dependentUser.relation,@"relation", nil];
    */
    
        [_userImageView setImage:[UIImage imageNamed:@"userplaceholde"]];

        if(self.dependentUser.profileimage)
        {
            NSString *imageString = self.dependentUser.profileimage;
            
            [_userImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"userplaceholde"]];
        }
    
        if(self.dependentUser.passport)
        {
            _passportNoLabel.text = self.dependentUser.passport;
        }
        if(self.dependentUser.fullname)
        {
            _nameLabel.text = self.dependentUser.fullname;
        }
        if(self.dependentUser.email && ![self.dependentUser.email isEqualToString:@""])
        {
            _emailLabel.text = self.dependentUser.email;
        }
        else
        {
            _emailLabel.text =  [Localization languageSelectedStringForKey:@"N/A"];
        }
        if(self.dependentUser.gender)
        {
            _genderLabel.text = ([self.dependentUser.gender isEqualToString:@"M"])? [Localization languageSelectedStringForKey:@"Male"]:[Localization languageSelectedStringForKey:@"Female"];
        }
        if(self.dependentUser.nationality)
        {
            _nationalityLabel.text = self.dependentUser.nationality;
        }
        if(self.dependentUser.residence && ![self.dependentUser.residence isEqualToString:@""])
        {
            _resigenceLabel.text = self.dependentUser.residence;
        }
        else
        {
            _resigenceLabel.text = [Localization languageSelectedStringForKey:@"N/A"];
        }
        if(self.dependentUser.emiratesid)
        {
            _emritidLabel.text = self.dependentUser.emiratesid;
        }
        if(self.dependentUser.memberid)
        {
            _memberidLabel.text = self.dependentUser.memberid;
        }
        if(self.dependentUser.relation)
        {
            _relationLabel.text = self.dependentUser.relation;
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Button Actions-

- (IBAction)switchToDependentButtonAction:(id)sender {
    
    NSMutableDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    if(!switchToDependentButton.selected)
    {
        switchToDependentButton.selected = YES;
        [userInfoDic setValue:self.dependentUser.memberid forKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        switchToDependentButton.selected = false;
        [userInfoDic removeObjectForKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_profile_notification"                                                                object:nil userInfo:nil];
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
