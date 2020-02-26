//
//  ProviderNetworkViewController.m
//  Iris
//
//  Created by apptology on 08/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ProviderNetworkViewController.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "Utility.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "ProviderNetworkTableViewCell.h"
#import "AppDelegate.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

@interface ProviderNetworkViewController ()

@property (assign) BOOL isFilterShowing;

@end

@implementation ProviderNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _ProviderNetworkArray = [[NSMutableArray alloc] init];
    _ProviderNetworkMasterArray = [[NSMutableArray alloc] init];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.rowHeight = UITableViewAutomaticDimension;
    _mainTableView.estimatedRowHeight = 90;
    [self initialSetupView];
    [self setCurrentLocation];
    [self callProviderNetworkAPI];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Provider Network"]];
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
  
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        provideLbl.text =  [Localization languageSelectedStringForKey:@"Provider Network"];
         clinicLbl.text =  [Localization languageSelectedStringForKey:@"Clinic"];
        
        diagonisticLbl.text =  [Localization languageSelectedStringForKey:@"Diagnostic Center"];
          hospitalLbl.text =  [Localization languageSelectedStringForKey:@"Hospital"];
        pharmacyLbl.text =  [Localization languageSelectedStringForKey:@"Pharmacy"];
        
        [applyBtn setTitle:[Localization languageSelectedStringForKey:@"Apply"] forState:UIControlStateNormal];

       // providerSearchBar.text =  [Localization languageSelectedStringForKey:@"Pharmacy"];
        providerSearchBar.placeholder = [Localization languageSelectedStringForKey:@"Search"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        providerSearchBar.placeholder = [Localization languageSelectedStringForKey:@"Search"];

        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        provideLbl.text =  [Localization languageSelectedStringForKey:@"Provider Network"];
        clinicLbl.text =  [Localization languageSelectedStringForKey:@"Clinic"];
        
        diagonisticLbl.text =  [Localization languageSelectedStringForKey:@"Diagnostic Center"];
        hospitalLbl.text =  [Localization languageSelectedStringForKey:@"Hospital"];
        pharmacyLbl.text =  [Localization languageSelectedStringForKey:@"Pharmacy"];
        
        [applyBtn setTitle:[Localization languageSelectedStringForKey:@"Apply"] forState:UIControlStateNormal];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
   
}

-(void)setCurrentLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) { // or requestAlwaysAuthorization
        [locationManager requestWhenInUseAuthorization]; // or requestAlwaysAuthorization
    }
    [locationManager startUpdatingLocation];
    
    if(locationManager.location.coordinate.latitude)
        _currentLocationCoordinate = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    else
        _currentLocationCoordinate = CLLocationCoordinate2DMake(25.23, 55.31);
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [locationManager stopUpdatingLocation];
    });
}

/*
#pragma mark - MapView Delegate -
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if(isLocationLoaded == YES)
        return;
    
    CLLocationCoordinate2D startCoord =  CLLocationCoordinate2DMake(25.23, 55.31);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    
    _currentLocationCoordinate = userLocation.coordinate;
    
    [self loadLocationForFirstTime];
    isLocationLoaded = YES;
}*/


#pragma mark - search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"Search text: %@",searchBar.text);
    //stateAlt contains[c]
    if(searchBar.text.length > 0) {
        [_ProviderNetworkArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.facilityname contains[cd] %@",searchBar.text]];
        [_mainTableView reloadData];
    } else {
        [self filterPopupSearchButtonClicked:nil];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search text: %@",searchBar.text);
    [searchBar resignFirstResponder];
    
//    [_ProviderNetworkArray filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.facilityname contains[cd] %@",searchBar.text]];
//    [_mainTableView reloadData];

}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    [_ProviderNetworkArray removeAllObjects];
//    [_ProviderNetworkArray addObjectsFromArray:_ProviderNetworkMasterArray];
//    [_mainTableView reloadData];
//}

#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _ProviderNetworkArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"ProviderNetworkCellIdentifier";
    ProviderNetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProviderNetworkTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(cell.directionButton)
    {
        cell.directionButton.tag = indexPath.row;
        [cell.directionButton addTarget:self
                                 action:@selector(directionButtonAction:)
                       forControlEvents:UIControlEventTouchUpInside];
    }
    cell.facilityName.text = [[_ProviderNetworkArray objectAtIndex:indexPath.row] valueForKey:@"facilityname"];
    cell.facilityType.text = [[_ProviderNetworkArray objectAtIndex:indexPath.row] valueForKey:@"facilitytype"];
    cell.location.text = [NSString stringWithFormat:@"%@, %@",[[_ProviderNetworkArray objectAtIndex:indexPath.row] valueForKey:@"location"],[[_ProviderNetworkArray objectAtIndex:indexPath.row] valueForKey:@"emirate"]];

    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        [cell.directionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        cell.directionButton.contentHorizontalAlignment  = NSTextAlignmentCenter;
        [cell.directionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];

        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    return cell;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}*/

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UIEdgeInsets insets  = cell.separatorInset;
//    insets.right = 15;
//    cell.separatorInset = insets;
//    cell.contentView.backgroundColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    //NSString *string =[_headerTitleArray objectAtIndex:section];
    /* Section header is in 0th index... */
    //[label setText:string];
    //[view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[self performSegueWithIdentifier:kTestReportIdentifier sender:labTestArray];
    
}

