//
//  SearchViewController.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "SearchViewController.h"
#import "RevealViewController.h"
#import "SearchTableViewCell.h"
#import "ConnectionManager.h"
#import "Constant.h"
#import "Localization.h"

#import "AppointmentReminderViewController.h"
#import "FilterViewController.h"
#import "Utility.h"
#import "Location.h"
#import "UILabel+CustomLabel.h"
#import "UIImageView+CustomImageView.h"
#import "CalloutView.h"
#import "CustomAnnotationView.h"
#import "AppDelegate.h"
#import "MainSideMenuViewController.h"
#import "ClinicAnnotationView.h"
#import "NotificationViewController.h"

//AIzaSyBLPs_aopkokQGJKgn6M4gvUR6lPDBodbs   google key
@interface SearchViewController ()<GMSAutocompleteViewControllerDelegate>

@end

@implementation SearchViewController
#define kStartTag 1000
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    //    _searchDetailArray = [[NSMutableArray alloc] init];
    //    _filteredDetailArray = [[NSMutableArray alloc] init];
    calloutArray= [[NSMutableArray alloc] init];
    _myMapView.delegate = self;
    [_myMapView setMapType:MKMapTypeStandard];
    [_myMapView setZoomEnabled:YES];
    [_myMapView setScrollEnabled:YES];
    
    //_locationArray = [[NSMutableArray alloc] init];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    //[locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // or requestAlwaysAuthorization
        [locationManager requestWhenInUseAuthorization]; // or requestAlwaysAuthorization
    }
    //[locationManager startUpdatingLocation];
    
    
    if(!self.personDetailDictionary)
        self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 110;
    
    [_mapListSwitch setOn:NO animated:NO];
    
    _mapListSwitch.layer.cornerRadius = 16.0; // you must import QuartzCore to do this
    
    containerView.layer.borderWidth = 1.0;
    containerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    if (_mapListSwitch.on) {
        NSLog(@"If body ");
        
        [_mapListSwitch setBackgroundColor:[UIColor whiteColor]];
        [_mapListSwitch setOnTintColor:[UIColor whiteColor]];
        
    }else{
        NSLog(@"Else body ");
        [_mapListSwitch setTintColor:[UIColor clearColor]];
        [_mapListSwitch setBackgroundColor:[UIColor lightGrayColor]];
    }
    //[self callSearchDoctorsFacilityAPI:nil];
    [self resetData];
    
    _myMapView.customDelegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Search"];
}

-(void)removeFilter
{
    if(self.isLocationLoaded)
    {
        if(locationManager.location.coordinate.latitude)
        {
            _currentLocationCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
        }
        if(_isFilterApplied)
        {
            [_filteredDetailArray removeAllObjects];
            _isFilterApplied = NO;
        }
        [self callSearchDoctorsFacilityAPI:nil];
        [self getAddressFromCurruntLocation:_currentLocationCoordinate];
    }
}

-(void)loadLocationForFirstTime
{
    if(locationManager.location.coordinate.latitude)
       // _currentLocationCoordinate = CLLocationCoordinate2DMake(25.23, 55.31);
        _currentLocationCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    else
        _currentLocationCoordinate = CLLocationCoordinate2DMake(25.23, 55.31);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [locationManager stopUpdatingLocation];
    });
    [self getAddressFromCurruntLocation:_currentLocationCoordinate];
    [self callSearchDoctorsFacilityAPI:nil];
    //_latLongDictionary = [[NSMutableDictionary alloc] init];
    //[_latLongDictionary setValue:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude] forKey:kLatitude];
    //[_latLongDictionary setValue:[NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude] forKey:kLongitude];
    
}
-(void)changedCurrentLocation
{
    CLLocationCoordinate2D destinationPoint;
    
    NSDictionary *location = nil;
    if(_isFilterApplied)
        location = [_filteredDetailArray firstObject];
    else
        location = [_searchDetailArray firstObject];
    
    destinationPoint.latitude  =  [[location valueForKey:@"lat"] doubleValue];
    destinationPoint.longitude = [[location valueForKey:@"lng"] doubleValue];
    if(destinationPoint.latitude == 0 && destinationPoint.longitude == 0)
    {
        destinationPoint.latitude = locationManager.location.coordinate.latitude;
        destinationPoint.longitude = locationManager.location.coordinate.longitude;
    }
    MKCoordinateRegion adjustedRegion = [_myMapView regionThatFits:MKCoordinateRegionMakeWithDistance(destinationPoint, 10000, 10000)];
    [_myMapView setRegion:adjustedRegion animated:YES];
}
/*
 -(void)addGooglePlaceSetup
 {
 _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
 _resultsViewController.delegate = self;
 
 _searchController = [[UISearchController alloc]
 initWithSearchResultsController:_resultsViewController];
 _searchController.searchResultsUpdater = _resultsViewController;
 
 UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 65.0, 250, 50)];
 
 [subView addSubview:_searchController.searchBar];
 [_searchController.searchBar sizeToFit];
 [self.view addSubview:subView];
 
 // When UISearchController presents the results view, present it in
 // this view controller, not one further up the chain.
 self.definesPresentationContext = YES;
 
 }*/



