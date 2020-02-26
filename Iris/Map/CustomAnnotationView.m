//
//  CustomAnnotationView.m
//  Iris
//
//  Created by apptology on 21/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CalloutView.h"

@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    // Return YES if the point is inside an area you want to be touchable
    return YES;
}*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    
    if (!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            
            if (isInside)
            {
                break;
            }
            
        }
    }

    /*if(self.isOpen && !isInside)
    {
        self.isOpen = NO;
        for (UIView *view in self.subviews)
        {
            if([view isKindOfClass:[CalloutView class]])
            {
                [view removeFromSuperview];
            }
        }
    }*/
    return isInside;
}

@end
