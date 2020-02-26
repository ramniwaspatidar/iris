//
//  LanguageChangeViewController.m
//  Iris
//
//  Created by Nishant Gupta on 25/05/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import "LanguageChangeViewController.h"
#import "Localization.h"
#import "LocalizationHeader.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "MainSideMenuViewController.h"
@interface LanguageChangeViewController ()

@end

@implementation LanguageChangeViewController
Localization *localization;

- (void)viewDidLoad {
    [super viewDidLoad];
    localization = [Localization sharedInstance];
   
    [self.englishBtn.layer setCornerRadius:5];
    [self.englishBtn.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.englishBtn.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.englishBtn.layer setShadowOpacity:0.5];
    
    [self.arabicBtn.layer setCornerRadius:5];
    [self.arabicBtn.layer setShadowOffset:CGSizeMake(5, 5)];
    [self.arabicBtn.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [self.arabicBtn.layer setShadowOpacity:0.5];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
 
 if ([MainSideMenuViewController isCurrentLanguageEnglish]){
 [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
 NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
 //exit(0);
 //
 //                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 //
 //
 //                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
 NSLog(@"Arabic");
 
 [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
 }
 else{
 [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
 
 [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
 NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
 //                                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 //
 //
 //                                            [appDelegate performSelector:@selector(showsplashScreenWithDelay:) withObject:nil afterDelay:1.0];//12
 //                                            NSLog(@"English");
 // exit(0);
 }
*/

- (IBAction)changeinArabicCLickedBtn:(id)sender {
    [Localization strSelectLanguage:THAI];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"ar"] forKey:@"AppleLanguages"];
    NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[UIDatePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ar"]];
    [appDelegate performSelector:@selector(showLoginScreenWithDelay:) withObject:nil afterDelay:0.0];//12
}

- (IBAction)changeinEnglishClickedBtn:(id)sender {
    [Localization strSelectLanguage:ENGLISH];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
    NSLocalizedStringFromTableInBundle(@"Localizable", nil, [MainSideMenuViewController currentLanguageBundle], @"comment");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate performSelector:@selector(showLoginScreenWithDelay:) withObject:nil afterDelay:0.0];//12

}
@end
