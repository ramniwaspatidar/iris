//
//  EmiratesIDTableViewCell.m
//  Iris
//
//  Created by apptology on 04/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "EmiratesIDTableViewCell.h"

#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation EmiratesIDTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        _emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID"];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
          _emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        
    } self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