-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        searchLbl.text =  [Localization languageSelectedStringForKey:@"Search"];
         _currentLocationLabel.text =  [Localization languageSelectedStringForKey:@"location"];
         imlookingLbl.text =  [Localization languageSelectedStringForKey:@"I am looking for"];
        
         listLbl.text =  [Localization languageSelectedStringForKey:@"List"];
        
         mapLbl.text =  [Localization languageSelectedStringForKey:@"Map"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        searchLbl.text =  [Localization languageSelectedStringForKey:@"Search"];
        _currentLocationLabel.text =  [Localization languageSelectedStringForKey:@"location"];
        imlookingLbl.text =  [Localization languageSelectedStringForKey:@"I am looking for"];
        
        listLbl.text =  [Localization languageSelectedStringForKey:@"List"];
        
        mapLbl.text =  [Localization languageSelectedStringForKey:@"Map"];
        [_sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    [phoneIconImageView setGestureOnImageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

-(void)resetData {
    if(_searchDetailArray == nil)
        _searchDetailArray = [[NSMutableArray alloc] init];
    
    if(_filteredDetailArray == nil)
        _filteredDetailArray = [[NSMutableArray alloc] init];
    
    _isFilterApplied = NO;
    //_currentLocationCoordinate = kCLLocationCoordinate2DInvalid;
    _currentLocationLabel.text = @"location";
    [locationManager startUpdatingLocation];
    [self callSearchDoctorsFacilityAPI:nil];
    [_mainTableView reloadData];
}

#pragma mark - Google Places Delegate Methods -

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    _isFilterApplied = NO;
    _currentLocationCoordinate = place.coordinate;
    _currentLocationLabel.text = [NSString stringWithFormat:@"%@",place.formattedAddress];
    [self callSearchDoctorsFacilityAPI:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark - Map View Methods -
-(void)showMapAnnotation
{
    id userLocation = [_myMapView userLocation];
    [_myMapView removeAnnotations:[_myMapView annotations]];
    
    if ( userLocation != nil ) {
        //[_myMapView addAnnotation:userLocation]; // will cause user location pin to blink
    }
    
    //annotationTag = 100;
    NSArray *mapLocationArray = nil;
    if(_isFilterApplied)
        mapLocationArray = [_filteredDetailArray copy];
    else
        mapLocationArray = [_searchDetailArray copy];
    
    /*NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"lat" ascending:YES];
     NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"lng" ascending:YES];
     
     mapLocationArray = [mapLocationArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil]];*/
    
    for(int i = 0; i<mapLocationArray.count; i++){
        NSDictionary *location = [mapLocationArray objectAtIndex:i];
        CLLocationCoordinate2D  point;
        point.latitude  = [[location valueForKey:@"lat"] doubleValue];
        point.longitude = [[location valueForKey:@"lng"] doubleValue];
        //NSString * description = [location valueForKey:@"doctorname"];
        //NSString * address = [location valueForKey:@"region"];
        //Location *annotation = [[Location alloc] initWithName:description address:address coordinate:point] ;
        
        ClinicAnnotationView *annotationPoint = [[ClinicAnnotationView alloc] init];
        annotationPoint.coordinate = point;
        annotationPoint.identifier = i+kStartTag;
        annotationPoint.doctorName = [location valueForKey:@"doctorname"];
        [self.myMapView addAnnotation:annotationPoint];
        // annotationTag++;
        
    }
}

#pragma mark - Location manager Delegate -
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    locationManager.delegate = nil;
    
    if(self.isLocationLoaded == YES)
        return;
    
    self.isLocationLoaded = YES;
    
    if(_currentLocationCoordinate.latitude == 0)
        _currentLocationCoordinate = [locations firstObject].coordinate;
    
    [self loadLocationForFirstTime];
}

#pragma mark - MapView Delegate -
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(self.isLocationLoaded == YES)
        return;
    
    CLLocationCoordinate2D startCoord =  CLLocationCoordinate2DMake(25.23, 55.31);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000); //userLocation.coordinate
    //[self.myMapView setRegion:[self.myMapView regionThatFits:region] animated:YES];
    
    self.isLocationLoaded = YES;
    
    if(_currentLocationCoordinate.latitude == 0)
        _currentLocationCoordinate = userLocation.coordinate;
    
    [self loadLocationForFirstTime];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    ClinicAnnotationView *customAnnotationView = (ClinicAnnotationView *)annotation;
    NSInteger index = customAnnotationView.identifier;
    
    static NSString *identifier = @"myAnnotation";
    CustomAnnotationView * annotationView = (CustomAnnotationView *)[_myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.image = [UIImage imageNamed:@"arrest.png"];
    }else {
        annotationView.annotation = annotation;
    }
    
    
    annotationView.animatesDrop = true;
    annotationView.tag = index;
    NSLog(@"tags %d",(int)index);
    //annotationTag++;
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(CustomAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    
    for(CalloutView *callout in calloutArray)
    {
        [callout removeFromSuperview];
        [calloutArray removeObject:callout];
        //callout = nil;
    }
    
    if(self.calloutView && view.isOpen)
    {
        if(self.calloutView.superview)
        {
            [self.calloutView removeFromSuperview];
            self.calloutView = nil;
        }
    }
    
    
    /*for (UIView *childView in self.view.subviews){
     if([childView isKindOfClass:[CalloutView class]])
     [childView removeFromSuperview];
     
     }*/
    NSArray *mapLocationArray = nil;
    if(_isFilterApplied)
        mapLocationArray = [_filteredDetailArray copy];
    else
        mapLocationArray = [_searchDetailArray copy];
    
    NSInteger indexOfTheObject = view.tag;//[mapView.annotations indexOfObject:view.annotation];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lat == %@ AND SELF.lng == %@",[[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"lat"],[[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"lng"]];
    
    NSArray *filteredArray = [mapLocationArray filteredArrayUsingPredicate:predicate];
    
    CalloutView *annotationView2 = [[[NSBundle mainBundle] loadNibNamed:@"calloutView" owner:self options:nil] firstObject];
    //CGPoint hitPoint = [view convertPoint:CGPointZero toView:mapView];
    //[view setFrame:CGRectMake(hitPoint.x-110,hitPoint.y-93, 220, 93)];
    annotationView2.customDelegate = self;
    CGRect calloutViewFrame = annotationView2.frame;
    
    annotationView2.frame = CGRectMake(-calloutViewFrame.size.width/2.23, -calloutViewFrame.size.height-5, 220, 93);
    
    annotationView2.tag = indexOfTheObject;
    //UILabel *nameLbl = (UILabel *)[annotationView2 viewWithTag:1];
    if(annotationView2)
    {
        annotationView2.setReminderButton.tag = indexOfTheObject-1000;
        
        annotationView2.countLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)filteredArray.count];
        
        annotationView2.name.text = [[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"doctorname"];
        
        annotationView2.specialty.text = [[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"specialty"];
        
        annotationView2.hospitalName.text = [[mapLocationArray objectAtIndex:indexOfTheObject - 1000] valueForKey:@"facility"];
        
        annotationView2.address.text = [[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"region"];
        
        
        
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
           
            [annotationView2.setReminderButton setTitle:[Localization languageSelectedStringForKey:@"Set Reminder"] forState:UIControlStateNormal];
             [annotationView2.moveMapButton setTitle:[Localization languageSelectedStringForKey:@"View Route"] forState:UIControlStateNormal];

          //  annotationView2.setReminderButton =  [Localization languageSelectedStringForKey:@"Map"];
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            
           // [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [annotationView2.setReminderButton setTitle:[Localization languageSelectedStringForKey:@"Set Reminder"] forState:UIControlStateNormal];
            [annotationView2.moveMapButton setTitle:[Localization languageSelectedStringForKey:@"View Route"] forState:UIControlStateNormal];
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
        
        
        
        
        
        [calloutArray addObject:annotationView2];
        //self.calloutView = annotationView2;
        [view addSubview:annotationView2];
        view.isOpen = YES;
    }
    
    //UILabel *specialityLbl = (UILabel *)[annotationView2 viewWithTag:2];
    
    
    //UILabel *facilityLbl = (UILabel *)[annotationView2 viewWithTag:3];
    
    
    //UILabel *addressLbl = (UILabel *)[annotationView2 viewWithTag:4];
    
    view.canShowCallout = false;
    //annotationView2.center = view.center;
    //view.centerOffset = CGPointMake(0,-10);
    
    /*UITapGestureRecognizer *tapGesture =
     [[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(calloutTapped:)];
     [annotationView2 addGestureRecognizer:tapGesture];
     */
    
    /*UIButton *btnMap = (UIButton *)[annotationView2 viewWithTag:5];
     if(annotationView2)
     {
     UITapGestureRecognizer *tapGesture =
     [[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(calloutButtonPressed:)];
     [view addGestureRecognizer:tapGesture];
     }*/
    
    
    
}

-(void)calloutButtonPressed:(id)sender
{
    NSLog(@"Callout was tapped");
    UIButton *senderButton = sender;
    //[self removeCalloutView:sender];
    MKAnnotationView *view = (MKAnnotationView*)senderButton.superview;
    /* id <MKAnnotation> annotation = [view annotation];
     if ([annotation isKindOfClass:[MKPointAnnotation class]])
     {
     [self performSegueWithIdentifier:@"annotationDetailSegue" sender:annotation];
     }*/
}

- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable UIView *)view
{
    
    return CGPointZero;
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
    for (UIView *childView in view.subviews){
        if([childView isKindOfClass:[CalloutView class]])
            [childView removeFromSuperview];
        /*if([childView isKindOfClass:[CustomAnnotationView class]])
         [childView removeFromSuperview];
         */
    }
    
    
    /*CLLocation *destinationCoordinate=[[CLLocation alloc] initWithLatitude:[[view annotation] coordinate].latitude longitude:[[view annotation] coordinate].longitude];
     _myMapView.delegate=(id)self;
     CLLocationCoordinate2D zoomLocation = _currentLocationCoordinate;
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 8.5*1609.344, 8.5*1609.344);
     //MKCoordinateRegion adjustedRegion = [_myMapView regionThatFits:viewRegion];
     //[_myMapView setRegion:adjustedRegion animated:YES];
     
     
     MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:_currentLocationCoordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"abc",@"xyz", nil] ];
     MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:source];
     MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:destinationCoordinate.coordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"123",@"456", nil] ];
     MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
     MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
     [request setSource:sourceMapItem];
     [request setDestination:distMapItem];
     [request setTransportType:MKDirectionsTransportTypeAutomobile];
     MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
     [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
     if (!error) {
     for (MKRoute *route in [response routes]) {
     [_myMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
     }
     }
     }];
     */
}


/*   for (UIView *childView in view.subviews){
 if([childView isKindOfClass:[CalloutView class]])
 [childView removeFromSuperview];
 }
 }*/

-(void)removeCalloutView:(CalloutView *)calloutView
{
    //[calloutView removeFromSuperview];
}

/*
 - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
 
 static NSString *identifier = @"Location";
 if ([annotation isKindOfClass:[Location class]]) {
 
 MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
 if (annotationView == nil) {
 annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
 } else {
 annotationView.annotation = annotation;
 }
 
 annotationView.enabled = YES;
 annotationView.canShowCallout = YES;
 annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
 
 return annotationView;
 }
 
 return nil;
 }
 */

#pragma mark- Callout Delgate methods -

-(void)calloutClicked:(MKAnnotationView *)view
{
    
    /* CLLocationCoordinate2D destinationCoordinate = CLLocationCoordinate2DMake([[view annotation] coordinate].latitude, [[view annotation] coordinate].longitude);*/
    
    CLLocationCoordinate2D  destinationCoordinate;
    NSDictionary *location = nil;
    if(_isFilterApplied)
        location = [_filteredDetailArray objectAtIndex:view.tag - 1000];
    else
        location = [_searchDetailArray objectAtIndex:view.tag - 1000];
    
    destinationCoordinate.latitude  = [[location valueForKey:@"lat"] doubleValue];
    destinationCoordinate.longitude = [[location valueForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D sourcePCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@+%@", sourcePCoordinate.latitude, sourcePCoordinate.longitude, [location valueForKey:@"facility"],[location valueForKey:@"emirate"]];
    
    googleMapUrlString = [googleMapUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}

-(void)reminderButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:kAppointmentReminderIdentifier sender:sender];
}

-(void)nextButtonClicked:(id)sender
{
    UIButton *nextButton = (UIButton*)sender;
    CalloutView *callout = (CalloutView *)nextButton.superview.superview;
    
    
    if(!callout || ![callout isKindOfClass:[CalloutView class]])
        return;
    
    CustomAnnotationView *customAnnotationView = (CustomAnnotationView *)callout.superview;
    
    if(!customAnnotationView || ![customAnnotationView isKindOfClass:[CustomAnnotationView class]])
        return;
    
    NSInteger indexOfTheObject = customAnnotationView.tag;//[_myMapView.annotations indexOfObject:customAnnotationView.annotation];
    
    NSArray *mapLocationArray = nil;
    if(_isFilterApplied)
        mapLocationArray = [_filteredDetailArray copy];
    else
        mapLocationArray = [_searchDetailArray copy];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lat == %@ AND SELF.lng == %@",[[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"lat"],[[mapLocationArray objectAtIndex:indexOfTheObject-1000] valueForKey:@"lng"]];
    
    NSArray *filteredArray = [mapLocationArray filteredArrayUsingPredicate:predicate];
    int currentIndex = 0;
    
    if(filteredArray.count > 0)
    {
        for(int i = 0; i < filteredArray.count; i++)
        {
            NSDictionary *infoDic = [filteredArray objectAtIndex:i];
            if([callout.name.text isEqualToString:[infoDic valueForKey:@"doctorname"]])
            {
                currentIndex = i;
                break;
            }
        }
        if(currentIndex == filteredArray.count - 1)
        {
            // last record
            
            id<MKAnnotation>annotationObj = [_myMapView.annotations objectAtIndex:indexOfTheObject-1000];
            //[self mapView:_myMapView didDeselectAnnotationView:customAnnotationView];
            //[_myMapView deselectAnnotation:annotationObj animated:NO];
            
            //[self mapView:_myMapView didDeselectAnnotationView:customAnnotationView];
            
            
            if(callout.superview)
                [callout removeFromSuperview];
            
            CustomAnnotationView *annotationView2 = nil;
            
            for(ClinicAnnotationView *annotationPoint in _myMapView.annotations)
            {
                if ([annotationPoint isKindOfClass:[MKUserLocation class]]){
                    continue;
                }
                
                NSString* latitudeString = [NSString stringWithFormat:@"%.06f", annotationPoint.coordinate.latitude];
                NSString* longString = [NSString stringWithFormat:@"%.06f", annotationPoint.coordinate.longitude];
                float latitude = [latitudeString floatValue];
                float longitude = [longString floatValue];
                
                if([annotationPoint.doctorName isEqualToString:[[filteredArray objectAtIndex:0] valueForKey:@"doctorname"]] && latitude == [[[filteredArray objectAtIndex:0] valueForKey:@"lat"] floatValue])
                {
                    annotationView2 = [self.view viewWithTag:annotationPoint.identifier];
                }
            }
            
            int index = (int)[mapLocationArray indexOfObject:[filteredArray firstObject]];
            //CustomAnnotationView *annotationView2 = [self.view viewWithTag:1000+index];
            
            if(![annotationView2 isKindOfClass:[CustomAnnotationView class]])
            {
                for(UIView *view in self.view.subviews)
                    if(view.tag == 1000+index && [view isKindOfClass:[CustomAnnotationView class]])
                        annotationView2 = (CustomAnnotationView*)view;
            }
            
            if(annotationView2 && [annotationView2 isKindOfClass:[CustomAnnotationView class]])
            {
                
                [self mapView:_myMapView didSelectAnnotationView:annotationView2];
            }
        }
        else
        {
            if(callout.superview)
            {
                [callout removeFromSuperview];
                callout = nil;
            }
            
            CustomAnnotationView *annotationView2 = nil;
            
            for(ClinicAnnotationView *annotationPoint in _myMapView.annotations)
            {
                if ([annotationPoint isKindOfClass:[MKUserLocation class]]){
                    continue;
                }
                //&& annotationPoint.coordinate.latitude == [[filteredArray objectAtIndex:currentIndex+1] valueForKey:@"lat"]
                NSString* latitudeString = [NSString stringWithFormat:@"%.06f", annotationPoint.coordinate.latitude];
                NSString* longString = [NSString stringWithFormat:@"%.06f", annotationPoint.coordinate.longitude];
                float latitude = [latitudeString floatValue];
                float longitude = [longString floatValue];
                
                
                if([annotationPoint.doctorName isEqualToString:[[filteredArray objectAtIndex:currentIndex+1] valueForKey:@"doctorname"]] && latitude == [[[filteredArray objectAtIndex:currentIndex+1] valueForKey:@"lat"] floatValue])
                {
                    annotationView2 = [self.view viewWithTag:annotationPoint.identifier];
                    break;
                }
            }
            
            //id<MKAnnotation>annotationObj = [_myMapView.annotations objectAtIndex:indexOfTheObject];
            //[self mapView:_myMapView didDeselectAnnotationView:customAnnotationView];
            //[_myMapView deselectAnnotation:annotationObj animated:NO];
            //            for (id<MKAnnotation> currentAnnotation in _myMapView.selectedAnnotations) {
            //                    [_myMapView deselectAnnotation:currentAnnotation animated:FALSE];
            //
            //            }
            //id<MKAnnotation>nextAnnotationObj = [_myMapView.annotations objectAtIndex:(indexOfTheObject+1)];
            
            //CustomAnnotationView *annotationView2 = [self.view viewWithTag:indexOfTheObject+1];
            if(![annotationView2 isKindOfClass:[CustomAnnotationView class]])
            {
                for(UIView *view in self.view.subviews)
                    if(view.tag == indexOfTheObject+1 && [view isKindOfClass:[CustomAnnotationView class]])
                        annotationView2 = (CustomAnnotationView*)view;
            }
            if(annotationView2 && [annotationView2 isKindOfClass:[CustomAnnotationView class]])
            {
                
                //[_myMapView selectAnnotation:nextAnnotationObj animated:YES];
                [self mapView:_myMapView didSelectAnnotationView:annotationView2];
                
            }
        }
    }
    
    
    
    
    //[self performSegueWithIdentifier:kAppointmentReminderIdentifier sender:sender];
}


-(void)openCalloutView:(CustomAnnotationView *)annotationView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self mapView:_myMapView didSelectAnnotationView:annotationView];
    });
    
}


