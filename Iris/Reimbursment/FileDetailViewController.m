//
//  FileDetailViewController.m
//  Iris
//
//  Created by apptology on 18/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "FileDetailViewController.h"
#import "NSData+Base64.h"
#import "Utility.h"
#import "Localization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
@interface FileDetailViewController ()

@end

@implementation FileDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        dependLbl.text =  [Localization languageSelectedStringForKey:@"File Details"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        dependLbl.text =  [Localization languageSelectedStringForKey:@"File Details"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    if([self.fileInfoDic valueForKey:@"filecontent_base64"])
    {
        [self.activityIndicator startAnimating];
        NSURL *url = [NSURL URLWithString:[self.fileInfoDic valueForKey:@"filecontent_base64"]];
        
        
        [_imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (error) {
                _imageView.image = [UIImage imageNamed:@"fileplaceholder.png"];
            }
            [self.activityIndicator stopAnimating];
        }];
      
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    
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


- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
