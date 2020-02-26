//
//  MainSideMenuViewController.h
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainSideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *_mainTableView;
    NSMutableArray *_menuOptions;
    NSMutableArray *_menuImages;
    NSIndexPath *_selectedIndex;
    BOOL _isDepenndentMenu;

}
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *emiratesidLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;

@property (weak, nonatomic) IBOutlet UIView *dividerView;
+ (void)changeCurrentLanguage;
+ (BOOL)isCurrentLanguageEnglish;
+ (NSBundle *)currentLanguageBundle;
@end
