//
//  HTBaseTableViewController.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseViewController.h"
#import "MJRefresh.h"
#import "HTBaseCell.h"
#import "HTBaseTableControl.h"
#import "HTNavigationController.h"


@interface HTBaseTableViewController : HTBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    @package
    UITableView *_tableView;
}

@property (nonatomic, strong)   UITableView *tableView;

@property (nonatomic, strong)   MJRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong)   MJRefreshFooterView *refreshFooterView;

@property (nonatomic, assign)   BOOL showRefreshHeaderView;
@property (nonatomic, assign)   BOOL showRefreshFooterView;

- (id)initWithTableViewStyle:(UITableViewStyle)tableViewStyle;

- (void)endRefresh;

//  refresh标记 (子类重写)
- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView;
- (void)refreshViewEndRefresh:(MJRefreshBaseView *)baseView;

@end
