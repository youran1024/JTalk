//
//  LoadMoreCell.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

+ (HTBaseCell *)newCell
{
    LoadMoreCell *cell = (LoadMoreCell *)[super newCell];
    [cell initCell];
    
    return cell;
}

- (void)initCell
{
    self.cellState = CellStateReadyLoad;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.loadMoreButton setTitleColor:HTHexColor(0x595959) forState:UIControlStateNormal];
    self.loadingLabel.textColor = HTHexColor(0x595959);
}

+ (CGFloat)fixedHeight
{
    return 53.0f;
}

- (BOOL)isLoading
{
    return self.cellState == CellStateLoading;
}

- (BOOL)isShouldLoading
{
    return self.cellState == CellStateReadyLoad;
}

- (void)setCellState:(CellSate)cellState
{
    if (cellState != _cellState) {
        _cellState = cellState;
        if (cellState == CellStateLoading) {
            //加载中
            _loadingLabel.hidden = NO;
            _indicatorView.hidden = NO;
            _loadMoreButton.hidden = YES;
            [_indicatorView startAnimating];
            
        }else if (cellState == CellStateLoadingError){
            //加载错误，重新加载
            _loadingLabel.hidden = YES;
            _indicatorView.hidden = YES;
            _loadMoreButton.hidden = NO;
            [_loadMoreButton setTitle:@"网络连接异常，请点击再试" forState:UIControlStateNormal];
            [_loadMoreButton addTarget:self action:@selector(loadMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (cellState == CellStateHaveNoMore){
            //没有更多了
            _loadingLabel.hidden = YES;
            _indicatorView.hidden = YES;
            _loadMoreButton.hidden = NO;
            [_loadMoreButton setTitle:@"没有更多了" forState:UIControlStateNormal];
            [_loadMoreButton removeTarget:self action:@selector(loadMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            //  readyLoading
            _loadingLabel.hidden = YES;
            _indicatorView.hidden = YES;
            _loadMoreButton.hidden = NO;
            [_loadMoreButton setTitle:@"准备加载" forState:UIControlStateNormal];
        }
    }
}

- (void)loadMoreButtonClicked:(UIButton *)button
{
    self.cellState = CellStateLoading;
    
    if (_loadMoreActionBlock) {
        _loadMoreActionBlock (nil, self, nil);
    }
}

@end
