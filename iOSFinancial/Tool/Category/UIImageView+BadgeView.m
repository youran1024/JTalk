//
//  UIImageView+BadgeView.m
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-10-11.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "UIImageView+BadgeView.h"
#import "MCBadgeView.h"
#import <objc/runtime.h>

#define BadgeViewTag    100010
#define RedPointTag     100011
#define DelPointTag     100012

static char badgeViewDelegate;

@implementation HTBadgeLabel

- (instancetype)initWithNum:(NSInteger)num
{
    self = [super init];
    
    if (self) {
        [self setBadgeNum:num];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = HTRedColor;
        self.textColor = HTWhiteColor;
        self.font = [UIFont systemFontOfSize:13.0f];
        self.textAlignment = NSTextAlignmentCenter;
    }

    return self;
}

- (void)setBadgeNum:(NSInteger)badgeNum
{
    if (_badgeNum != badgeNum) {
        _badgeNum = badgeNum;
        
        [self resizeBadeView:badgeNum];
    }

}

- (void)resizeBadeView:(NSInteger)badgeNum
{
    CGFloat width = 18.0f;
    
    CGPoint center = self.center;

    CGRect frame = self.frame;
    frame.size = CGSizeMake(width, width);
    self.frame = frame;
    
    self.center = center;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width / 2.0f;
    
    if (badgeNum > 99) {
        self.text = @"...";
        
    }else {
        self.text = [NSString stringWithFormat:@"%ld", (long)badgeNum];
    }
}

@end

@implementation UIView (BadgeView)

- (void)showBadgeView:(NSInteger)num
{
    [self removeRedPointView];
    
    HTBadgeLabel *badgeView = [self badgeLabel];
    
    if (!badgeView) {
       badgeView = [self addBadgeView];
    }
    
    badgeView.badgeNum = num;
    badgeView.hidden = num ? NO : YES;

}

- (HTBadgeLabel *)addBadgeView
{
    HTBadgeLabel *badge = [[HTBadgeLabel alloc] init];
    badge.center = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    badge.tag = BadgeViewTag;
    [self addSubview:badge];

    return badge;
}

- (void)removeBadgeView
{
    UIView *view = [self badgeLabel];
    if (view) {
        [view removeFromSuperview];
    }
}

- (UIView *)addRedPointView
{
    CGFloat width = 8.0f;
    HTBadgeLabel *redPoint = [[HTBadgeLabel alloc] init];
    redPoint.tag = RedPointTag;
    
    [self addSubview:redPoint];
    
    redPoint.frame = CGRectMake(0, 0, width, width);
    redPoint.layer.masksToBounds = YES;
    redPoint.layer.cornerRadius = width / 2.0f;
    
    redPoint.center = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    return redPoint;
}

- (void)removeRedPointView
{
    UIView *redPoint = [self redPoint];
    
    if (redPoint) {
        [redPoint removeFromSuperview];
    }
}

- (void)showRedpoint
{
    [self removeBadgeView];
    
    UIView *redPointView = [self redPoint];
    
    if (redPointView) {
        redPointView.hidden = NO;
        
    }else {
        [self addRedPointView];
        
    }
    
}

- (void)showDelPointWithDelegate:(id)delegate
{
    [self removeDelView];
    
    HTDelImageView *imageView = [self delImageViewWithDelegate:delegate];
    [self addSubview:imageView];
    
}

- (void)removeDelView
{
    UIView *view = [self delPoint];
    if (view) {
        [view removeFromSuperview];
    }
}

- (HTDelImageView *)delPoint
{
    return (HTDelImageView *)[self viewWithTag:DelPointTag];
}

- (HTBadgeLabel *)redPoint
{
    return (HTBadgeLabel *)[self viewWithTag:RedPointTag];
}

- (HTBadgeLabel *)badgeLabel
{
    return (HTBadgeLabel *)[self viewWithTag:BadgeViewTag];
}

- (HTDelImageView *)delImageViewWithDelegate:(id)delegate
{
    HTDelImageView *imageView = [[HTDelImageView alloc] initWithDelegate:delegate];
    imageView.userInteractionEnabled = YES;
    UIImage *image = HTImage(@"delPointImage");
    imageView.image = image;
    imageView.tag = DelPointTag;
    imageView.size = CGSizeMake(16, 16);
    imageView.center = CGPointMake(CGRectGetWidth(self.frame), 0);

    return imageView;
}

@end

@implementation HTDelImageView

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        objc_setAssociatedObject(self, &badgeViewDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
    }

    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    id <BadgeViewDelegate> delegate = objc_getAssociatedObject(self, &badgeViewDelegate);
    if (delegate && [delegate respondsToSelector:@selector(didTouchedBadgeView)]) {
        [delegate didTouchedBadgeView];
    }
}

@end

