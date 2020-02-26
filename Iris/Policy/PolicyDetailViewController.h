//
//  PolicyDetailViewController.h
//  Iris
//
//  Created by apptology on 19/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataProperties.h"
#import "PolicyDetails+CoreDataProperties.h"

@interface PolicyDetailViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *_policyNumberLabel;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UIButton *defaultPolicyButton;
    
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *defaultLbl;
    
    
    
    
}
@property(nonatomic,strong)User *userPolicyDetails;

@end
