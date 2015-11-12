//
//  SignDetailViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/10.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "SignDetailViewController.h"
#import "TalkViewController.h"

NSString *groupPeople;

@interface SignDetailViewController ()

@property (nonatomic, assign)   NSInteger pageNum;
@property (nonatomic, strong)   NSArray *signArray;

@end

@implementation SignDetailViewController


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
    
    self.showRefreshHeaderView = YES;
    self.showRefreshFooterView = YES;
    self.refreshFooterView.refreshType = MJRefreshTypeLoadMore;
    
    [self requestSignList];
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    if (baseView.refreshType == MJRefreshTypeLoadMore) {
        _pageNum++;
        
    }else {
        _pageNum = 0;
    }
    
    [self requestSignList];
}

- (void)requestSignList
{
    HTBaseRequest *reqeust = [HTBaseRequest hotWordDetailList:_signType andPageNum:_pageNum];

    [reqeust startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        [self endRefresh];
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *arrayMain = [dict arrayForKey:@"result"];
            dict = [arrayMain objectAtIndex:0];
            NSArray *array = [dict arrayForKey:@"words"];
            [self handleRequestArray:array];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        [self endRefresh];
        
    }];
}

- (void)handleRequestArray:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:self.signArray];
    if (self.pageNum > 0) {
        [mutArray addObjectsFromArray:array];
        self.signArray = mutArray;
    }else {
        self.signArray = array;
    }

    if (self.signArray.count > 10) {
        self.showRefreshFooterView = YES;
    }
    
    [self.tableView reloadData];

}

#pragma mark - 
#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.signArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    HTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [self.signArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict stringForKey:@"word"];
    cell.detailTextLabel.text = HTSTR(@"%@人", [dict stringForKey:@"user_count"]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *word = [[self.signArray objectAtIndex:indexPath.row] stringForKey:@"word"];
    [self createGroupWithTitle:word];
    
}

#pragma mark - Show Talk ViewController

//  MARK:创建并加入聊天室
- (void)createGroupWithTitle:(NSString *)title
{
    [self showHudWaitingView:PromptTypeWating];
    HTBaseRequest *request = [HTBaseRequest createGroupWithGroupName:title];
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        dict = [dict dictionaryForKey:@"result"];
        groupPeople = [dict stringForKey:@"user_count"];
        if (code == 200) {
            [weakSelf joinGroupByGroupId:[title toMD5] andGroupName:title];
        }
        
    }];
}

//  MARK:记录用户点击过的标签
- (void)recoderUserClickWord:(NSString *)word
{
    HTBaseRequest *request = [HTBaseRequest recoderUserSearchWord:word];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

//  加入群组
- (void)joinGroupByGroupId:(NSString *)groupId andGroupName:(NSString *)groupName
{
    __weakSelf;
    [[RCIMClient sharedRCIMClient] joinGroup:groupId groupName:groupName success:^{
        [weakSelf removeHudInManaual];
        
        /* 接口已经停止使用 */
        //[weakSelf recoderUserClickWord:groupName];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf showTalkListViewController:groupName];
        });
        
        /*
         //  同步群组数据
         RCGroup *group = [[RCGroup alloc] initWithGroupId:[groupName toMD5] groupName:groupName portraitUri:nil];
         [[RCIMClient sharedRCIMClient] syncGroups:@[group] success:^{
         // success
         
         } error:^(RCErrorCode status) {
         
         }];
         
         */
        
    } error:^(RCErrorCode status) {
        [weakSelf showHudErrorView:@"加入失败，请重试!"];
    }];
}

//  MARK:聊天室Controller
- (void)showTalkListViewController:(NSString *)title
{
    TalkViewController *conversationVC = [[TalkViewController alloc] init];
    conversationVC.conversationType = ConversationType_GROUP; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = [title toMD5]; // 接收者的 targetId，这里为举例。
    conversationVC.userName = title;
    conversationVC.title = title; // 会话的 title。
    conversationVC.groupTitle = title;
    conversationVC.groupPeople = groupPeople;
    
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

@end
