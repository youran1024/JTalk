//
//  NoneDataView.h
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-11-7.
//  Copyright (c) 2014年 jrj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadingState) {
    LoadingStateLoading = 1,
    LoadingStateNetworkError = 2,
    LoadingStateNoneData = 3,
    LoadingStateNonePreWarining = 4,
    LoadingStateNoneSearch = 5,
    LoadingStateNoneZhiBo = 6,
    LoadingStateNoneAdviserGroup = 7,
    LoadingStateNoneSystemMessage = 8,
    LoadingStateNoneCustome = NSIntegerMax
};

@class LoadingStateView;

typedef void(^ViewTouchBlock)(LoadingStateView *view, LoadingState state);

@interface LoadingStateView : UIView

//  显示的状态
@property (nonatomic, assign)   LoadingState loadingState;
//  显示的图片
@property (nonatomic, strong)   UIImage *image;
//  提示
@property (nonatomic, copy)   NSString *promptStr;
//  允许刷新，默认只允许没网的状态下刷新
@property (nonatomic, assign)   BOOL shouldRefresh;

@property (nonatomic, copy) ViewTouchBlock touchBlock;

@end