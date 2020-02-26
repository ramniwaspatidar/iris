//
//  Localization.m
//  Iris
//
//  Created by Nishant Gupta on 25/05/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import "Localization.h"
#import "LocalizationHeader.h"
int currentLanguage,selectedrow;

@implementation Localization

+(Localization *)sharedInstance
{
    static Localization *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Localization alloc] init];
    });
    return sharedInstance;
}


+(NSString*) strSelectLanguage:(int)curLang{
    if(curLang==THAI){
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil]forKey:@"AppleLanguages"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil]forKey:@"AppleLanguages"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    currentLanguage=curLang;
    NSString *strLangSelect = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return strLangSelect;
}

+(NSString*) languageSelectedStringForKey:(NSString*) key
{
    NSString *path;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    //When we check with iPhone,iPad device it shows "en-US".So we need to change it to "en"
    if([strSelectedLanguage hasPrefix:@"en-"])
        strSelectedLanguage = [strSelectedLanguage stringByReplacingOccurrencesOfString:@"en-US" withString:@"en"];
        if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
            currentLanguage=ENGLISH;
            selectedrow=ENGLISH;
            path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        }
        else{
            currentLanguage=THAI;
            selectedrow=THAI;
            path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
        }
    NSBundle* languageBundle = [NSBundle bundleWithPath:path];
    NSString* str=[languageBundle localizedStringForKey:key value:@"" table:@"Localizable"];
    return str;
}
@end
