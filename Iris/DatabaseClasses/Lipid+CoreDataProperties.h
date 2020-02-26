//
//  Lipid+CoreDataProperties.h
//  
//
//  Created by apptology on 1/19/18.
//
//

#import "Lipid+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Lipid (CoreDataProperties)

+ (NSFetchRequest<Lipid *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cholestrol;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *hdl;
@property (nullable, nonatomic, copy) NSString *lipidid;
@property (nullable, nonatomic, copy) NSString *ldl;
@property (nullable, nonatomic, copy) NSString *lipidunit;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *triglycerides;

@end

NS_ASSUME_NONNULL_END
