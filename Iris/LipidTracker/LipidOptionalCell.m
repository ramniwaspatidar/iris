//
//  LipidOptionalCell.m
//  Iris
//
//  Created by apptology on 30/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "LipidOptionalCell.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"
@implementation LipidOptionalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        self.lipidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Unit"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.lipidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Unit"];
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
