//
//  ClinicAnnotationView.h
//  Iris
//
//  Created by Deepak on 1/29/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ClinicAnnotationView : MKPointAnnotation

@property (nonatomic) NSInteger identifier;
@property(nonatomic,strong) NSString *doctorName;

@end
