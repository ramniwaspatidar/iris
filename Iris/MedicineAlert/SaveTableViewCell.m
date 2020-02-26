//
//  SaveTableViewCell.m
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "SaveTableViewCell.h"
#import "UIButton+CustomButton.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation SaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.saveButton setButtonCornerRadious];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];
        _textLbl.text =  [Localization languageSelectedStringForKey:@"Disclaimer: IRIS Health Services LLC will not be in any way responsible for any prescribed dosage missed by the member during the usage of med alert."];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
         _textLbl.text =  [Localization languageSelectedStringForKey:@"Disclaimer: IRIS Health Services LLC will not be in any way responsible for any prescribed dosage missed by the member during the usage of med alert."];
        [self.saveButton setTitle:[Localization languageSelectedStringForKey:@"SAVE"] forState:UIControlStateNormal];
        
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
