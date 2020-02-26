//
//  AppointmentViewController.h
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppointmentViewController : UIViewController<CLLocationManagerDelegate>
{
    
    __weak IBOutlet UIButton *_sideMenuBtnOutlet;
    NSMutableArray *_allAppointmentsArray;
    NSMutableArray *_selectedDateAppointmentArray;
    BOOL _isSecondTime;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *_addAppointmentButton;
    __weak IBOutlet UIImageView *notificationIconImageView;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    __weak IBOutlet UILabel *myappointLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UIButton *addApointBtn;
    
    
    
}

@property(nonatomic,strong)CLLocationManager *locationManager;

@end
