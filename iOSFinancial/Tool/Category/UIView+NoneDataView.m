//
//  UIView+NoneDataView.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/6/25.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UIView+NoneDataView.h"
#import "LoadingStateView.h"

#define LoadingStateViewTag    10086

@implementation UIView (NoneDataView)

- (LoadingStateView *)showNoneDataView
{
    LoadingStateView * view = [self loadingStateView];
    [self addSubview:view];
    
    return view;
}

- (void)removeNoneDataView
{
    UIView *view = [self viewWithTag:LoadingStateViewTag];
    [view removeFromSuperview];
}

- (LoadingStateView *)loadingStateView
{
    LoadingStateView *view = [[LoadingStateView alloc] initWithFrame:self.bounds];
    view.tag = LoadingStateViewTag;
    view.image = HTImage(@"nonedataImage");
    view.promptStr = @"没有任何会话";
    view.backgroundColor = [UIColor clearColor]; //[UIColor colorWithHEX:0xcccccc];
    [view setLoadingState:LoadingStateNoneCustome];
    
    return view;
}

@end
