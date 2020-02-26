//
//  NotificationTableViewCell.m
//  Iris
//
//  Created by Deepak on 1/25/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect adjustedFrame = self.accessoryView.frame;
    adjustedFrame.origin.x += 15.0f;
    self.accessoryView.frame = adjustedFrame;
    
    

}

@end
