//
//  ReimbursmentViewController.h
//  Iris
//
//  Created by apptology on 17/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReimbursmentViewController : UIViewController
{
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UITableView *_pendingTableView;

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    NSMutableArray *_reimbursmentApprovedArray;
    NSMutableArray *_reimbursmentPendingArray;

    
    
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *reimburLbl;
    __weak IBOutlet UIButton *approveBtn;
    __weak IBOutlet UIButton *pendingBtn;
    
    
    
    
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    
    __weak IBOutlet NSLayoutConstraint *bottomBarLeadingCons;
    __weak IBOutlet NSLayoutConstraint *tableContainerViewWidthCons;
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIImageView *notificationIconImageView;
    BOOL shouldLoadReimbursemenent;
}
@end
