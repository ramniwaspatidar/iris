//
//  User+CoreDataProperties.h
//  Iris
//
//  Created by apptology on 11/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//
//

#import "User+CoreDataClass.h"
#import "AppointmentReminder+CoreDataProperties.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *defaultpolicyholder;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *emiratesid;
@property (nullable, nonatomic, copy) NSString *fullname;
@property (nullable, nonatomic, copy) NSString *gender;
@property (nullable, nonatomic, copy) NSString *insurancecompany;
@property (nullable, nonatomic, copy) NSString *memberid;
@property (nullable, nonatomic, copy) NSString *mobileno;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *nationality;
@property (nullable, nonatomic, copy) NSString *passportno;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *profileimage;
@property (nullable, nonatomic, copy) NSString *residence;
@property (nullable, nonatomic, copy) NSString *token;
@property (nullable, nonatomic, retain) NSSet<Dependent *> *depend;
@property (nullable, nonatomic, retain) PolicyDetails *policydetail;
@property (nullable, nonatomic, retain) NSSet<AppointmentReminder *> *appointmentreminder;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addDependObject:(Dependent *)value;
- (void)removeDependObject:(Dependent *)value;
- (void)addDepend:(NSSet<Dependent *> *)values;
- (void)removeDepend:(NSSet<Dependent *> *)values;

- (void)addAppointmentreminderObject:(AppointmentReminder *)value;
- (void)removeAppointmentreminderObject:(AppointmentReminder *)value;
- (void)addAppointmentreminder:(NSSet<AppointmentReminder *> *)values;
- (void)removeAppointmentreminder:(NSSet<AppointmentReminder *> *)values;

@end

NS_ASSUME_NONNULL_END
