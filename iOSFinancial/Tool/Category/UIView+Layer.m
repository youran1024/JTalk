//
//  UIView+Layer.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/6/25.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UIView+Layer.h"

@implementation UIView (Layer)

- (void)borderColors
{
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = HTRedColor.CGColor;
}

- (void)borderColor:(UIColor *)color andWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)cornerRadius5
{
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
}

@end
