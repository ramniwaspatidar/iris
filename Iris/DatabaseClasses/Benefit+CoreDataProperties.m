//
//  Benefit+CoreDataProperties.m
//  
//
//  Created by Deepak on 1/17/18.
//
//

#import "Benefit+CoreDataProperties.h"

@implementation Benefit (CoreDataProperties)

+ (NSFetchRequest<Benefit *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Benefit"];
}

@dynamic benefitid;
@dynamic benefitdescription;
@dynamic value;
@dynamic parentid;
@dynamic sortid;

@end
