//
//  UIImageView+CustomImageView.m
//  Iris
//
//  Created by Deepak on 2/9/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "UIImageView+CustomImageView.h"
#import "Localization.h"
@implementation UIImageView(CustomImageView)

-(void)setGestureOnImageView
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberLabelTap)];
    [self addGestureRecognizer:tapGesture];
}

-(void)phoneNumberLabelTap
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:80047474"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil, nil];
        [calert show];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
