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

@interface CommitListViewController ()

@property (nonatomic, strong)   UIView *navBackView;
@property (nonatomic, strong) NSMutableArray *users;
@property (nonatomic, assign) NSInteger pageIndex;

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
    
    [self getBackView:self.navigationController.navigationBar withHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self getBackView:self.navigationController.navigationBar withHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

-(void)getBackView:(UIView*)superView withHidden:(BOOL)hidden
{
    if ([superView isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])
    {
        _navBackView = superView;
        //在这里可设置背景色
        _navBackView.backgroundColor = hidden ? [UIColor clearColor] : [UIColor jt_barTintColor];
        
    }else if ([superView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        //_UIBackdropEffectView是_UIBackdropView的子视图，这是只需隐藏父视图即可
        superView.hidden = hidden;
    }
    
    for (UIView *view in superView.subviews)
    {
        [self getBackView:view withHidden:hidden];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.groupTitle;
    
    self.navigationItem.titleView.backgroundColor = HTRedColor;
    
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
    cell.promptLabel.text = @"";
    
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
