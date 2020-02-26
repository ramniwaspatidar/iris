//
//  UILabel+CustomLabel.m
//  Iris
//
//  Created by apptology on 19/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "UILabel+CustomLabel.h"
#import "Localization.h"
@implementation UILabel (CustomLabel)

-(void)setGestureOnLabel
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberLabelTap)];
    [self addGestureRecognizer:tapGesture];
}
-(void)setGestureOnLabelOMAN
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberLabe2Tap)];
    [self addGestureRecognizer:tapGesture];
}
-(void)phoneNumberLabelTap
{
     NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:048710500"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];

      //  [[UIApplication sharedApplication] loca];
    } else {
        UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil, nil];
        [calert show];
    }
}

-(void)phoneNumberLabe2Tap
{
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:24507345"]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else {
        UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:[Localization languageSelectedStringForKey:@"OK"] otherButtonTitles:nil, nil];
        [calert show];
    }
}
@end
