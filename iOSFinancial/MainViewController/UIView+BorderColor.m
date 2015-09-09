//
//  UIView+BorderColor.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/25.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UIView+BorderColor.h"

@implementation UIView (BorderColor)

- (void)borderWidth:(CGFloat)width andBorderColor:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)borderRandamColor
{
    self.layer.borderColor = [UIColor randomColor].CGColor;
    self.layer.borderWidth = 4.0f;
}

@end
