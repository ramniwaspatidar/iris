//
//  SearchTableViewCell.m
//  Iris
//
//  Created by apptology on 05/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundContainerView.layer.cornerRadius = 5.0;
    self.roundContainerView.layer.borderWidth = 1.0;
    self.roundContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundContainerView.clipsToBounds = YES;
    self.clipsToBounds = YES;
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
        
        [self.reminderButton setTitle:[Localization languageSelectedStringForKey:@"Set Reminder"] forState:UIControlStateNormal];
        

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
        
        [self.reminderButton setTitle:[Localization languageSelectedStringForKey:@"Set Reminder"] forState:UIControlStateNormal];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
