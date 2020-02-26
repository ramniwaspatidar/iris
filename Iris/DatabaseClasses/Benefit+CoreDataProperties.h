//
//  Benefit+CoreDataProperties.h
//  
//
//  Created by Deepak on 1/17/18.
//
//

#import "Benefit+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Benefit (CoreDataProperties)

+ (NSFetchRequest<Benefit *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *benefitid;
@property (nullable, nonatomic, copy) NSString *benefitdescription;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSString *parentid;
@property (nullable, nonatomic, copy) NSString *sortid;


@end

NS_ASSUME_NONNULL_END
