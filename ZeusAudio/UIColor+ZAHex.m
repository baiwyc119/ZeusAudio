//
//  UIColor+ZAHex.m
//  ZeusAudio
//
//  Created by lingchen on 12/21/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "UIColor+ZAHex.h"

@implementation UIColor (ZAHex)

+ (UIColor *)za_colorWithHex:(NSUInteger)value
{
    NSInteger red = ((value >> 16) & 0xFF);
    NSInteger green = ((value & 0x00FF00) >> 8);
    NSInteger blue = ((value & 0x0000FF));
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}



@end
