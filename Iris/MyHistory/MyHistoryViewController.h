//
//  MyHistoryViewController.h
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableDictionary *_historyInfoDictionary;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIImageView *notificationIconImageView;

    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *claimhistoryLbl;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
}

@property (nonatomic,strong)NSDictionary *personDetailDictionary;

@end
