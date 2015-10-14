//
//  JRJSelectionController.h
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-10-15.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseViewController.h"
#import "HTSeparateView.h"


@protocol JRJSelectionViewDelegate <NSObject>

- (void)jrjSelectionViewRequestData;

@end

/**
 *  导航条切换
 */
@interface HTSelectionController : HTBaseViewController <HTSeparateViewDelegate>
{
    @public
    NSArray *_selectionControllers;
    NSArray *_functionTitles;
    
}

//  导航条
@property (nonatomic, strong)   HTSeparateView *separateView;
//  控制Controller切换的
@property (nonatomic, strong)   UIScrollView *pageScrollView;
//  是否有消息
@property (nonatomic, assign)   BOOL isHaveMessage;

//---------------------------------------------------
//  MARK:dataSource
//---------------------------------------------------
//  导航功能标题
@property (nonatomic, strong)   NSArray *functionTitles;
//  需要切换的Controller
@property (nonatomic, strong)   NSArray *selectionControllers;

//  初始化视图
- (void)initContentSubViewsWithTitleArray:(NSArray *)array;

//  标记消息
- (void)isHaveMessage:(BOOL)isHaveMessage atIndex:(NSInteger)index;

//  选中的ButtonIndex
- (NSInteger)selectedButtonIndex;

@end
