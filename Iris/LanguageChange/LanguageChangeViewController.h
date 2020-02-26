//
//  LanguageChangeViewController.h
//  Iris
//
//  Created by Nishant Gupta on 25/05/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Localization.h"

NS_ASSUME_NONNULL_BEGIN

@interface LanguageChangeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *englishBtn;
@property (weak, nonatomic) IBOutlet UIButton *arabicBtn;
- (IBAction)changeinArabicCLickedBtn:(id)sender;

- (IBAction)changeinEnglishClickedBtn:(id)sender;
@end

NS_ASSUME_NONNULL_END
