//
//  Lipid+CoreDataProperties.m
//  
//
//  Created by apptology on 1/19/18.
//
//

#import "Lipid+CoreDataProperties.h"

@implementation Lipid (CoreDataProperties)

+ (NSFetchRequest<Lipid *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Lipid"];
}

@dynamic cholestrol;
@dynamic date;
@dynamic hdl;
@dynamic lipidid;
@dynamic ldl;
@dynamic lipidunit;
@dynamic time;
@dynamic triglycerides;

@end
