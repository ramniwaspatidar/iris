//
//  CompleteProfileTableViewCell.m
//  Iris
//
//  Created by apptology on 30/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "CompleteProfileTableViewCell.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation CompleteProfileTableViewCell

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
