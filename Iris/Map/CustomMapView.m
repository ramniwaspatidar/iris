//
//  CustomMapView.m
//  Iris
//
//  Created by apptology on 26/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "CustomMapView.h"
#import "CustomAnnotationView.h"

@implementation CustomMapView

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
    
    if([touch.view isKindOfClass:[CustomAnnotationView class]])
        self.isDraged = YES;
    
    if ([[touch.view class] isSubclassOfClass:[UIButton class]]) {
        UIButton *label = (UIButton *)touch.view;
        if (CGRectContainsPoint(label.frame, touchLocation)) {
           
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(!self.isDraged)
    {
        [self.customDelegate removeCallout];
    }
    self.isDraged = NO;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    self.isDraged = YES;
    
}



@end
