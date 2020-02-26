//
//  User+CoreDataProperties.m
//  Iris
//
//  Created by apptology on 11/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic company;
@dynamic defaultpolicyholder;
@dynamic email;
@dynamic emiratesid;
@dynamic fullname;
@dynamic gender;
@dynamic insurancecompany;
@dynamic memberid;
@dynamic mobileno;
@dynamic name;
@dynamic nationality;
@dynamic passportno;
@dynamic password;
@dynamic profileimage;
@dynamic residence;
@dynamic token;
@dynamic depend;
@dynamic policydetail;
@dynamic appointmentreminder;

@end