-(void)removeCallout
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(CalloutView *callout in calloutArray)
        {
            [callout removeFromSuperview];
            [calloutArray removeObject:callout];
            //callout = nil;
        }
        if(self.calloutView)
        {
            [self.calloutView removeFromSuperview];
            self.calloutView = nil;
        }
    });
}
#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isFilterApplied)
        return _filteredDetailArray.count;
    return _searchDetailArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"SearchCellIdentifier";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(_isFilterApplied)
    {
        cell.name.text = [[_filteredDetailArray objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
        cell.specialty.text = [[_filteredDetailArray objectAtIndex:indexPath.row] valueForKey:@"specialty"];
        cell.hospitalName.text = [[_filteredDetailArray objectAtIndex:indexPath.row] valueForKey:@"facility"];
        cell.address.text = [[_filteredDetailArray objectAtIndex:indexPath.row] valueForKey:@"region"];
    }
    else
    {
        cell.name.text = [[_searchDetailArray objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
        cell.specialty.text = [[_searchDetailArray objectAtIndex:indexPath.row] valueForKey:@"specialty"];
        cell.hospitalName.text = [[_searchDetailArray objectAtIndex:indexPath.row] valueForKey:@"facility"];
        cell.address.text = [[_searchDetailArray objectAtIndex:indexPath.row] valueForKey:@"region"];
    }
    
    if(cell.reminderButton)
    {
        cell.reminderButton.tag = indexPath.row;
        [cell.reminderButton addTarget:self
                                action:@selector(reminderButtonAction:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(cell.directionButton)
    {
        cell.directionButton.tag = indexPath.row;
        [cell.directionButton addTarget:self
                                 action:@selector(directionButtonAction:)
                       forControlEvents:UIControlEventTouchUpInside];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    //cell.emiratesIdValueLabel.text = [self.personDetailDictionary valueForKey:@"memberid"];
    return cell;
    
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 110;
 }*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}


#pragma mark- Button Action methods -

-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    notificationVC.personDetailDictionary = self.personDetailDictionary;
    [self.navigationController pushViewController:notificationVC animated:YES];
}

- (IBAction)getLocationButtonAction:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
   
    [self presentViewController:acController animated:YES completion:nil];
    
    /*ResultViewController *acController = [[ResultViewController alloc] init];
     acController.customDelegate = self;
     [self presentViewController:acController animated:YES completion:nil];
     */
}

- (IBAction)mapListSwitchAction:(id)sender {
    
    UISwitch *switchBtn = sender;
    if(switchBtn.isOn)
    {
        _mapViewLeadingCons.constant = - self.view.frame.size.width;
    }
    else
    {
        _mapViewLeadingCons.constant = 0;
        [_myMapView reloadInputViews];
    }
}

-(IBAction)showMapAction:(id)sender
{
    if(_mapListSwitch.isOn)
        return;
    
    [_mapListSwitch setOn:YES];
    [self mapListSwitchAction:_mapListSwitch];
}

-(IBAction)showListAction:(id)sender
{
    if(!_mapListSwitch.isOn)
        return;
    [_mapListSwitch setOn:NO];
    [self mapListSwitchAction:_mapListSwitch];
}

- (IBAction)filterButtonAction:(id)sender {
    [self performSegueWithIdentifier:kFilterIdentifier sender:nil];
    
}


-(void)reminderButtonAction:(id)sender
{
    [self performSegueWithIdentifier:kAppointmentReminderIdentifier sender:sender];
}

-(void)directionButtonAction:(id)sender
{
    UIButton *directionBtn = sender;
    CLLocationCoordinate2D  destinationPoint;
    NSDictionary *location = nil;
    if(_isFilterApplied)
        location = [_filteredDetailArray objectAtIndex:directionBtn.tag];
    else
        location = [_searchDetailArray objectAtIndex:directionBtn.tag];
    
    destinationPoint.latitude  = [[location valueForKey:@"lat"] doubleValue];
    destinationPoint.longitude = [[location valueForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D sourcePCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@+%@", sourcePCoordinate.latitude, sourcePCoordinate.longitude, [location valueForKey:@"facility"],[location valueForKey:@"emirate"]];
    
    googleMapUrlString = [googleMapUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kAppointmentReminderIdentifier])
    {
        UIButton *btnReminder = sender;
        AppointmentReminderViewController *appointReminderViewController = segue.destinationViewController;
        //appointReminderViewController.canDeleteAppointment = YES;
        if(_isFilterApplied)
            appointReminderViewController.appointmentInfoDictionary = [_filteredDetailArray objectAtIndex:btnReminder.tag];
        else
            appointReminderViewController.appointmentInfoDictionary = [_searchDetailArray objectAtIndex:btnReminder.tag];
    }
    else if ([segue.identifier isEqualToString:kFilterIdentifier])
    {
        FilterViewController *filterViewController = segue.destinationViewController;
        filterViewController.tokenString = [self.personDetailDictionary valueForKey:@"token"];
        filterViewController.customDelegate = self;
    }
}


-(void)callSearchDoctorsFacilityAPI:(NSDictionary *)filteredDictionary
{
    if(_currentLocationCoordinate.latitude == 0)
    {
        [self showMapAnnotation];
        return;
    }
    annotationTag = 0;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[self.personDetailDictionary valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[NSNumber numberWithInt:1000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:1] forKey:@"datafilter"];
    //[dictionary setObject:[_latLongDictionary valueForKey:kLatitude] forKey:kLatitude];
    //[dictionary setObject:[_latLongDictionary valueForKey:kLongitude] forKey:kLongitude];
    [dictionary setObject:[NSString stringWithFormat:@"%lf",_currentLocationCoordinate.latitude] forKey:kLatitude];
    [dictionary setObject:[NSString stringWithFormat:@"%lf",_currentLocationCoordinate.longitude] forKey:kLongitude];
    [dictionary setValue:[NSNumber numberWithInt:10] forKey:@"proximity"];
    
    if(filteredDictionary)
    {
        _isFilterApplied = YES;
        if([filteredDictionary valueForKey:@"proximity"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"proximity"] forKey:@"proximity"];
        }
        else
        {
            [dictionary setValue:[NSNumber numberWithInt:10] forKey:@"proximity"];
        }
        if([filteredDictionary valueForKey:@"doctor"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"doctor"] forKey:@"doctorname"];
        }
        if([filteredDictionary valueForKey:@"specialty"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"specialty"] forKey:@"specialty"];
        }
        if([filteredDictionary valueForKey:@"facility"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"facility"] forKey:@"facility"];
        }
        if([filteredDictionary valueForKey:@"gender"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"gender"] forKey:@"doctorgender"];
        }
        
        if([filteredDictionary valueForKey:@"language"])
        {
            [dictionary setValue:[filteredDictionary valueForKey:@"language"] forKey:@"Language"];
        }
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"SearchDoctorsFacility"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[self.personDetailDictionary valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 _messageLabel.text = @"";

                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     if(_isFilterApplied)
                     {
                         //NSArray *sortedArray = [responseDictionary valueForKey:@"doctors"];
                         [_filteredDetailArray removeAllObjects];
                         [_filteredDetailArray addObjectsFromArray:[responseDictionary valueForKey:@"doctors"]];
                         /*NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lat" ascending:YES];
                          
                          sortedArray = [sortedArray
                          sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
                          [_filteredDetailArray addObjectsFromArray:sortedArray];
                          */
                         
                     }
                     else
                     {
                         [_searchDetailArray removeAllObjects];
                         [_searchDetailArray addObjectsFromArray:[responseDictionary valueForKey:@"doctors"]];
                         
                         /*NSArray *sortedArray = [responseDictionary valueForKey:@"doctors"];
                          NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lat" ascending:YES];
                          
                          sortedArray = [sortedArray
                          sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
                          [_searchDetailArray addObjectsFromArray:sortedArray];
                          */
                         
                     }
                     [self showMapAnnotation];
                     [self changedCurrentLocation];
                     
                     // [_myMapView reloadInputViews];
                     
                     
                     [_mainTableView reloadData];
                     if(_filteredDetailArray.count == 0 && _isFilterApplied)
                     {
                         
                         NSString *message = [self getAlertMessageForFilter:filteredDictionary];
                         _messageLabel.text = message;

                         /*if(_mapListSwitch.on)
                         {
                             [Utility showAlertViewControllerIn:self title:@"" message:message block:^(int index) {
                                 
                             }];
                         }*/
                         
                     }
                     else if(!_isFilterApplied && _searchDetailArray.count == 0)
                     {
                         NSString *message = [Localization languageSelectedStringForKey:@"No Doctor/Hospital/Clinic/Lab/Pharmacy is found within the 10 Kms proximity of your current location. Consider changing your current location and try again. Or tap on Search Tab to reset"];
                         _messageLabel.text = message;
                         /*if(_mapListSwitch.on)
                         {
                             [Utility showAlertViewControllerIn:self title:@"" message:message block:^(int index) {
                                 
                             }];
                         }*/
                     }
                     return;
                     
                 }
                 else if([[responseDictionary valueForKey:@"status"] intValue] == 3)
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Session expired ,Please login"] block:^(int index)
                      {
                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                          [appDelegate logout];
                      }];
                 }
                 else
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                     }];
                 }
                 
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 _messageLabel.text = @"";

             });
         }
     }];
}


