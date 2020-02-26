//
//  DashboardTableViewCell.m
//  Iris
//
//  Created by apptology on 02/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
