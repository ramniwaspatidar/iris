//
//  SearchViewController.h
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import "ResultViewController.h"
#import "CustomMapView.h"
#import "CalloutView.h"

@interface SearchViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,CustomMapViewDelegate>
{
    //NSMutableArray *_locationArray;
    __weak IBOutlet UISwitch *_mapListSwitch;
    __weak IBOutlet UILabel *_currentLocationLabel;
    __weak IBOutlet UITableView *_mainTableView;
    __weak IBOutlet UIButton *_sideMenuBtnOutlet;
    NSMutableArray *_searchDetailArray;
    NSMutableArray *_filteredDetailArray;
    CLLocationManager *locationManager;
    NSMutableDictionary *_latLongDictionary;
    __weak IBOutlet UIView *containerView;
    BOOL _isFilterApplied;
    __weak IBOutlet NSLayoutConstraint *_mapViewLeadingCons;
    __weak IBOutlet NSLayoutConstraint *tableViewLeadingCons;
    int annotationTag;
    
    __weak IBOutlet UILabel *_messageLabel;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    CLLocationCoordinate2D _currentLocationCoordinate;
    ResultViewController *_resultViewController;
    __weak IBOutlet UIImageView *notificationIconImageView;
    __weak IBOutlet UIImageView *phoneIconImageView;
    NSMutableArray *calloutArray;
    
    
    __weak IBOutlet UILabel *imlookingLbl;
    __weak IBOutlet UILabel *mapLbl;
    __weak IBOutlet UILabel *listLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *searchLbl;
    
}
@property (nonatomic,assign)BOOL isLocationLoaded;
@property (nonatomic,strong)IBOutlet CustomMapView *myMapView;
@property(nonatomic,strong)CalloutView *calloutView;

@property (nonatomic,strong)NSDictionary *personDetailDictionary;
-(void)callSearchDoctorsFacilityAPI:(NSDictionary *)filteredDictionary;
-(void)resetData;

-(void)removeFilter;

-(void)removeCalloutView;
@end

