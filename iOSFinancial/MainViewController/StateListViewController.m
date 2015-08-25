
//
//  StateListViewController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "StateListViewController.h"
#import "SignListView.h"
#import "UIBarButtonExtern.h"
#import "AddCustomSignViewController.h"
#import "ManageSignListViewController.h"
#import "AddSignViewController.h"
#import "SearchBarView.h"
#import "TalkListViewController.h"
#import "HTBaseRequest+Requests.h"
#import "TalkViewController.h"


@interface StateListViewController () <UITextFieldDelegate>

@property (nonatomic, strong)   SearchBarView *searchBarView;
@property (nonatomic, strong)   UILabel *refreshLabel;
@property (nonatomic, assign)   CGRect searchBarRect;
@property (nonatomic, strong)   UIImageView *backImageView;
@property (nonatomic, strong)   SignListModel *singListModel;
@property (nonatomic, strong)   NSMutableArray *dataArray;
@property (nonatomic, strong)   UILabel *titleLabel;

@end

@implementation StateListViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.dataArray.count == 0) {
        [self.refreshHeaderView beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showRefreshHeaderView = YES;
    [self.refreshHeaderView makeWhite];
    
    /*
    self.navigationItem.leftBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"管理" target:self andSelector:@selector(signListManage)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"DIY" target:self andSelector:@selector(addSign)];
    */
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:HTImage(@"findMoreImage1")];
    _backImageView = backImageView;
    backImageView.width = self.view.width;
    backImageView.height = self.view.width;
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.tableView];
    
    [self addTableHeaderView];
    
    if ([User sharedUser].isLogin) {
        [self.refreshHeaderView beginRefreshing];
    }

}

//  MARK:下拉刷新
- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    [self requestHotWordList];
}

- (void)requestHotWordList
{
    HTBaseRequest *request = [HTBaseRequest hotWordList];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self endRefresh];
        
        [self parseHotSignListData:[request.responseJSONObject arrayForKey:@"result"]];
        
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
        
    }];
}

//  MARK:解析返回的列表数据
- (void)parseHotSignListData:(NSArray *)array
{
    [self.dataArray removeAllObjects];
    
    for (NSDictionary *dict in array) {
        SignListModel *model = [[SignListModel alloc] init];
        [model parseWithDictionary:dict];
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.searchBarView makeEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.searchBarView makeEditing:NO];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *word = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!isEmpty(word)) {
        [self recoderUserClickWord:word];
    }
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset <= 0) {
        CGFloat alpha = 1 - fabs(offset) / 64.0f ;
        self.searchBarView.alpha = alpha;
        self.titleLabel.alpha = alpha;
        
    }else {
        self.backImageView.top = -offset;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        UIView *view = [[UIView alloc] init];
        return view;
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 36)];
    UIImageView *refreshImageView = [[UIImageView alloc] initWithImage:HTImage(@"refrechIcon")];
    refreshImageView.frame = CGRectMake(10, 5, 25, 25);
    [backView addSubview:refreshImageView];
    
    [backView addSubview:self.refreshLabel];
    
    return backView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 20.0f;
    }
    
    return 36.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count - 1) {
        return 20.0f;
    }
    
    return .01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        UIView *view = [[UIView alloc] init];
        return view;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (76 * 3 + 72  + 110) / 2;
}


#define __SignListCellTag   66666

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"stateListCell";
    HTBaseCell *cell = (HTBaseCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    if (!cell) {
        cell = [[HTBaseCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        SignListView *listView = [[SignListView alloc] init];
        listView.tag = __SignListCellTag;
        
        
        listView.frame = cell.contentView.frame;
        listView.frame = CGRectInset(cell.contentView.frame, 15, 0);
        [cell addSubview:listView];
        [listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(0.0f));
            make.left.equalTo(@(15.0f));
            make.right.equalTo(@(-15.0f));
            make.bottom.equalTo(@(0.0f));
        }];
    }
    
    SignListView *listView = (SignListView *)[cell viewWithTag:__SignListCellTag];
    
    [listView refreWithModel:[self.dataArray objectAtIndex:indexPath.section]];
    
    __weakSelf;
    [listView setSignClickBlock:^(SignModel *model, UIButton *button) {
        //  单击了标签
        [self recoderUserClickWord:button.titleLabel.text];
        
        [weakSelf showTalkListViewController:model];
    }];
    
    [listView setChangeAnotherBlock:^(UIButton *button) {
        //  单击了更换
        
        
    }];
    
    return cell;
}

