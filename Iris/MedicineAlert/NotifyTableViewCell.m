//
//  NotifyTableViewCell.m
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "NotifyTableViewCell.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@implementation NotifyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.notifyLbl.text =  [Localization languageSelectedStringForKey:@"Notify"];

        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        self.notifyLbl.text =  [Localization languageSelectedStringForKey:@"Notify"];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
