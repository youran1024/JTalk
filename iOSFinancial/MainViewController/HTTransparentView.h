//
//  HTTransparentView.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-23.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTTransparentView;
@protocol HTTransparentViewDelegate <NSObject>

- (void)transparentViewDidTaped:(HTTransparentView *)view;

@end


@interface HTTransparentView : UIView

@property (nonatomic, weak) id <HTTransparentViewDelegate>delegate;
@property (nonatomic, copy) void(^touchBlock)(void);

+ (HTTransparentView *)transparentView;

@end
