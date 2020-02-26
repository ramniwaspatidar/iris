//
//  BloodPressure+CoreDataProperties.h
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BloodPressure+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BloodPressure (CoreDataProperties)

+ (NSFetchRequest<BloodPressure *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bloodressureid;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *diastolic;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *pulse;
@property (nullable, nonatomic, copy) NSString *systolic;
@property (nullable, nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
