//
//  AboutUsViewController.h
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
{

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UILabel *appVersionLabel;
    __weak IBOutlet UIImageView *notificationIconImageView;
    
    __weak IBOutlet UILabel *aboutLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *staticLbl;
    
}
@property (nonatomic,strong)NSDictionary *personDetailDictionary;
@end
