//
//  UIButton+CustomButton.m
//  Iris
//
//  Created by apptology on 23/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)

-(void)setButtonCornerRadious
{
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor =  [[UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:192.0/255.0 alpha:1] CGColor];
    self.clipsToBounds = YES;
}

@end
