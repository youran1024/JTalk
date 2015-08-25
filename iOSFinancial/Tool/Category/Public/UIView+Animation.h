//
//  UIView+Animation.h
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-6.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PopAnchor) {
    PopAnchorTop        = 1,
    PopAnchorBottom     = 1 << 1,
    PopAnchorLeft       = 1 << 2,
    PopAnchorRight      = 1 << 3,
    PopAnchorCenterX    = 1 << 4,
    PopAnchorCenterY    = 1 << 5
};

@interface UIView (Animation)

- (void)popupSubView:(UIView *)view atPosition:(PopAnchor)position;

/** 缩小消失 */
- (void)shrinkDispaerWithDelegate:(id)delegate;

- (void)shrinkDispaerWithDelegate2:(void (^) (void))animationStop1;

- (void)popOutWithDelegate:(id)delegate;

- (void)flashAnimation;

@end
