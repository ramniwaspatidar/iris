//
//  MedicineAlert+CoreDataProperties.m
//  
//
//  Created by apptology on 03/01/18.
//
//

#import "MedicineAlert+CoreDataProperties.h"

@implementation MedicineAlert (CoreDataProperties)

+ (NSFetchRequest<MedicineAlert *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MedicineAlert"];
}

@dynamic notify;
@dynamic category;
@dynamic medicines;
@dynamic date;
@dynamic time;
@dynamic repeat;
@dynamic memberid;
@dynamic emiratesid;

@end
