//
//  Utility.m
//  Iris
//
//  Created by apptology on 28/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "Utility.h"
#import "AppDelegate.h"
#import <Google/Analytics.h>
#import <sys/utsname.h>
#import "MainSideMenuViewController.h"
#import "Localization.h"
@implementation Utility

+(NSString *)trimString:(NSString*)inputString
{
    NSString *trimmedString = [inputString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}

#pragma mark - showAlertController on Window With Buttons

+(void)showAlertViewControllerInWindowWithActionNames:(NSArray *)arrActionName title:(NSString*)title message:(NSString*)message block:(void(^) (int tag))block{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert ];
    
    
    for (int i = 0; i < arrActionName.count; i++) {
        UIAlertAction * action=[ UIAlertAction actionWithTitle:[arrActionName objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(i);
            }
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
    }
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ALERT CONTROLLER WITH ONE BUTTON

+(void)showAlertViewControllerIn:(UIViewController*)controller title:(NSString*)title message:(NSString*)message block:(void(^)
                                                                                                                        (int sum))block
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert ];
    
    UIAlertAction * actionOk=[ UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (block) {
            block(1);
        }
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:actionOk];
    [controller presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Keyed archiving method

+ (NSData*)archiveData : (NSMutableDictionary*)archivedDictionary
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:archivedDictionary];
    return data;
}

#pragma mark - Keyed archiving method

+ (NSMutableDictionary*)unarchiveData:(NSData *)unarchivedDictionary
{
    NSMutableDictionary *data = [NSKeyedUnarchiver unarchiveObjectWithData:unarchivedDictionary];
    return data;
}


+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:0];
    return [UIImage imageWithData:data];
}

+(void)showErrorMessage:(NSString *)message onViewController:(id)viewController
{
    BOOL isSessionExpire = NO;
    if([message isEqualToString:[Localization languageSelectedStringForKey:@"invalid token"]])
    {
        message = [Localization languageSelectedStringForKey:@"Session expired ,Please login"];
        isSessionExpire = YES;
    }
    
    [Utility showAlertViewControllerIn:viewController title:nil message:message block:^(int index) {
        if(isSessionExpire)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate logout];
        }
    }];
}

+(void)trackGoogleAnalystic:(NSString *)screenName
{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

+(CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

+(MedicineAlert *)getMedicineAlertForUpcomingDate:(MedicineAlert*)currentMedicineAlert
{
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
        dateFormatter.dateFormat = @"yyyy/MM/dd hh:mm a";
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
    }else{
        
        [dateFormatter1  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
        dateFormatter1.dateFormat = @"yyyy/MM/dd";
        
        NSMutableArray *comingDaysArray = [[NSMutableArray alloc] init];
        for(NSString *dayName in [currentMedicineAlert.repeat componentsSeparatedByString:@","])
        {
            int dayOfWeek;
            
            if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Sun"]])
            {
                dayOfWeek = 8;
            }
            else if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Mon"]])
            {
                dayOfWeek = 9;
            }
            else if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Tue"]])
            {
                dayOfWeek = 10;
            }
            else if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Wed"]])
            {
                dayOfWeek = 11;
            }
            else if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Thur"]])
            {
                dayOfWeek = 12;
            }
            else if([dayName isEqualToString: [Localization languageSelectedStringForKey:@"Fri"]])
            {
                dayOfWeek = 13;
            }
            else {
                dayOfWeek = 14;
            }
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:now];
            
            NSUInteger weekdayToday = [components weekday];
            NSInteger daysToNextDay = (dayOfWeek - weekdayToday) % 7;
            
            NSDate *nextDayDate = [now dateByAddingTimeInterval:60*60*24*daysToNextDay];
            NSString *dateTimeString = [NSString stringWithFormat:@"%@ %@",[dateFormatter1 stringFromDate:nextDayDate],(NSString*) currentMedicineAlert.time];
            NSDate *nextNewDate = [dateFormatter dateFromString:dateTimeString];
            if(daysToNextDay == 0 && [nextNewDate compare: [NSDate date]] < 0)
            {
                daysToNextDay = 7;
                nextDayDate = [now dateByAddingTimeInterval:60*60*24*daysToNextDay];
            }
            
            NSString *dateStr = [dateFormatter1 stringFromDate:nextDayDate];
            
            NSString *completeDateString = [NSString stringWithFormat:@"%@ %@",dateStr,currentMedicineAlert.time];
            [comingDaysArray addObject:completeDateString];
        }
        
        NSArray *arrKeys2 = [comingDaysArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //NSDateFormatter *df = [[NSDateFormatter alloc] init];
            //[df setDateFormat:@"yyyy/MM/dd"];
            NSString *firstDate = [NSString stringWithFormat:@"%@",obj1];
            NSString *secondDate = [NSString stringWithFormat:@"%@",obj2];
            
            NSDate *d1 = [dateFormatter dateFromString:firstDate];
            NSDate *d2 = [dateFormatter dateFromString:secondDate];
            return [d1 compare: d2];
        }];
        
        [comingDaysArray removeAllObjects];
        [comingDaysArray addObjectsFromArray:arrKeys2];
        
        for(int i = 0; i < comingDaysArray.count; i++)
        {
            NSString *mediDateString = [comingDaysArray objectAtIndex:i];
            NSDate *mediDate = [dateFormatter dateFromString:mediDateString];
            if([mediDate compare: date] >= 0)
            {
                NSString *newDateStr = [dateFormatter1 stringFromDate:mediDate];
                currentMedicineAlert.date = newDateStr;
                break;
            }
        }
        
    return currentMedicineAlert;
}


+(BOOL) IsiPhoneX
{
    static BOOL isiPhoneX = NO;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        NSString *model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        
        struct utsname systemInfo;
        uname(&systemInfo);
        
        NSString *model = [NSString stringWithCString:systemInfo.machine
                                             encoding:NSUTF8StringEncoding];
#endif
        isiPhoneX = [model isEqualToString:@"iPhone10,3"] || [model isEqualToString:@"iPhone10,6"];
    });
    
    return isiPhoneX;
}
@end
