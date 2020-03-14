//
//  ViewYourECardViewController.m
//  Iris
//
//  Created by appt on 15/02/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import "ViewYourECardViewController.h"
#import "RevealViewController.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "Localization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainSideMenuViewController.h"
#import "Constant.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ConnectionManager.h"
#import "DbManager.h"
#import "AppDelegate.h"

@interface ViewYourECardViewController () {
    
    NSArray *coloum1Array;
    NSArray *coloum2Array;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *r1C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r2C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r3C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r4C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r5C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r6C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r7C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r8C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r9C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r10C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r11C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r12C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r13C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r14C1Label;
@property (weak, nonatomic) IBOutlet UILabel *r15C1Label;

@property (weak, nonatomic) IBOutlet UILabel *r1C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r2C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r3C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r4C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r5C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r6C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r7C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r8C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r9C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r10C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r11C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r12C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r13C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r14C2Label;
@property (weak, nonatomic) IBOutlet UILabel *r15C2Label;

@property (weak, nonatomic) IBOutlet UILabel *footerTitle1;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@end

@implementation ViewYourECardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];
    _eCardInfoDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"policyInfoDictionary"]];
    
    NSDictionary * dict = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"dependentsDictionary"]];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *activeDependent = appDelegate.memberId;
    
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *dependentmemberid = [userInfoDic valueForKey:@"dependentmemberid"];
    
    
    for (NSDictionary *dependentUser in [dict valueForKey:@"dependents"]) {
        if([dependentmemberid isEqualToString:[dependentUser valueForKey:@"memberid"]] && activeDependent && ![activeDependent isEqualToString:@""]) {
            [self updateECardInfo:dependentUser];
            return;
        }
        else
        {
            [self updateECardInfo:_eCardInfoDetailDictionary];
        }
    }
    
    
    
}



