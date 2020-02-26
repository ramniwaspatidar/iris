//
//  PolicyViewController.h
//  Iris
//
//  Created by apptology on 19/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolicyViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIImageView *notificationIconImageView;

    NSMutableArray *_policyArray;
    
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *policyLbl;
    
    
    
}
@property(nonatomic,strong)NSMutableDictionary *personDetailDictionary;
@end
