//
//  HTSelectionView.h
//  JRJNews
//
//  Created by Mr.Yang on 14-8-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface HTSelectionView : HTBaseView

@property (nonatomic, strong)   NSArray *rowArray;

@property (nonatomic, assign, readonly) CGFloat sectionHeight;

@property (nonatomic, copy)   void(^touchedBlock)(BOOL isSelect);
@property (nonatomic, copy)   void(^selectionBlock)(NSInteger index);

// 用来判断是否是可以改变视图
@property (nonatomic, copy)   BOOL(^shouldChangeVCBlock)(NSInteger index);

/**
 *  关闭下滑视图
 */
- (void)closeSplipView;

/**
 *  要显示的视图
 *  @param index 视图所在位置索引
 */
- (void)presentViewControllerAtIndex:(NSInteger)index;

@end
