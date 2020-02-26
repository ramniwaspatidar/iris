//
//  Dependent+CoreDataProperties.h
//  Iris
//
//  Created by apptology on 13/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "Dependent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Dependent (CoreDataProperties)

+ (NSFetchRequest<Dependent *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *emiratesid;
@property (nullable, nonatomic, copy) NSString *parentemiratesid;
@property (nullable, nonatomic, copy) NSString *fullname;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *nationality;
@property (nullable, nonatomic, copy) NSString *passport;
@property (nullable, nonatomic, copy) NSString *principalmemberid;
@property (nullable, nonatomic, copy) NSString *relation;
@property (nullable, nonatomic, copy) NSString *residence;
@property (nullable, nonatomic, copy) NSString *profileimage;

@end

NS_ASSUME_NONNULL_END
