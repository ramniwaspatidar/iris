//
//  CustomMapView.h
//  Iris
//
//  Created by apptology on 26/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol CustomMapViewDelegate
-(void)removeCallout;
@end
@interface CustomMapView : MKMapView
@property(nonatomic,assign)BOOL isDraged;
@property(nonatomic,weak)id customDelegate;

@end