-(NSString *)getAlertMessageForFilter:(NSDictionary *)filteredDictionary
{
    NSString *msg = nil;
   if([filteredDictionary valueForKey:@"doctor"] && ! [[Utility trimString:[filteredDictionary valueForKey:@"doctor"]] isEqualToString:@""])
   {
       if ([filteredDictionary valueForKey:@"specialty"] && ! [[Utility trimString:[filteredDictionary valueForKey:@"specialty"]] isEqualToString:@""]) {
           
           msg = [NSString stringWithFormat:@"%@ %@ %@  %@",[filteredDictionary valueForKey:@"specialty"],[Localization languageSelectedStringForKey:@"with name"],[filteredDictionary valueForKey:@"doctor"],[Localization languageSelectedStringForKey:@"not found"]];
       }
       else {
           msg = [NSString stringWithFormat:@"%@ %@ %@",[Localization languageSelectedStringForKey:@"No doctor with name"],[filteredDictionary valueForKey:@"doctor"],[Localization languageSelectedStringForKey:@"not found"]];
       }
   }
   else if([filteredDictionary valueForKey:@"facility"] && ! [[Utility trimString:[filteredDictionary valueForKey:@"facility"]] isEqualToString:@""])
   {
       if ([filteredDictionary valueForKey:@"specialty"] && ! [[Utility trimString:[filteredDictionary valueForKey:@"specialty"]] isEqualToString:@""]) {
           msg = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",[Localization languageSelectedStringForKey:@"No"],[filteredDictionary valueForKey:@"specialty"],[Localization languageSelectedStringForKey:@"is found in"],[filteredDictionary valueForKey:@"facility"],[Localization languageSelectedStringForKey:@"facility"]];
       }
       else {
           msg = [NSString stringWithFormat:@"%@ %@",[filteredDictionary valueForKey:@"facility"],[Localization languageSelectedStringForKey:@"is not"]];
       }
   }
   else if([filteredDictionary valueForKey:@"specialty"] && ! [[Utility trimString:[filteredDictionary valueForKey:@"specialty"]] isEqualToString:@""])
   {
       msg = [NSString stringWithFormat:@"%@ %@ %@",[Localization languageSelectedStringForKey:@"No"],[filteredDictionary valueForKey:@"specialty"],[Localization languageSelectedStringForKey:@"is found"]];
   }
    else
    {
        msg = [Localization languageSelectedStringForKey:@"No Doctor/Hospital/Clinic/Lab/Pharmacy is found"];

    }
    int proximity = 10;
    if([filteredDictionary valueForKey:@"proximity"])
    {
        proximity = [[filteredDictionary valueForKey:@"proximity"] intValue];
    }
    // [Localization languageSelectedStringForKey:@"No doctor with name"]

    return [NSString stringWithFormat:@"%@ %@ %d %@",msg,[Localization languageSelectedStringForKey:@"within the"],proximity,[Localization languageSelectedStringForKey:@"Kms proximity of your current location. Consider changing your current location and try again. Or tap on Search Tab to reset."]];
}


-(void)getAddressFromCurruntLocation:(CLLocationCoordinate2D)locationCoordinate{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             //address is NSString variable that declare in .h file.
             _currentLocationLabel.text = [NSString stringWithFormat:@"%@, %@, %@",[placemark name],[placemark locality],[placemark country]];
         }
     }];
}

-(void)callGetCurrentAddressAPI
{
    NSString *url = [NSString stringWithFormat:@"http://www.mapquestapi.com/geocoding/v1/reverse?key=AIzaSyDD92afc7M8NesWL3OGgFB7LEEzNfWyRA8&location=%lf,%lf&includeRoadMetadata=true&includeNearestIntersection=true",_currentLocationCoordinate.latitude,_currentLocationCoordinate.longitude];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url withHeader:nil  timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSDictionary *locationDictionary = [[dictionary valueForKey:@"locations"]firstObject];
                 _currentLocationLabel.text = [NSString stringWithFormat:@"%@, %@",[locationDictionary valueForKey:@"adminArea5"],[locationDictionary valueForKey:@"adminArea5Type"]];
                 //if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                     //[_mainTableView reloadData];
                 }
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

