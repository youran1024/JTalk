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

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation CommitListViewController

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
    [self showHudWaitingView:PromptTypeWating];
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
            _pageIndex++;
            
        }
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
        
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    
    cell.nameLabel.text = @"Hunter";
    cell.headImageView.image = HTImage(@"app_icon");
    cell.promptLabel.text = @"1分钟前";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonalViewController *personal = [[PersonalViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:personal animated:YES];
}


@end
