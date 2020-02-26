//
//  BloodSugarButtonTableViewCell.m
//  Iris
//
//  Created by apptology on 29/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "BloodSugarButtonTableViewCell.h"
#import "UIButton+CustomButton.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"


@implementation BloodSugarButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.viewStatesButton setButtonCornerRadious];
    [self.saveButton setButtonCornerRadious];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.viewStatesButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"]
                               forState:UIControlStateNormal];
        
        [self.saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"]
                               forState:UIControlStateNormal];
        

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.viewStatesButton setTitle:[Localization languageSelectedStringForKey:@"VIEW STATS"]
                               forState:UIControlStateNormal];
        
        [self.saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"]
                         forState:UIControlStateNormal];
        

        
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
