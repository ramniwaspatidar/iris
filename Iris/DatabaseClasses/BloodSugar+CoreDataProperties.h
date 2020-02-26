//
//  BloodSugar+CoreDataProperties.h
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BloodSugar+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BloodSugar (CoreDataProperties)

+ (NSFetchRequest<BloodSugar *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bloodsugar;
@property (nullable, nonatomic, copy) NSString *bloodsugarid;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSString *slot;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
