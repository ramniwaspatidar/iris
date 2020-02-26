//
//  BloodPressure+CoreDataProperties.m
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BloodPressure+CoreDataProperties.h"

@implementation BloodPressure (CoreDataProperties)

+ (NSFetchRequest<BloodPressure *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BloodPressure"];
}

@dynamic bloodressureid;
@dynamic date;
@dynamic diastolic;
@dynamic memberid;
@dynamic pulse;
@dynamic systolic;
@dynamic time;

@end