- (void)updateECardInfo:(NSDictionary *)dict {
    NSArray *eCardInfoArray = [dict valueForKey:@"eCardInfo"];
    NSString *myString1 = @",1";
    NSString *myString2 = @",2";
    
    // For Set Image in ImageView
    NSArray *bgImage = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"backgroundimage"]];
    NSArray *leftLogo = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"leftlogo"]];
    NSArray *rightLogo = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"rightlogo"]];
    NSArray *mainTitle = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"maintitle"]];
    NSArray *footerTitle1 = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"footernote"]];
    NSArray *noteLabel = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(keyword contains[c] %@)", @"cardnote"]];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[[bgImage objectAtIndex:0]valueForKey:@"fieldvalue"]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    [self.leftLogoImageView sd_setImageWithURL:[NSURL URLWithString:[[leftLogo objectAtIndex:0]valueForKey:@"fieldvalue"]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    [self.rightLogoImageView sd_setImageWithURL:[NSURL URLWithString:[[rightLogo objectAtIndex:0]valueForKey:@"fieldvalue"]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    //========================
    
    // For Set MainTitle, note card and footer note
    NSString *removeBrTag = [[footerTitle1 objectAtIndex:0]valueForKey:@"fieldvalue"];
    removeBrTag = [removeBrTag stringByReplacingOccurrencesOfString:@"<br>"
                                                         withString:@"\n"];
    self.mainTitleLabel.text = [[mainTitle objectAtIndex:0]valueForKey:@"fieldvalue"];
    
    NSString *noteString = [self notNull:[[noteLabel objectAtIndex:0]valueForKey:@"fieldvalue"]];
    noteString = [noteString stringByReplacingOccurrencesOfString:@"&nbsp;"
                                                       withString:@" "];
    
    
    // [self notNull:[[[noteLabel objectAtIndex:0]valueForKey:@"fieldvalue"]]]
    self.noteLabel.text = noteString;
    self.footerTitle1.text = removeBrTag;
    //========================
    
    // For Row And Coloum Seperation
    NSArray *filteredDataForColoum1 = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(position contains[c] %@)", myString1]];
    NSArray *filteredDataForColoum2 = [eCardInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(position contains[c] %@)", myString2]];
    
    NSMutableArray *coloum1DataArray = [[NSMutableArray alloc] initWithArray:filteredDataForColoum1];
    NSMutableArray *coloum2DataArray = [[NSMutableArray alloc] initWithArray:filteredDataForColoum2];
    
    for (int i=0; i < coloum1DataArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:coloum1DataArray[i]];
        NSString *str = [dict valueForKey:@"position"];
        str = [str stringByReplacingOccurrencesOfString:myString2
                                             withString:@""];
        int intValue = str.intValue;
        NSNumber *newNum = [NSNumber numberWithInt:intValue];
        [dict setObject:newNum forKey:@"position"];
        NSDictionary *item = dict;
        [coloum1DataArray replaceObjectAtIndex:i withObject:item];
    }
    
    for (int i=0; i < coloum2DataArray.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:coloum2DataArray[i]];
        NSString *str = [dict valueForKey:@"position"];
        str = [str stringByReplacingOccurrencesOfString:myString2
                                             withString:@""];
        int intValue = str.intValue;
        NSNumber *newNum = [NSNumber numberWithInt:intValue];
        [dict setObject:newNum forKey:@"position"];
        NSDictionary *item = dict;
        [coloum2DataArray replaceObjectAtIndex:i withObject:item];
    }
    // ===================================
    
    // For Sorting
    NSArray *c1 = coloum1DataArray;
    NSArray *c2 = coloum2DataArray;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    coloum1Array = [c1 sortedArrayUsingDescriptors:sortDescriptors];
    coloum2Array = [c2 sortedArrayUsingDescriptors:sortDescriptors];
    // =================================
    
    // Set Api data For Coloum 1
    self.r1C1Label.attributedText = coloum1Array.count > 0 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:0]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:0]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:0]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r2C1Label.attributedText = coloum1Array.count > 1 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:1]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:1]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:1]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r3C1Label.attributedText = coloum1Array.count > 2 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:2]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:2]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:2]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r4C1Label.attributedText = coloum1Array.count > 3 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:3]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:3]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:3]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r5C1Label.attributedText = coloum1Array.count > 4 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:4]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:4]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:4]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r6C1Label.attributedText = coloum1Array.count > 5 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:5]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:5]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:5]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r7C1Label.attributedText = coloum1Array.count > 6 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:6]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:6]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:6]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r8C1Label.attributedText = coloum1Array.count > 7 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:7]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:7]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:7]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r9C1Label.attributedText = coloum1Array.count > 8 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:8]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:8]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:8]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r10C1Label.attributedText = coloum1Array.count > 9 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:9]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:9]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:9]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r11C1Label.attributedText = coloum1Array.count > 10 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:10]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:10]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:10]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r12C1Label.attributedText = coloum1Array.count > 11 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:11]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:11]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:11]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r13C1Label.attributedText = coloum1Array.count > 12 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:12]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:12]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:12]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r14C1Label.attributedText = coloum1Array.count > 13 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:13]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:13]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:13]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r15C1Label.attributedText = coloum1Array.count > 14 ? [self convertAttributedString:[self notNull:[[coloum1Array objectAtIndex:14]valueForKey:@"fieldname"]] with:[self notNull:[[coloum1Array objectAtIndex:14]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum1Array objectAtIndex:14]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    
    
    // Set Api data For Coloum 2
    self.r1C2Label.attributedText = coloum2Array.count > 0 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:0]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:0]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:0]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r2C2Label.attributedText = coloum2Array.count > 1 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:1]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:1]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:1]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r3C2Label.attributedText = coloum2Array.count > 2 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:2]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:2]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:2]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r4C2Label.attributedText = coloum2Array.count > 3 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:3]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:3]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:3]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r5C2Label.attributedText = coloum2Array.count > 4 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:4]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:4]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:4]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r6C2Label.attributedText = coloum2Array.count > 5 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:5]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:5]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:5]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r7C2Label.attributedText = coloum2Array.count > 6 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:6]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:6]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:6]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r8C2Label.attributedText = coloum2Array.count > 7 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:7]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:7]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:7]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r9C2Label.attributedText = coloum2Array.count > 8 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:8]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:8]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:8]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r10C2Label.attributedText = coloum2Array.count > 9 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:9]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:9]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:9]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r11C2Label.attributedText = coloum2Array.count > 10 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:10]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:10]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:10]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r12C2Label.attributedText = coloum2Array.count > 11 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:11]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:11]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:11]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r13C2Label.attributedText = coloum2Array.count > 12 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:12]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:12]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:12]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r14C2Label.attributedText = coloum2Array.count > 13 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:13]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:13]valueForKey:@"fieldvalue"]] andColor:[self notNull:[[coloum2Array objectAtIndex:13]valueForKey:@"textcolor"]]] : [[NSAttributedString alloc] initWithString:@""];
    self.r15C2Label.attributedText = coloum2Array.count > 14 ? [self convertAttributedString:[self notNull:[[coloum2Array objectAtIndex:14]valueForKey:@"fieldname"]] with:[self notNull:[[coloum2Array objectAtIndex:14]valueForKey:@"fieldvalue"]] andColor:[self notNull:[self notNull:[[coloum2Array objectAtIndex:14]valueForKey:@"textcolor"]]]] : [[NSAttributedString alloc] initWithString:@""];
    // =================================
    
    
    /*
     self.r4C1Label.text = coloum1Array.count > 3 ? [[self notNull:[[coloum1Array objectAtIndex:3]valueForKey:@"fieldname"]]  stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:3]valueForKey:@"fieldvalue"]]] : @"";
     self.r5C1Label.text = coloum1Array.count > 4 ? [[self notNull:[[coloum1Array objectAtIndex:4]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:4]valueForKey:@"fieldvalue"]]] : @"";
     self.r6C1Label.text = coloum1Array.count > 5 ? [[self notNull:[[coloum1Array objectAtIndex:5]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:5]valueForKey:@"fieldvalue"]]] : @"";
     self.r7C1Label.text = coloum1Array.count > 6 ? [[self notNull:[[coloum1Array objectAtIndex:6]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:6]valueForKey:@"fieldvalue"]]] : @"";
     self.r8C1Label.text = coloum1Array.count > 7 ? [[self notNull:[[coloum1Array objectAtIndex:7]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:7]valueForKey:@"fieldvalue"]]] : @"";
     self.r9C1Label.text = coloum1Array.count > 8 ? [[self notNull:[[coloum1Array objectAtIndex:8]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:8]valueForKey:@"fieldvalue"]]] : @"";
     self.r10C1Label.text = coloum1Array.count > 9 ? [[self notNull:[[coloum1Array objectAtIndex:9]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:9]valueForKey:@"fieldvalue"]]] : @"";
     self.r11C1Label.text = coloum1Array.count > 10 ? [[self notNull:[[coloum1Array objectAtIndex:10]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:10]valueForKey:@"fieldvalue"]]] : @"";
     self.r12C1Label.text = coloum1Array.count > 11 ? [[self notNull:[[coloum1Array objectAtIndex:11]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:11]valueForKey:@"fieldvalue"]]] : @"";
     self.r13C1Label.text = coloum1Array.count > 12 ? [[self notNull:[[coloum1Array objectAtIndex:12]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:12]valueForKey:@"fieldvalue"]]] : @"";
     self.r14C1Label.text = coloum1Array.count > 13 ? [[self notNull:[[coloum1Array objectAtIndex:13]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:13]valueForKey:@"fieldvalue"]]] : @"";
     self.r15C1Label.text = coloum1Array.count > 14 ? [[self notNull:[[coloum1Array objectAtIndex:14]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum1Array objectAtIndex:14]valueForKey:@"fieldvalue"]]] : @"";
     self.r1C2Label.text = coloum2Array.count > 0 ? [[self notNull:[[coloum2Array objectAtIndex:0]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:0]valueForKey:@"fieldvalue"]]] : @"";
     self.r2C2Label.text = coloum2Array.count > 1 ? [[self notNull:[[coloum2Array objectAtIndex:1]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:1]valueForKey:@"fieldvalue"]]] : @"";
     self.r3C2Label.text = coloum2Array.count > 2 ? [[self notNull:[[coloum2Array objectAtIndex:2]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:2]valueForKey:@"fieldvalue"]]] : @"";
     self.r4C2Label.text = coloum2Array.count > 3 ? [[self notNull:[[coloum2Array objectAtIndex:3]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:3]valueForKey:@"fieldvalue"]]] : @"";
     self.r5C2Label.text = coloum2Array.count > 4 ? [[self notNull:[[coloum2Array objectAtIndex:4]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:4]valueForKey:@"fieldvalue"]]] : @"";
     self.r6C2Label.text = coloum2Array.count > 5 ? [[self notNull:[[coloum2Array objectAtIndex:5]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:5]valueForKey:@"fieldvalue"]]] : @"";
     self.r7C2Label.text = coloum2Array.count > 6 ? [[self notNull:[[coloum2Array objectAtIndex:6]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:6]valueForKey:@"fieldvalue"]]] : @"";
     self.r8C2Label.text = coloum2Array.count > 7 ? [[self notNull:[[coloum2Array objectAtIndex:7]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:7]valueForKey:@"fieldvalue"]]] : @"";
     self.r9C2Label.text = coloum2Array.count > 8 ? [[self notNull:[[coloum2Array objectAtIndex:8]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:8]valueForKey:@"fieldvalue"]]] : @"";
     self.r10C2Label.text = coloum2Array.count > 9 ? [[self notNull:[[coloum2Array objectAtIndex:9]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:9]valueForKey:@"fieldvalue"]]] : @"";
     self.r11C2Label.text = coloum2Array.count > 10 ? [[self notNull:[[coloum2Array objectAtIndex:10]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:10]valueForKey:@"fieldvalue"]]] : @"";
     self.r12C2Label.text = coloum2Array.count > 11 ? [[self notNull:[[coloum2Array objectAtIndex:11]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:11]valueForKey:@"fieldvalue"]]] : @"";
     self.r13C2Label.text = coloum2Array.count > 12 ? [[self notNull:[[coloum2Array objectAtIndex:12]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:12]valueForKey:@"fieldvalue"]]] : @"";
     self.r14C2Label.text = coloum2Array.count > 13 ? [[self notNull:[[coloum2Array objectAtIndex:13]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:13]valueForKey:@"fieldvalue"]]] : @"";
     self.r15C2Label.text = coloum2Array.count > 14 ? [[self notNull:[[coloum2Array objectAtIndex:14]valueForKey:@"fieldname"]] stringByAppendingString:[self notNull:[[coloum2Array objectAtIndex:14]valueForKey:@"fieldvalue"]]] : @"";
     
     */
    // ===============================
}

