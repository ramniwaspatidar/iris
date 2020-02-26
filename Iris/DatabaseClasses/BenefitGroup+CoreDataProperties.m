//
//  BenefitGroup+CoreDataProperties.m
//  
//
//  Created by Deepak on 1/17/18.
//
//

#import "BenefitGroup+CoreDataProperties.h"

@implementation BenefitGroup (CoreDataProperties)

+ (NSFetchRequest<BenefitGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BenefitGroup"];
}

@dynamic grouptitle;
@dynamic benefits;
@dynamic groupid;

@end
