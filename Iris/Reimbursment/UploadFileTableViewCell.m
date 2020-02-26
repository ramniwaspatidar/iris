//
//  UploadFileTableViewCell.m
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "UploadFileTableViewCell.h"
#import "UIButton+CustomButton.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"
@implementation UploadFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.saveButton setButtonCornerRadious];
    [self.uploadFileButton setButtonCornerRadious];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.uploadFileButton setTitle:[Localization languageSelectedStringForKey:@"UPLOAD PHOTO"] forState:UIControlStateNormal];
        

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        [self.uploadFileButton setTitle:[Localization languageSelectedStringForKey:@"UPLOAD PHOTO"] forState:UIControlStateNormal];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
