//
//  Location.m
//  ContactMap
//
//  Created by Pankaj Chauhan on 18/8/17.
//  Copyright (c) 2017 Pankaj. All rights reserved.
//

#import "Location.h"


@implementation Location
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
  if ((self = [super init])) {
    _name = [name copy];
    _address = [address copy];
    _coordinate = coordinate;
  }
  return self;
}

- (NSString *)title {
  if ([_name isKindOfClass:[NSNull class]])
    return @"";
  else
    return _name;
}

- (NSString *)subtitle {
  return _address;
}



@end
