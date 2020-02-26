//
//  LaunchScreenViewController.h
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *animatingLogoImageView;
@property (nonatomic, strong) UINavigationController *navController;

@end