- (NSString*)notNull:(NSString *)title {
    
    if (title == (id)[NSNull null] || title.length == 0 ) title = @"";
    
    return title;
}

-(NSAttributedString*)convertAttributedString:(NSString*)fieldNameStr with:(NSString*)fieldValueStr andColor:(NSString*)colorStr{
    
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *newAttString1 = [[NSAttributedString alloc] initWithString:fieldNameStr];
    NSAttributedString *newAttString2 = [self changeTextColor:fieldValueStr andColor:colorStr];
    
    [mutableAttString appendAttributedString:newAttString1];
    [mutableAttString appendAttributedString:newAttString2];
    return mutableAttString;
}

- (NSAttributedString*)changeTextColor:(NSString*)str andColor:(NSString*)colorStr {
    
    NSString *string = [@" " stringByAppendingString:str];
    
    UIColor *color = colorStr.length > 0 ? [self colorFromHexString:colorStr] : [UIColor blackColor];
    NSDictionary *attrs = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:10.0] ,NSForegroundColorAttributeName : color};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
    return attrStr;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    if(self.personDetailDictionary)
        [self.personDetailDictionary removeAllObjects];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES]; // or NO to disable rotation
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    [appDelegate setIsViewYourCard:YES];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setIsViewYourCard:NO];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if (![appDelegate isViewYourCard]) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate setShouldRotate:NO]; // or NO to disable rotation
        
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialSetupView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [sideMenuBtnOutlet addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        ecartLbl.text =  [Localization languageSelectedStringForKey:@"E-Card"];
        footerLbl.text =  [Localization languageSelectedStringForKey:@"To verify the member kindly log on to www.iris.healthcare"];
        
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
        ecartLbl.text =  [Localization languageSelectedStringForKey:@"E-Card"];
        footerLbl.text =  [Localization languageSelectedStringForKey:@"To verify the member kindly log on to www.iris.healthcare"];
        [sideMenuBtnOutlet addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
}

-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    
    [self getEcardPDFUrl];
    //    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    //    notificationVC.personDetailDictionary = self.personDetailDictionary;
    //    [self.navigationController pushViewController:notificationVC animated:YES];
}


