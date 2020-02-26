//
//  AppointmentEventCell.m
//  Iris
//
//  Created by apptology on 11/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "AppointmentEventCell.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"


@implementation AppointmentEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.mapDirectionButton setTitle:[Localization languageSelectedStringForKey:@"Map View"] forState:UIControlStateNormal];
        

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.mapDirectionButton setTitle:[Localization languageSelectedStringForKey:@"Map View"] forState:UIControlStateNormal];

        
    }
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
