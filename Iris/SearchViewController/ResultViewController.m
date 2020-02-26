//
//  ResultViewController.m
//  Iris
//
//  Created by apptology on 18/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "ResultViewController.h"
//GMSAutocompleteViewControllerDelegate
@interface ResultViewController ()<GMSAutocompleteResultsViewControllerDelegate>

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

-(void)displaySearchWithDelay:(id)sender
{    //GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    //acController.delegate = self;
    //[self presentViewController:acController animated:YES completion:nil];}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
 didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictionsForResultsController:
(GMSAutocompleteResultsViewController *)resultsController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
