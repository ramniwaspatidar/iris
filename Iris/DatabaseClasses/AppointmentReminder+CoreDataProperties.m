//
//  AppointmentReminder+CoreDataProperties.m
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "AppointmentReminder+CoreDataProperties.h"

@implementation AppointmentReminder (CoreDataProperties)

+ (NSFetchRequest<AppointmentReminder *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AppointmentReminder"];
}

@dynamic appointmentdate;
@dynamic casesummary;
@dynamic doctorname;
@dynamic facility;
@dynamic region;
@dynamic memberid;
@dynamic lat;
@dynamic lng;
@dynamic emirate;
@dynamic facilityid;
@dynamic doctorlang;
@dynamic doctorgender;
@dynamic timings;
@dynamic attribute;
@dynamic emiratesid;
@dynamic speciality;

@end
