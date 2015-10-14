//
//  HTBaseTableViewController.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseTableViewController.h"
#import "LoadMoreCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URLEncoding.h"

@interface HTBaseTableViewController () <UIScrollViewDelegate>

@property (nonatomic, assign)   UITableViewStyle tableViewStyle;

@end

@implementation HTBaseTableViewController

- (void)dealloc
{
    if (_refreshHeaderView) {
        [_refreshHeaderView free];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView free];
    }
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _tableViewStyle = UITableViewStylePlain;
    }
    
    return self;
}

- (id)initWithTableViewStyle:(UITableViewStyle)tableViewStyle
{
    self = [super init];
    
    if (self) {
        _tableViewStyle = tableViewStyle;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //deselect Row
    NSIndexPath *index = [_tableView indexPathForSelectedRow];
    [_tableView deselectRowAtIndexPath:index animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
//    UIView *footerView = [[UIView alloc] init];
//    footerView.height = 64.0f;
//    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewCellSeparatorInsets

- (void)setShowRefreshHeaderView:(BOOL)showRefreshHeaderView
{
    if (_showRefreshHeaderView != showRefreshHeaderView) {
        _showRefreshHeaderView = showRefreshHeaderView;
        if (_showRefreshHeaderView) {
            [self initRefreshView];
        }else {
            [self removeRefreshHeaderView];
        }
    }
}

- (void)setShowRefreshFooterView:(BOOL)showRefreshFooterView
{
    if (_showRefreshFooterView != showRefreshFooterView) {
        _showRefreshFooterView = showRefreshFooterView;
        if (_showRefreshFooterView) {
            [self initFooterView];
        }else {
            [self removeRefreshFooterView];
        }
    }
}

- (void)initRefreshView
{
    [self.refreshHeaderView setScrollView:self.tableView];
    
    __weak HTBaseTableViewController *weakSelf = self;
    [_refreshHeaderView setBeginRefreshingBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewBeginRefresh:refreshView];
    }];
    
    [_refreshHeaderView setEndStateChangeBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewEndRefresh:refreshView];
    }];
}


#pragma mark - endRefresh
- (void)endRefresh
{
    if (_refreshFooterView && _refreshFooterView.isRefreshing) {
        [_refreshFooterView endRefreshing];
    }
    
    if (_refreshHeaderView && _refreshHeaderView.isRefreshing) {
        [_refreshHeaderView endRefreshing];
    }
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    
}

- (void)refreshViewEndRefresh:(MJRefreshBaseView *)baseView
{
    
}

- (void)initFooterView
{
    [self.refreshFooterView setScrollView:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [_refreshFooterView setBeginRefreshingBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewBeginRefresh:refreshView];
    }];
    
    [_refreshFooterView setEndStateChangeBlock:^(MJRefreshBaseView *refreshView){
        [weakSelf refreshViewEndRefresh:refreshView];
    }];

}

- (void)removeRefreshFooterView
{
    [_refreshFooterView removeFromSuperview];
    _refreshFooterView = nil;
}

- (void)removeRefreshHeaderView
{
    [_refreshHeaderView removeFromSuperview];
    _refreshHeaderView = nil;
}

- (MJRefreshHeaderView *)refreshHeaderView
{
    if (!_refreshHeaderView) {
        _refreshHeaderView = [MJRefreshHeaderView header];
        [_refreshHeaderView refreshUpdateTimeLabel];
    }
    
    return _refreshHeaderView;
}

- (MJRefreshFooterView *)refreshFooterView
{
    if (!_refreshFooterView) {
        _refreshFooterView = [MJRefreshFooterView footer];
    }
    
    return _refreshFooterView;
}

#pragma mark tableView

- (UITableView *)tableView
{
    return [self tableViewWithStyle:_tableViewStyle];
}

- (UITableView *)tableViewWithStyle:(UITableViewStyle)tableViewStyle
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:tableViewStyle];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.frame;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        //  去掉空白多余的行
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

#pragma mark - TableViewController Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor jt_backgroudColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HTBaseCell fixedHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
