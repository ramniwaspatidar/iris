//
//  PolicyDetails+CoreDataProperties.m
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "PolicyDetails+CoreDataProperties.h"

@implementation PolicyDetails (CoreDataProperties)

+ (NSFetchRequest<PolicyDetails *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PolicyDetails"];
}

@dynamic mastercontractname;
@dynamic memberid;
@dynamic policyno;
@dynamic policyperiod;
@dynamic policystatus;
@dynamic premiumamount;
@dynamic productname;
@dynamic emiratesid;
@dynamic startdate;
@dynamic enddate;
@dynamic companyname;
@dynamic insurancecompanyname;
@dynamic parentemiratesid;
@end
