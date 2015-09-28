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


@interface CommitListViewController ()

@property (nonatomic, strong)   NSMutableArray *users;
@property (nonatomic, assign)   NSInteger pageIndex;

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
    
    self.showRefreshHeaderView = YES;
    self.showRefreshFooterView = YES;
    
    _pageIndex = 0;
    
    [self requestTalkListPeople];
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    _pageIndex = 0;
    [self requestTalkListPeople];
}

- (void)requestTalkListPeople
{
    HTBaseRequest *request = [HTBaseRequest groupUserList:[_groupTitle toMD5] andPageIndex:_pageIndex];
    
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
    
    cell.nameLabel.text = [user stringForKey:@"name"];
    NSString *imageUrl = [user stringForKey:@"photo"];
    [cell.headImageView sd_setImageWithURL:HTURL(imageUrl) placeholderImage:HTImage(@"app_icon")];
    NSString *dateString = [user stringForKey:@"created"];
    NSDate *date = [NSDate dateWithString:dateString format:nil];
    
    cell.promptLabel.text = [date labelString];
    
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


@end
