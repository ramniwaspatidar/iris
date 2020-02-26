//
//  ProfileImageTableViewCell.m
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "ProfileImageTableViewCell.h"

@implementation ProfileImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.width/2;
    self.profileImageButton.clipsToBounds = YES;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    
    self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
