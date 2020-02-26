//
//  ProviderNetworkTableViewCell.m
//  Iris
//
//  Created by apptology on 08/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ProviderNetworkTableViewCell.h"
 #import "Localization.h"
#import "MainSideMenuViewController.h"

@implementation ProviderNetworkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        [self.directionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];


    }
    else{

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
           [self.directionButton setTitle:[Localization languageSelectedStringForKey:@"Direction"] forState:UIControlStateNormal];
        [self.directionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.directionButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 20, 0);
        self.directionButton.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, -20);
    }
    self.roundCornerView.layer.cornerRadius = 5.0;
    self.roundCornerView.layer.borderWidth = 1.0;
    self.roundCornerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundCornerView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
