//
//  SignupTableViewCell.m
//  Iris
//
//  Created by apptology on 16/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "SignupTableViewCell.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"

@implementation SignupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
      
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