//  MARK:记录用户点击过的标签
- (void)recoderUserClickWord:(NSString *)word
{
    HTBaseRequest *request = [HTBaseRequest recoderUserSearchWord:word];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
    }];
}

//  MARK:创建聊天室
- (void)createGroup
{
    HTBaseRequest *request = [HTBaseRequest createGroupWithGroupName:self.title];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        
        if (code == 200) {
            
        }
        
    }];

}

//  MARK:程序状态的存储和恢复
#pragma mark - Restoreatoin
- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.dataArray forKey:@"selfDataArray"];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
   self.dataArray = [coder decodeObjectForKey:@"selfDataArray"];
}

//  MARK:聊天室Controller
- (void)showTalkListViewController:(SignModel *)model
{
//    TalkViewController *conversationVC = [[TalkViewController alloc] init];
//    conversationVC.view.backgroundColor = HTRedColor;
//    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
//    conversationVC.targetId = @"55d81cd1b217c414ea07eb9c"; // 接收者的 targetId，这里为举例。
//    conversationVC.userName = @"Mr.Yang"; // 接受者的 username，这里为举例。
//    conversationVC.title = @"Mr.Yang_Hello"; // 会话的 title。
//    
//    conversationVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:conversationVC animated:YES];
//    
//    return;
    
    TalkListViewController *talkVc = [[TalkListViewController alloc] init];
    talkVc.signModel = model;
    talkVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:talkVc animated:YES];
}

#pragma mark - Views

- (void)addTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 36)];
    titleLabel.text = @"世界有交集";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:32.0f];;
    [headerView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    SearchBarView *searchView = self.searchBarView;
    searchView.frame = CGRectMake(15, titleLabel.bottom + 36.0f, self.view.width - 30, 45.0f);
    _searchBarRect = searchView.frame;
    
    headerView.height = searchView.bottom + 50.0f;
    [headerView addSubview:searchView];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (SignListModel *)singListModel
{
    if (!_singListModel) {
        _singListModel = [[SignListModel alloc] init];
    }
    
    return _singListModel;
}

- (UILabel *)refreshLabel
{
    if (!_refreshLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 200, 20.0f)];
        label.text = @"1分钟前刷新";
        label.font = HTFont(15.0f);
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        _refreshLabel = label;
    }
    
    return _refreshLabel;
}

- (SearchBarView *)searchBarView
{
    if (!_searchBarView) {
        _searchBarView = [SearchBarView xibView];
        _searchBarView.searchDelegate = self;
        _searchBarView.layer.borderColor = [UIColor jt_lineColor].CGColor;
        _searchBarView.layer.borderWidth = .5f;
    }
    
    return _searchBarView;
}

//  添加标签（DIY）
- (void)addSign
{
    AddCustomSignViewController *customSign = [[AddCustomSignViewController alloc] init];
    [self.navigationController pushViewController:customSign animated:YES];
}

//  管理标签
- (void)signListManage
{
    ManageSignListViewController *manage = [[ManageSignListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:manage animated:YES];
}

/*
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBarView endEditing:YES];
    
    CGRect rect = [self.tableView convertRect:_searchBarRect toView:self.view];
    if (rect.origin.y <= 0) {
        self.searchBarView.top = 0;
        [self.view addSubview:self.searchBarView];
        [UIView animateWithDuration:.25f animations:^{
            
            self.searchBarView.left = 0;
            self.searchBarView.width = self.view.width;
        }];
        
    }else {
        UIView *headerView = self.tableView.tableHeaderView;
        [headerView addSubview:self.searchBarView];
        self.searchBarView.frame = _searchBarRect;
        [UIView animateWithDuration:.25f animations:^{
            self.searchBarView.left = 15.0f;
            self.searchBarView.width = self.view.width - 30.0f;
        }];
        
    }
    
    CGPoint point = scrollView.contentOffset;
    CGFloat offset = point.y / 100.0f > .5 ? .5 : point.y / 100.0f;
    offset = 1.0f - offset > 1.0f ? 1.0f - offset : 1.0f;
    
    self.backImageView.transform = CGAffineTransformMakeScale(offset, offset);
}
*/

@end