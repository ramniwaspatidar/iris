//
//  BMI+CoreDataProperties.h
//  
//
//  Created by apptology on 1/18/18.
//
//

#import "BMI+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BMI (CoreDataProperties)

+ (NSFetchRequest<BMI *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bmiid;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *height;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *weight;
@property (nullable, nonatomic, copy) NSString *bmicategory;
@property (nullable, nonatomic, copy) NSString *bmivalue;


@end

NS_ASSUME_NONNULL_END
