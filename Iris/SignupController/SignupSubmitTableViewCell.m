//
//  SignupSubmitTableViewCell.m
//  Iris
//
//  Created by apptology on 16/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "SignupSubmitTableViewCell.h"
#import "UIButton+CustomButton.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation SignupSubmitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.submitButton setButtonCornerRadious];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.submitButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];
         [self.termConditionButton setTitle:[Localization languageSelectedStringForKey:@"Term & Conditions"] forState:UIControlStateNormal];
        
        _agreeLbl.text =  [Localization languageSelectedStringForKey:@"agree with app's"];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.submitButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];
        [self.termConditionButton setTitle:[Localization languageSelectedStringForKey:@"Term & Conditions"] forState:UIControlStateNormal];
          _agreeLbl.text =  [Localization languageSelectedStringForKey:@"agree with app's"];
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
