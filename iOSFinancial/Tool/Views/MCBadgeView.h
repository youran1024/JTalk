//
//  MCBadgeLayer.h
//  TextBubbleToturist2
//
//  Created by maomao on 12-12-5.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface MCBadgeView : UIView
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) int badgeNum;
- (id)initWithCenter:(CGPoint)center;
+ (id)newWithCenter:(CGPoint)center;

@end
