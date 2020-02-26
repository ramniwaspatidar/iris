//
//  LaunchScreenViewController.m
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LoginViewController.h"
#import "Constant.h"
#import "AppDelegate.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add the image to the forefront...
    //you can download UIImage+animatedGIF here https://github.com/mayoff/uiimage-from-animated-gif

    
    
    //set an anchor point on the image view so it opens from the left
    self.animatingLogoImageView.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //reset the image view frame
    
    //animate the open
    [UIView animateWithDuration:0.0/*hiding duration*/
                          delay:7.0/*how much time you want to show the splash*/
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.animatingLogoImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 1, 0);
                     } completion:^(BOOL finished){
                         
                         //remove that imageview from the view
                         [self.animatingLogoImageView removeFromSuperview];
                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                         LoginViewController * mainController = [storyboard instantiateViewControllerWithIdentifier:kLoginScreenStoryBoardName];
                         self.navController = [[UINavigationController alloc]initWithRootViewController:mainController];
                         [self.navController setNavigationBarHidden:YES animated:NO];
                         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                         
                         [appDelegate.window setRootViewController:self.navController];
                     }];
    
    // Do any additional setup after loading the view.
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
