//
//  SplashViewController.m
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "SplashViewController.h"
#import "UIImage+animatedGIF.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Splash"]];
   
    NSString *assetLocalPath = [[NSBundle mainBundle] pathForResource:@"logo_aniamtion" ofType:@"gif"];
    NSURL *assetURL = [[NSURL alloc] initFileURLWithPath:assetLocalPath];
    self.animatedLogoImageView.image = [UIImage animatedImageWithAnimatedGIFURL:assetURL];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:10.0];//12
    
    
    
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
