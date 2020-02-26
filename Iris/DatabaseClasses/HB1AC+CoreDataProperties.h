//
//  HB1AC+CoreDataProperties.h
//  
//
//  Created by apptology on 1/19/18.
//
//

#import "HB1AC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface HB1AC (CoreDataProperties)

+ (NSFetchRequest<HB1AC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *hb1id;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *hba1c;

@end

NS_ASSUME_NONNULL_END
