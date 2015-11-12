//
//  CommitListViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "CommitListViewController.h"
#import "CommitListCell.h"
#import "PersonalViewController.h"
#import "NSString+BFExtension.h"
#import "NSDate+BFExtension.h"
#import "UIBarButtonExtern.h"


@interface CommitListViewController () <UIActionSheetDelegate>

@property (nonatomic, strong)   NSMutableArray *users;
@property (nonatomic, assign)   NSInteger pageIndex;
@property (nonatomic, assign)   NSInteger userType;

@end

@implementation CommitListViewController

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }

    return _users;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *item2 = [UIBarButtonExtern buttonWithImage:@"Info_personal" target:self andSelector:@selector(showActionSheet)];
    self.navigationItem.rightBarButtonItem = item2;
    
    self.showRefreshHeaderView = YES;
    
    _userType = 0;
    _pageIndex = 0;
    
    [self requestTalkListPeople];
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    _pageIndex = 0;
    [self requestTalkListPeople];
}

//  1 男 2 女
- (void)requestTalkListPeople
{
    HTBaseRequest *request = [HTBaseRequest groupUserList:[_groupTitle toMD5] andPageIndex:_pageIndex andUserType:_userType];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self removeHudInManaual];
        [self endRefresh];
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *users = [dic arrayForKey:@"result"];
            _pageIndex++;
            [self handleRequestSuccess:users clearOrAppend:_pageIndex == 1 ? YES : NO];
            
            [self.tableView reloadData];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
        
    }];
}

- (void)handleRequestSuccess:(NSArray *)array clearOrAppend:(BOOL)clear
{
    if (clear) {
        _users = nil;
    }
    
    [self.users addObjectsFromArray:array];
    
    if (self.users.count > 20) {
        self.showRefreshFooterView = YES;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"talkFriendsCell";
    CommitListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [CommitListCell newCell];
    }
    
    NSDictionary *user = [self.users objectAtIndex:indexPath.row];
    
    [cell parseWithDic:user];
    
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

#pragma mark - 
#pragma mark ActionSheet
- (void)showActionSheet
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"全部", @"男", @"女", nil];
    
    [choiceSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 3) {
        _pageIndex = 0;
        _userType = buttonIndex;
        [self requestTalkListPeople];
    }
}

@end
