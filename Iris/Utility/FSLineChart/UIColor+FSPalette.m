//
//  UIColor+FSPalette.m
//  FlurrySummary
//
//  Created by Arthur GUIBERT on 16/07/2014.
//  Copyright (c) 2014 Arthur GUIBERT. All rights reserved.
//

#import "UIColor+FSPalette.h"

@implementation UIColor (FSPalette)

+ (instancetype)fsRed
{
    return [UIColor redColor];
}

+ (instancetype)fsOrange
{
    return [UIColor orangeColor];
}

+ (instancetype)fsYellow
{
    return [UIColor yellowColor];
}

+ (instancetype)fsGreen
{
    return [UIColor greenColor];
}

+ (instancetype)fsLightBlue
{
    return [UIColor blueColor];
}

+ (instancetype)fsDarkBlue
{
    return [UIColor fsDarkBlue];
}

+ (instancetype)fsPurple
{
    return [UIColor purpleColor];
}

+ (instancetype)fsPink
{
    return [UIColor colorWithRed:1.0f green:0.17f blue:0.34f alpha:1.0f];
}

+ (instancetype)fsDarkGray
{
    return [UIColor darkGrayColor];
}

+ (instancetype)fsLightGray
{
    return [UIColor lightGrayColor];
}

@end
