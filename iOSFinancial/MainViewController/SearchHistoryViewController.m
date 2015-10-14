//
//  SearchHistoryViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "TalkListViewController.h"
#import "TalkViewController.h"

@interface SearchHistoryViewController ()

@property (nonatomic, strong)   NSMutableArray *dataArray;

@end

@implementation SearchHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    NSArray *gestures = [self.navigationController.view gestureRecognizers];
    
    for (UIGestureRecognizer *obj in gestures) {
        if ([obj isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            obj.enabled = YES;
        }else if ([obj isKindOfClass:[UIPanGestureRecognizer class]]){
            obj.enabled = NO;
            
        }
    }
    */
    
    self.showRefreshHeaderView = YES;
    
    [self.refreshHeaderView beginRefreshing];
}

- (void)willChangePromptView
{
    self.loadingStateView.promptStr = @"没有搜索记录";
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    [self requestUserSearchList];
}

- (void)requestUserSearchList
{
    HTBaseRequest *request = [HTBaseRequest fetchUserSearchList];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self endRefresh];
        
        NSDictionary *dic = [request responseJSONObject];
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *result = [dic arrayForKey:@"result"];
            [self removeHudInManaual];
            
            if (result.count > 0) {
                [self parseUserSearchList:result];
                [self.tableView reloadData];
            }else {
                [self showLoadingViewWithState:LoadingStateNoneData];
            }
        }
        
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
        [self showLoadingViewWithState:LoadingStateNetworkError];
    }];
}

- (void)parseUserSearchList:(NSArray *)words
{
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:words];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"seachHistoryIdentifier";
    HTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    TalkViewController *conversationVC = [[TalkViewController alloc] init];
    conversationVC.conversationType = ConversationType_GROUP; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = [title toMD5]; // 接收者的 targetId，这里为举例。
    conversationVC.userName = title;
    conversationVC.title = title; // 会话的 title。
    conversationVC.groupTitle = title;
    
    conversationVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *word = [self.dataArray objectAtIndex:indexPath.row];
    [self removeUserSearchWord:word withIndexPath:indexPath];
}

- (void)removeUserSearchWord:(NSString *)word withIndexPath:(NSIndexPath *)indexPath
{
    [self showHudWaitingView:PromptTypeWating];
    
    HTBaseRequest *request = [HTBaseRequest deleteUserSearchWord:word];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dic = [request responseJSONObject];
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        
        if (code == 200) {
            [self removeHudInManaual];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            if (self.dataArray.count == 0) {
                [self showLoadingViewWithState:LoadingStateNoneData];
            }
        }
        
    }];
}

- (void)finishRemove
{

}

- (NSMutableArray *)dataArray
{
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (NSString *)title
{
    return @"搜索历史";
}

@end
