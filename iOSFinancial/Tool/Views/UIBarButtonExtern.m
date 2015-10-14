//
//  UIBarButtonExtern.m
//  JRJNews
//
//  Created by Mr.Yang on 14-8-8.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "UIBarButtonExtern.h"
#import "NSString+Size.h"

#define __IOS7_NAVI_SPACE 15


@implementation UIBarButtonExtern

+ (UIBarButtonItem *)nopBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithCustomView:button];
    flexSpacer.width = __IOS7_NAVI_SPACE;
    
    return flexSpacer;
}

+ (UIBarButtonItem *)flexSpacerBarButtonItem
{
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexSpacer.width = __IOS7_NAVI_SPACE;
    
    return flexSpacer;
}

+ (UIBarButtonItem *)closeBarButtonItem:(SEL)selector andTarget:(id)target
{
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [closeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(0, 0, 36, 20);
    
    return [[UIBarButtonItem alloc] initWithCustomView:closeButton];
}

+ (UIBarButtonItem *)buttonWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor jt_lightBlackTextColor] forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)buttonWithImage:(NSString *)imageStr target:(id)target andSelector:(SEL)selector
{
    UIImage *image = HTImage(imageStr);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button sizeToFit];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
