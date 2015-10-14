//
//  HTCircleView.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/2.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCircleView;

typedef void(^CircleViewTouchBlock)(HTCircleView *view);

@interface HTCircleView : UIView

@property (nonatomic, copy) CircleViewTouchBlock touchBlock;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) CGFloat persent;

@end
