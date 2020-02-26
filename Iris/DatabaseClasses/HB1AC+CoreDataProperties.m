//
//  HB1AC+CoreDataProperties.m
//  
//
//  Created by apptology on 1/19/18.
//
//

#import "HB1AC+CoreDataProperties.h"

@implementation HB1AC (CoreDataProperties)

+ (NSFetchRequest<HB1AC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"HB1AC"];
}

@dynamic hb1id;
@dynamic date;
@dynamic hba1c;

@end
