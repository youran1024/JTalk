//
//  UIImageView+BadgeView.h
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-10-11.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  头像上加红点， 加未读消息
 */


@protocol BadgeViewDelegate <NSObject>

- (void)didTouchedBadgeView;

@end

@class HTDelImageView;
@class HTBadgeLabel;
@interface UIView (BadgeView)

//  未读消息条数
- (void)showBadgeView:(NSInteger)num;
- (void)removeRedPointView;
//  不带条数
- (void)showRedpoint;

//  显示删除按钮
- (void)showDelPointWithDelegate:(id)delegate;

- (HTBadgeLabel*)badgeLabel;
- (HTBadgeLabel *)redPoint;
- (HTDelImageView *)delImageViewWithDelegate:(id)delegate;

@end

@interface HTBadgeLabel : UILabel

@property (nonatomic, assign)   NSInteger badgeNum;

@end

@interface HTDelImageView : UIImageView

- (instancetype)initWithDelegate:(id)delegate;

@end

