//
//  MedicineAlert+CoreDataProperties.h
//  
//
//  Created by apptology on 03/01/18.
//
//

#import "MedicineAlert+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MedicineAlert (CoreDataProperties)

+ (NSFetchRequest<MedicineAlert *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *notify;
@property (nullable, nonatomic, copy) NSString *category;
@property (nullable, nonatomic, copy) NSString *medicines;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *repeat;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *emiratesid;

@end

NS_ASSUME_NONNULL_END