-(void)getEcardPDFUrl
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetEcardPdfUrl"];
    NSMutableDictionary *dictionary1 = [[NSMutableDictionary alloc] init];
    
    NSString *memberId = [userInfoDic valueForKey:@"memberid"];
    [dictionary1 setValue:memberId forKey:@"memberid"];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary1 options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                if([[serverMsg lowercaseString] isEqualToString:@"success"])
                {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ecard.pdf"];
                    
                    if ([self checkFileExistAtPath:path]){
                        //                         [self pdfSucessAlert:[NSString stringWithFormat:@"file:///%@",path]];
                    }
                    
                    NSDictionary *dict = [responseDictionary valueForKey:@"pdfUrl"];
                    NSString *pdfUrl = [dict valueForKey:@"pdfUrl"];
                    [self performSegueWithIdentifier:kdownloadEcardSegue sender:pdfUrl];
                    
                    //                     else{
                    //                     NSDictionary *dict = [responseDictionary valueForKey:@"pdfUrl"];
                    //                     NSString *pdfUrl = [dict valueForKey:@"pdfUrl"];
                    //                     [self performSegueWithIdentifier:kdownloadEcardSegue sender:pdfUrl];
                    //                 }
                }
                else
                {
                    [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                    }];
                }
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kdownloadEcardSegue])
    {        ECardViewController *eCardViewController = segue.destinationViewController;
        eCardViewController.pdfUrl = [NSString stringWithFormat:@"%@",sender];
        eCardViewController.downloadDelegate = self;
    }
}

