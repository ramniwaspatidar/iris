//
//  PromotionTableViewCell.m
//  Iris
//
//  Created by apptology on 04/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "PromotionTableViewCell.h"

#import "Localization.h"
#import "MainSideMenuViewController.h"

@implementation PromotionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.valideuptoLbl.text =  [Localization languageSelectedStringForKey:@"Valid Upto"];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
       self.valideuptoLbl.text =  [Localization languageSelectedStringForKey:@"Valid Upto"];
        
    }
    self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
