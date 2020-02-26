//
//  CalloutView.m
//  Iris
//
//  Created by apptology on 18/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "CalloutView.h"

@implementation CalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    
    if (CGRectContainsPoint(self.moveMapButton.frame, touchLocation)) {
            NSLog(@"got point");
        [self.customDelegate calloutClicked:self];

    }
    else if (CGRectContainsPoint(self.setReminderButton.frame, touchLocation)) {
        NSLog(@"got point");
        [self.customDelegate reminderButtonClicked:self.setReminderButton];
    }
    else if (CGRectContainsPoint(self.nextButton.frame, touchLocation)) {
        NSLog(@"got point");
        [self.customDelegate nextButtonClicked:self.nextButton];
    }
  
    
}

@end
