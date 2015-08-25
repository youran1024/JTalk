//
//  LoadMoreCell.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"
#import "HTActions.h"

typedef NS_ENUM(NSInteger, CellSate) {
    CellStateReadyLoad = 1,     //准备加载
    CellStateLoading = 2,        //正在加载
    CellStateLoadingError = 3,   //加载失败
    CellStateHaveNoMore = 4      //没有更多了
};

@interface LoadMoreCell : HTBaseCell

@property (nonatomic, assign)   CellSate cellState;
//  是否允许加载
@property (nonatomic, assign, readonly)   BOOL isShouldLoading;

@property (nonatomic, strong)   IBOutlet UILabel *loadingLabel;

@property (nonatomic, strong)   IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong)   IBOutlet UIButton *loadMoreButton;

@property (nonatomic, copy)     HTActionBlock loadMoreActionBlock;

@end
