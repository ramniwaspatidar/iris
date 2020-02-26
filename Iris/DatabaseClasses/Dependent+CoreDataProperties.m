//
//  Dependent+CoreDataProperties.m
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "Dependent+CoreDataProperties.h"

@implementation Dependent (CoreDataProperties)

+ (NSFetchRequest<Dependent *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Dependent"];
}

@dynamic email;
@dynamic emiratesid;
@dynamic parentemiratesid;
@dynamic fullname;
@dynamic gender;
@dynamic memberid;
@dynamic nationality;
@dynamic passport;
@dynamic principalmemberid;
@dynamic relation;
@dynamic residence;
@dynamic profileimage;

@end
