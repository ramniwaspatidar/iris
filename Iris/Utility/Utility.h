//
//  Utility.h
//  Iris
//
//  Created by apptology on 28/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User+CoreDataClass.h"
#import "MedicineAlert+CoreDataProperties.h"

@interface Utility : NSObject
+(NSString *)trimString:(NSString*)inputString;
+(void)showAlertViewControllerIn:(UIViewController*)controller title:(NSString*)title message:(NSString*)message block:(void(^)
                                                                                                                        (int sum))block;
+(void)showAlertViewControllerInWindowWithActionNames:(NSArray *)arrActionName title:(NSString*)title message:(NSString*)message block:(void(^) (int tag))block;

#pragma mark - Keyed archiving method
+ (NSData*)archiveData : (NSMutableDictionary*)archivedDictionary;
#pragma mark - Keyed unarchiving method
+ (NSMutableDictionary*)unarchiveData : (NSData*)unarchivedDictionary;

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;
+(void)showErrorMessage:(NSString *)message onViewController:(id)viewController;
+(void)trackGoogleAnalystic:(NSString *)screenName;
+(CGFloat)getLabelHeight:(UILabel*)label;
+(MedicineAlert *)getMedicineAlertForUpcomingDate:(MedicineAlert*)currentMedicineAlert;
+(BOOL) IsiPhoneX;
@end
