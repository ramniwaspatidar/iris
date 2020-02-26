//
//  DashboardViewController.h
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+CoreDataClass.h"

@interface DashboardViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray * _personDetailArray;
    NSMutableDictionary * _policyInfoDictionary;
    NSMutableArray * _appointmentListArray;
    NSMutableArray * _medicineAlertListArray;
    NSMutableDictionary *_lastTreatmentDictionary;
    
    __weak IBOutlet UIImageView *_dashboardBannerImage;
    
    NSArray *_headerTitleArray;
    NSMutableArray *_imageUrlArray;
    User *_currentUser;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet UIImageView *notificationIconImageView;
    __weak IBOutlet UIView *_backgroundView;
    
    __weak IBOutlet UILabel *dashboardLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
}
@property (nonatomic,strong)NSDictionary *personDetailDictionary;


@end
