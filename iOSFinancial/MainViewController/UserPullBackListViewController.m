//
//  UserPullBackListViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/5.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "UserPullBackListViewController.h"
#import "CommitListCell.h"
#import "PersonalViewController.h"
#import "NSDate+BFExtension.h"
#import "UIView+NoneDataView.h"


@interface UserPullBackListViewController ()

@property (nonatomic, strong)   NSMutableArray *users;

@end

@implementation UserPullBackListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self revertNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self revertNavigationBar];
}

- (void)revertNavigationBar
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = HTSTR(@"黑名单");
    
    self.showRefreshHeaderView = YES;
    
    [self requestPullBackList];
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    [self requestPullBackList];
}

- (void)requestPullBackList
{
    HTBaseRequest *request = [HTBaseRequest fetchBlackList];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self removeHudInManaual];
        [self endRefresh];
        
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringForKey:@"code"] integerValue];
        
        if (code == 200) {
            
            NSArray *usersTmp = [dic arrayForKey:@"result"];
            _users = [NSMutableArray arrayWithArray:usersTmp];
            
            [self handlUserRequest:_users];
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
        
    }];
    
}

- (void)handlUserRequest:(NSArray *)users
{
    if (_users.count == 0) {
        [self showNoneDataStateView];
        
    }else {
        [self.view removeNoneDataView];
        [self.tableView reloadData];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"talkFriendsCell";
    CommitListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [CommitListCell newCell];
    }
    
    NSDictionary *user = [self.users objectAtIndex:indexPath.row];
    
    [cell parseWithDic_pullBlack:user];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *userId = [[self.users objectAtIndex:indexPath.row] stringForKey:@"user_id"];
    PersonalViewController *personal = [[PersonalViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    personal.userId = userId;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *user = [self.users objectAtIndex:indexPath.row];
    [self removeUser:user andIndexPath:indexPath];
}

- (void)removeUser:(NSDictionary *)user andIndexPath:(NSIndexPath *)indexPath
{
    [self showHudWaitingView:PromptTypeWating];
    
    HTBaseRequest *request = [HTBaseRequest removeUserFromBlackList:[user stringForKey:@"user_id"]];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dic = [request responseJSONObject];
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        
        if (code == 200) {
            [self removeHudInManaual];
            [self.users removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            if (self.users.count == 0) {
                [self showNoneDataStateView];
            }
        }
        
    }];
}

- (void)showNoneDataStateView
{
    LoadingStateView *view = [self.view showNoneDataView];
    view.promptStr = @"没有任何人";
}

@end
