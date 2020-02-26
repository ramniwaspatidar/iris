//
//  BloodSugar+CoreDataProperties.m
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BloodSugar+CoreDataProperties.h"

@implementation BloodSugar (CoreDataProperties)

+ (NSFetchRequest<BloodSugar *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BloodSugar"];
}

@dynamic bloodsugar;
@dynamic bloodsugarid;
@dynamic date;
@dynamic memberid;
@dynamic notes;
@dynamic slot;
@dynamic tag;
@dynamic time;

@end