#pragma mark- Button Action Methods

-(void)directionButtonAction:(id)sender
{
    UIButton *directionBtn = sender;
    CLLocationCoordinate2D  destinationPoint;
    NSDictionary *location = [_ProviderNetworkArray objectAtIndex:directionBtn.tag];
    
    destinationPoint.latitude  = [[location valueForKey:@"lat"] doubleValue];
    destinationPoint.longitude = [[location valueForKey:@"lng"] doubleValue];
    
    CLLocationCoordinate2D sourcePCoordinate = CLLocationCoordinate2DMake(_currentLocationCoordinate.latitude, _currentLocationCoordinate.longitude);
    
    NSString *googleMapUrlString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%f,%f&daddr=%@+%@", sourcePCoordinate.latitude, sourcePCoordinate.longitude, [location valueForKey:@"facilityname"],[location valueForKey:@"emirate"]];
    
    googleMapUrlString = [googleMapUrlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapUrlString]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kTestReportIdentifier])
    {
        /*NSArray *testReportArray = (NSArray*)sender;
        TestReportViewController *testReportViewControllerViewController = segue.destinationViewController;
        testReportViewControllerViewController.reportsArray = [testReportArray mutableCopy];
         */
    }
    
}


#pragma mark - Server API Call -

-(void)callProviderNetworkAPI
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *userEmiritId = [userInfoDic valueForKey:@"emiratesid"];
    
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",userEmiritId];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"memberid"];
    [dictionary setValue:[NSNumber numberWithInt:10000] forKey:@"listcount"];
    [dictionary setValue:[NSNumber numberWithInt:0] forKey:@"datafilter"];
    
    [dictionary setObject:[NSString stringWithFormat:@"%lf",_currentLocationCoordinate.latitude] forKey:kLatitude];
    [dictionary setObject:[NSString stringWithFormat:@"%lf",_currentLocationCoordinate.longitude] forKey:kLongitude];
    [dictionary setValue:[NSNumber numberWithInt:50] forKey:@"proximity"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"SearchFacility"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [_ProviderNetworkMasterArray removeAllObjects];

                     if(((NSArray*)[responseDictionary valueForKey:@"providers"]).count > 0)
                     {
                         [_ProviderNetworkMasterArray addObjectsFromArray:[responseDictionary valueForKey:@"providers"]];
                         
                         [_ProviderNetworkArray removeAllObjects];
                         [_ProviderNetworkArray addObjectsFromArray:[responseDictionary valueForKey:@"providers"]];
                     }
                     [_mainTableView reloadData];

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

- (IBAction)filterButtonClicked:(UIButton *)sender {
    
    [filterPopupBackgroundView setHidden:!filterPopupBackgroundView.isHidden];
    [filterPopupContainerView setHidden:!filterPopupContainerView.isHidden];
    self.isFilterShowing = !filterPopupBackgroundView.isHidden;
}

- (IBAction)filterPopupSearchButtonClicked:(UIButton *)sender {
    NSMutableString *condition = [[NSMutableString alloc] init];
    for (UIButton *optionButton in filterCheckButtons) {
        if(optionButton.isSelected) {
            switch (optionButton.tag) {
                case 2:
                    [condition appendString:@"SELF.facilitytype = 'Clinic'"];
                    break;
                case 1:
                    if(condition.length > 0)
                        [condition appendString:@" OR "];
                    [condition appendString:@"SELF.facilitytype = 'Lab'"];
                    break;
                case 3:
                    if(condition.length > 0)
                        [condition appendString:@" OR "];
                    [condition appendString:@"SELF.facilitytype = 'Pharmacy'"];
                    break;
                case 4:
                    if(condition.length > 0)
                        [condition appendString:@" OR "];
                    [condition appendString:@"SELF.facilitytype = 'Hospital'"];
                    break;

                default:
                    break;
            }
        }
    }
    if(condition.length > 0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:condition];
        [_ProviderNetworkArray removeAllObjects];
        [_ProviderNetworkArray addObjectsFromArray:[_ProviderNetworkMasterArray filteredArrayUsingPredicate:filterPredicate]];
    } else {
        [_ProviderNetworkArray removeAllObjects];
        [_ProviderNetworkArray addObjectsFromArray:_ProviderNetworkMasterArray];
    }
    [_mainTableView reloadData];
    
    if(self.isFilterShowing) [self filterButtonClicked:nil];
    [providerSearchBar resignFirstResponder];
    providerSearchBar.text = @"";
}

- (IBAction)filterOptionButtonCLicked:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}

@end