-(void)saveDownloadFile:(NSURL*) url{
    NSLog(@"test");
    [self pdfSucessAlert:[NSString stringWithFormat:@"%@",url]];
    
}

- (BOOL)checkFileExistAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        [fileManager removeItemAtPath:path error:NULL];
        return YES;
    }
    return NO;
}


-(void)pdfSucessAlert:(NSString *)path
{
    NSString *location = [NSString stringWithFormat:@"%@: %@",[Localization languageSelectedStringForKey:@"Location"],path];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"Download"] message:location preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *openFile = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"OPEN FILE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
        
        UIDocumentInteractionController *documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:path]];
        documentInteractionController.delegate = self;
        [documentInteractionController presentPreviewAnimated:YES];
    }];
    
    [alertController addAction:openFile];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

//-(void)getEcardPDFUrl
//{
//    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
//    NSString *memberId = [userInfoDic valueForKey:@"memberid"];
//
//    NSString *url = [NSString stringWithFormat:@"%@%@?memberId=%@",kAPIBaseURL,@"GetEcardPdfUrl",memberId];
//
//
//    [[ConnectionManager sharedInstance] sendGETRequestForURL:url withHeader:[userInfoDic valueForKey:@"token"]  timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
//     {
//         if (!error)
//         {
//             dispatch_async(dispatch_get_main_queue(), ^{
//
//                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
//                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
//                 {
//                     NSLog(@"%@",dictionary);
//                     [DownloadEcard getPDFFile:@""];
//
//                 }
//                 else
//                 {
//                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
//                     }];
//                 }
//             });
//         }
//         else
//         {
//             dispatch_async(dispatch_get_main_queue(), ^{
//
//             });
//         }
//     }];
//}
@end
