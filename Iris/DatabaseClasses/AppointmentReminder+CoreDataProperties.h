//
//  AppointmentReminder+CoreDataProperties.h
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "AppointmentReminder+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppointmentReminder (CoreDataProperties)

+ (NSFetchRequest<AppointmentReminder *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *appointmentdate;
@property (nullable, nonatomic, copy) NSString *casesummary;
@property (nullable, nonatomic, copy) NSString *doctorname;
@property (nullable, nonatomic, copy) NSString *facility;
@property (nullable, nonatomic, copy) NSString *speciality;
@property (nullable, nonatomic, copy) NSString *region;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *lat;
@property (nullable, nonatomic, copy) NSString *lng;
@property (nullable, nonatomic, copy) NSString *emirate;
@property (nullable, nonatomic, copy) NSString *facilityid;
@property (nullable, nonatomic, copy) NSString *doctorlang;
@property (nullable, nonatomic, copy) NSString *doctorgender;
@property (nullable, nonatomic, copy) NSString *timings;
@property (nullable, nonatomic, retain) NSObject *attribute;
@property (nullable, nonatomic, copy) NSString *emiratesid;

@end

NS_ASSUME_NONNULL_END
