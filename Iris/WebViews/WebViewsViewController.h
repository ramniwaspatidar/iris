//
//  WebViewsViewController.h
//  Iris
//
//  Created by apptology on 1/30/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+CustomLabel.h"
#import "RevealViewController.h"


@interface WebViewsViewController : UIViewController{
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIImageView *notificationIconImageView;
    
    __weak IBOutlet UILabel *feedbackLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
}
@property (nonatomic,strong)NSDictionary *personDetailDictionary;
@property (strong, nonatomic) IBOutlet UIWebView *contentWebView;



@end
