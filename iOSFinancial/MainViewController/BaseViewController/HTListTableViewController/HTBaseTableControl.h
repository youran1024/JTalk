//
//  HTBaseTableControl.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/31.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTBaseSource.h"
#import "LoadMoreCell.h"
#import "HTActions.h"

@interface HTBaseTableControl : NSObject <UITableViewDataSource, UITableViewDelegate>

//  是否允许加载更多
@property (nonatomic, assign)   BOOL shouldLoadMore;

@property (nonatomic, strong, readonly) LoadMoreCell *loadMoreCell;

@property (nonatomic, copy) HTActionBlock loadMoreActionBlock;

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, assign)   NSInteger pageSize;
@property (nonatomic, assign)   NSInteger pageNum;

//  数据源
@property (nonatomic, strong)   NSArray *sources;

//  没有绑定事件的Cell
- (void)attachNoActionForCellClass:(Class)cls;
- (void)attachHeaderAction:(HTActionBlock)action forCellClass:(Class)cls;
- (void)attachDetailAction:(HTActionBlock)action forCellClass:(Class)cls;
- (void)attachTailAction:(HTActionBlock)action forCellClass:(Class)cls;
- (void)attachOtherAction:(HTActionBlock)action forCellClass:(Class)cls;

//  注册所有用的Cell样式到TableView
- (void)reigitCellClass:(UITableView *)tableView;

@end

@interface HTBaseTableControl ()

/**
 *  绑定Cell用的，禁止重写, 调用
 */
- (void)registTableView:(UITableView *)tableView;

@end
