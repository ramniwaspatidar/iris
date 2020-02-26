//
//  SideMenuTableViewCell.m
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "SideMenuTableViewCell.h"

@implementation SideMenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImage:(NSString *)imageName forMode:(BOOL)isPrincipleMode {
    NSString *finalImageName = (isPrincipleMode)?imageName:[NSString stringWithFormat:@"%@_dep",imageName];
    __iconImgView.image = [UIImage imageNamed:finalImageName];
}

@end
