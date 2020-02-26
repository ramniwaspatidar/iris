//
//  Localization.h
//  Iris
//
//  Created by Nishant Gupta on 25/05/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Localization : NSObject
+(Localization *)sharedInstance;
+(NSString*) strSelectLanguage:(int)curLang;
+(NSString*) languageSelectedStringForKey:(NSString*) key;

@end

NS_ASSUME_NONNULL_END
