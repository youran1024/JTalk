//
//  UIBarButtonExtern.h
//  JRJNews
//
//  Created by Mr.Yang on 14-8-8.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTImageView;
@interface UIBarButtonExtern : NSObject

//  空操作
+ (UIBarButtonItem *)nopBarButtonItem;

//  间距
+ (UIBarButtonItem *)flexSpacerBarButtonItem;

+ (UIBarButtonItem *)closeBarButtonItem:(SEL)selector andTarget:(id)target;

+ (UIBarButtonItem *)buttonWithTitle:(NSString *)title target:(id)target andSelector:(SEL)selector;

+ (UIBarButtonItem *)buttonWithImage:(NSString *)image target:(id)target andSelector:(SEL)selector;

@end
