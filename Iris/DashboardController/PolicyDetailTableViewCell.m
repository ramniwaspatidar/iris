//
//  PolicyDetailTableViewCell.m
//  Iris
//
//  Created by apptology on 07/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "PolicyDetailTableViewCell.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation PolicyDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.policyNumberLbl.text =  [Localization languageSelectedStringForKey:@"Policy No."];
        self.stausLbl.text =  [Localization languageSelectedStringForKey:@"Status"];
self.policyPeriodLbl.text =  [Localization languageSelectedStringForKey:@"Policy Period"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.stausLbl.text =  [Localization languageSelectedStringForKey:@"Status"];
        self.policyNumberLbl.text =  [Localization languageSelectedStringForKey:@"Policy No."];
        self.policyPeriodLbl.text =  [Localization languageSelectedStringForKey:@"Policy Period"];
        
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
