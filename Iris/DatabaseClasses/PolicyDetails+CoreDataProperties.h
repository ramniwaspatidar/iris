//
//  PolicyDetails+CoreDataProperties.h
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "PolicyDetails+CoreDataClass.h"
#import "BenefitGroup+CoreDataProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface PolicyDetails (CoreDataProperties)

+ (NSFetchRequest<PolicyDetails *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *mastercontractname;
@property (nullable, nonatomic, copy) NSString *insurancecompanyname;
@property (nullable, nonatomic, copy) NSString *companyname;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *policyno;
@property (nullable, nonatomic, copy) NSString *policyperiod;
@property (nullable, nonatomic, copy) NSString *policystatus;
@property (nullable, nonatomic, copy) NSString *premiumamount;
@property (nullable, nonatomic, copy) NSString *productname;
@property (nullable, nonatomic, copy) NSString *emiratesid;
@property (nullable, nonatomic, copy) NSString *startdate;
@property (nullable, nonatomic, copy) NSString *enddate;
@property (nullable, nonatomic, copy) NSString *parentemiratesid;
@property (nullable, nonatomic, retain) NSSet<BenefitGroup *> *benefitgroup;

@end

NS_ASSUME_NONNULL_END
