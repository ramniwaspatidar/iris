//
//  ProviderNetworkViewController.h
//  Iris
//
//  Created by apptology on 08/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ProviderNetworkViewController : UIViewController<CLLocationManagerDelegate, UISearchBarDelegate>
{
    NSMutableArray *_ProviderNetworkArray;
    NSMutableArray *_ProviderNetworkMasterArray;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

    __weak IBOutlet UISearchBar *providerSearchBar;
    __weak IBOutlet UIView *filterPopupContainerView;
    __weak IBOutlet UIView *filterPopupBackgroundView;

    __weak IBOutlet NSLayoutConstraint *topViewCons;
    IBOutletCollection(UIButton) NSArray *filterCheckButtons;
    __weak IBOutlet UILabel *provideLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UILabel *clinicLbl;
    __weak IBOutlet UILabel *hospitalLbl;
    __weak IBOutlet UILabel *diagonisticLbl;
    __weak IBOutlet UILabel *pharmacyLbl;
    
    __weak IBOutlet UIButton *applyBtn;
}


- (IBAction)filterButtonClicked:(UIButton *)sender;
- (IBAction)filterPopupSearchButtonClicked:(UIButton *)sender;
- (IBAction)filterOptionButtonCLicked:(UIButton *)sender;

@end
