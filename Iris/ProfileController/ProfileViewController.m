//
//  ProfileViewController.m
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ProfileViewController.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "RevealViewController.h"
#import "DbManager.h"
#import "Dependent+CoreDataClass.h"
#import "Constant.h"
#import "ProfileDetailViewController.h"
#import "NSData+Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DependentProfileDetailViewController.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

#define kMargin 10.0

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [self initialSetupView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Profile"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setUserProfileData];

}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
          profileLbl.text =  [Localization languageSelectedStringForKey:@"Profile"];
        dependantsLbl.text =  [Localization languageSelectedStringForKey:@"Dependants"];
        noDependentLabel.text =  [Localization languageSelectedStringForKey:@"No Dependant"];
        [editBtn setTitle:[Localization languageSelectedStringForKey:@"EDIT"] forState:UIControlStateNormal];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
         noDependentLabel.text =  [Localization languageSelectedStringForKey:@"No Dependant"];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        profileLbl.text =  [Localization languageSelectedStringForKey:@"Profile"];
        dependantsLbl.text =  [Localization languageSelectedStringForKey:@"Dependants"];
        [editBtn setTitle:[Localization languageSelectedStringForKey:@"EDIT"] forState:UIControlStateNormal];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width/2;
    _userImageView.clipsToBounds = YES;
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

-(void)setUserProfileData
{
    
    for (UIView *v in _scrollView.subviews) {
        if (![v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSString *emiratesId = [userInfoDic valueForKey:@"emiratesid"];
    NSString *defaultPolicy = @"True";
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",emiratesId,defaultPolicy];
    
    NSArray *userArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO];
    
    currentUser = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO] firstObject];
    
    NSLog(@"user default : %@",currentUser.defaultpolicyholder);
    NSLog(@"Emrit id: %@",currentUser.emiratesid);
    NSLog(@"Emrit id: %@",currentUser.profileimage);
    
    
    if(currentUser.profileimage)
    {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.profileimage] placeholderImage:[UIImage imageNamed:@"userplaceholde"] options:SDWebImageHighPriority];
    }
    if(currentUser.fullname)
    {
        _userName.text = currentUser.fullname;
    }
    if(currentUser.email)
    {
        _userEmail.text = currentUser.email;
    }
    if(currentUser.mobileno)
    {
        _userPhoneNumber.text = currentUser.mobileno;
    }
    
    predicate =
    [NSPredicate predicateWithFormat:@"SELF.principalmemberid == %@",currentUser.memberid];
    
    NSArray *dependents = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"Dependent" withPredicate:predicate sortKey:nil ascending:NO];
    float imageWidth = (_scrollView.frame.size.width - (kMargin*3))/4;
    float xPoint = 0;
    if(dependents.count > 0)
    {
        noDependentLabel.hidden = YES;
        for(int i = 0; i < dependents.count; i++)
        {
            UIButton *dependentButtonView = [[UIButton alloc] initWithFrame:CGRectMake(xPoint, 0, imageWidth, imageWidth)];
            UILabel *dependentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPoint, dependentButtonView.frame.size.height +5, imageWidth, 21)];
            dependentNameLabel.numberOfLines = 0;
            dependentNameLabel.textAlignment = NSTextAlignmentCenter;
            dependentNameLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
            
            Dependent *dependent = [dependents objectAtIndex:i];
            dependentNameLabel.text =  dependent.fullname;
            NSLog(@"%@",dependent.profileimage);
            UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, 0, imageWidth, imageWidth)];
           // profileImageView.image = [UIImage imageNamed:@"userplaceholde"];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            [profileImageView addSubview:indicator];
            
            if(dependent.profileimage)
            {
                dispatch_async(dispatch_get_global_queue(0,0), ^{
                    NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:dependent.profileimage]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        profileImageView.image = [UIImage imageWithData: data];
                        [indicator stopAnimating];
                        [indicator removeFromSuperview];

                    });
                });
            }
            
            dependentButtonView.tag = i;
            [dependentButtonView addTarget:self action:@selector(dependentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:profileImageView];
            [_scrollView addSubview:dependentButtonView];
            [_scrollView addSubview:dependentNameLabel];
            
            xPoint = xPoint + imageWidth + kMargin;
            _scrollView.contentSize = CGSizeMake(xPoint, imageWidth);
        }
    }
    else
    {
        noDependentLabel.hidden = NO;
    }
    
    
}

#pragma mark- UIButton Actions-


-(void)dependentButtonClicked:(id)sender
{
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"SELF.principalmemberid == %@",currentUser.memberid];
    
    NSArray *dependents = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"Dependent" withPredicate:predicate sortKey:nil ascending:NO];
    
    UIButton *button = sender;
    Dependent *dependent = [dependents objectAtIndex:(int)button.tag];
    [self performSegueWithIdentifier:kDependentProfileDetailIdentifier sender:dependent];
}

- (IBAction)editProfileButtonAction:(id)sender {
    [self performSegueWithIdentifier:kProfileDetailIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kDependentProfileDetailIdentifier])
    {
        DependentProfileDetailViewController *dependentDetailViewController = segue.destinationViewController;
            dependentDetailViewController.dependentUser = sender;
    }
    else if([segue.identifier isEqualToString:kProfileDetailIdentifier])
    {
        ProfileDetailViewController *profileDetailViewController = segue.destinationViewController;
        profileDetailViewController.currentUser = currentUser;
    }
        //promotionViewController.promotionDetail = sender;
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

