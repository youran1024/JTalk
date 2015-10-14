//
//  Buttons.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/28.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "Buttons.h"
#import "UIImage+Stretch.h"

@implementation Buttons

+ (UIButton *)buttonWithTitle:(NSString *)title andTarget:(id)target andSelector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *disable = [[UIImage imageNamed:@"InvestButtonDisable"] autoStretchImage];
    UIImage *hight = [[UIImage imageNamed:@"InvestButtonHighlight"] autoStretchImage];
    UIImage *normal = [[UIImage imageNamed:@"InvestButtonNormal"] autoStretchImage];
    
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:hight forState:UIControlStateHighlighted];
    [button setBackgroundImage:disable forState:UIControlStateDisabled];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:@"已售罄" forState:UIControlStateDisabled];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    return button;
}


@end
