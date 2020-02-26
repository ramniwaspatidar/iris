//
//  ResultViewController.h
//  Iris
//
//  Created by apptology on 18/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface ResultViewController : UIViewController
{
    GMSAutocompleteResultsViewController *_resultsViewController;
    UISearchController *_searchController;
    UISearchBar *_searchBar;
    GMSAutocompleteTableDataSource *_tableDataSource;
}
@property(nonatomic,weak)id customDelegate;
@end
