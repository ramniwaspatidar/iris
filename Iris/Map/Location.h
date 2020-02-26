//
//  Location.h
//  ContactMap
//
//  Created by Pankaj Chauhan on 18/8/17.
//  Copyright (c) 2017 Pankaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation> {
  NSString *_name;
  NSString *_address;
  CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
