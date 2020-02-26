//
//  TabbarViewController.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "TabbarViewController.h"
#import "SearchViewController.h"
#import "Localization.h"
@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //self.tabBar.tintColor = [UIColor colorWithRed:156.0/255.0 green:199.0/255.0 blue:227.0/255.0 alpha:1.0];
    if (@available(iOS 10.0, *)) {
        self.tabBar.unselectedItemTintColor = [UIColor colorWithRed:156.0/255.0 green:199.0/255.0 blue:227.0/255.0 alpha:1.0];
    } else {
        // Fallback on earlier versions
    }
    [[self.tabBarController.tabBar.items objectAtIndex:0] setTitle:[Localization languageSelectedStringForKey:@"Dashboard"]];
    [[self.tabBarController.tabBar.items objectAtIndex:1] setTitle:[Localization languageSelectedStringForKey:@"Appointment"]];
    [[self.tabBarController.tabBar.items objectAtIndex:2] setTitle:[Localization languageSelectedStringForKey:@"Search"]];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{

    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSLog(@"controller title: %@", viewController.title);
    tabBarController.tabBar.tintColor = [UIColor whiteColor];
    NSLog(@"controller title: %lu", (unsigned long)tabBarController.selectedIndex);

    
    if(viewController.childViewControllers.count > 0)
    {
        for(UIViewController *child in viewController.childViewControllers)
        {
            [self hideContentController:child];
        }
        [viewController viewDidAppear:YES];
    }
    else if([NSStringFromClass([viewController class]) isEqualToString:@"SearchViewController"])
    {
        [(SearchViewController*)viewController removeFilter];
    }
    if (viewController == tabBarController.moreNavigationController)
    {
        tabBarController.moreNavigationController.delegate = self;
    }
}

- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
 
 private func remove(asChildViewController viewController: UIViewController) {
 // Notify Child View Controller
 viewController.willMove(toParentViewController: nil)
 
 // Remove Child View From Superview
 viewController.view.removeFromSuperview()
 
 // Notify Child View Controller
 viewController.removeFromParentViewController()
 }
 
 */

@end
