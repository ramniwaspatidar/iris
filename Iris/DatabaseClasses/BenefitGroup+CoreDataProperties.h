//
//  BenefitGroup+CoreDataProperties.h
//  
//
//  Created by Deepak on 1/17/18.
//
//

#import "BenefitGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BenefitGroup (CoreDataProperties)

+ (NSFetchRequest<BenefitGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *grouptitle;
@property (nullable, nonatomic, copy) NSString *groupid;

@property (nullable, nonatomic, retain) NSSet<Benefit *> *benefits;

@end

@interface BenefitGroup (CoreDataGeneratedAccessors)

- (void)addBenefitsObject:(Benefit *)value;
- (void)removeBenefitsObject:(Benefit *)value;
- (void)addBenefits:(NSSet<Benefit *> *)values;
- (void)removeBenefits:(NSSet<Benefit *> *)values;

@end

NS_ASSUME_NONNULL_END
