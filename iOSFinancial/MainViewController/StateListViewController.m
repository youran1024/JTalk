
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
#import "SystemConfig.h"
#import "NSDate+BFExtension.h"
#import <CoreText/CoreText.h>
#import "DetailWebViewController.h"


@interface StateListViewController () <UITextFieldDelegate>

@property (nonatomic, strong)   SearchBarView *searchBarView;
@property (nonatomic, strong)   UILabel *refreshLabel;
@property (nonatomic, assign)   CGRect searchBarRect;
@property (nonatomic, strong)   UIImageView *backImageView;
@property (nonatomic, strong)   SignListModel *singListModel;
@property (nonatomic, strong)   NSMutableArray *dataArray;
@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, strong)   NSDate *refreshDate;

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
    
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.dataArray.count == 0 && __isUserLogin) {
        [self showHudWaitingView:PromptTypeWating];
        [self requestHotWordList];
    }
    
    if (_refreshDate) {
        _refreshLabel.text = HTSTR(@"%@", [_refreshDate labelString]);
        if ([_refreshLabel.text isEqualToString:@"刚刚"]) {
            _refreshLabel.text = @"刚刚刷新";
        }
        
    }else {
        _refreshLabel.text = @"";
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.searchBarView.searchField.text = @"";
    [self.searchBarView makeEditing:NO];
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
    
    SystemConfig *system = [SystemConfig defaultConfig];
    NSString *imageStr = system.firstIndexBackImage;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:HTImage(imageStr)];
    _backImageView = backImageView;
    backImageView.width = self.view.width;
    backImageView.height = self.view.width;
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTapGesture)];
    [self.tableView addGestureRecognizer:tap];
    
    
    [self addTableHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:__USER_LOGIN_SUCCESS object:nil];
}

//  MARK:收回键盘
- (void)backViewTapGesture
{
    [self.view endEditing:YES];
}

- (void)userLoginSuccess
{
    [self requestHotWordList];
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
        [self removeHudInManaual];
        [self endRefresh];
        
        [self parseHotSignListData:[request.responseJSONObject arrayForKey:@"result"]];
        
        self.refreshDate = [NSDate date];
        self.refreshLabel.text = @"刚刚刷新";
        
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
        [textField resignFirstResponder];
        [self createGroupWithTitle:word];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
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
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    SignListModel *model = [self.dataArray objectAtIndex:indexPath.section];

    [listView refreWithModel:model];
    
    __weakSelf;
    
    //  单击了标签
    [listView setSignClickBlock:^(SignModel *model, UIButton *button) {
        //  创建聊天室
        [weakSelf createGroupWithTitle:button.titleLabel.text];
        
    }];
    
    [listView setChangeAnotherBlock:^(UIButton *button) {
        //  单击了更换
        
        
    }];
    
    [listView setSignListViewTouchBlcok:^(SignListModel *model, SignListView *signView) {
        [self showDetailWebViewController:model];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)showDetailWebViewController:(SignListModel *)model
{
    if (model.signViewType == SignViewTypeImage) {
        NSString *webUrl = [model.showSignDic stringForKey:@"web_url"];
        NSString *title = [model.showSignDic stringForKey:@"title"];
        
        DetailWebViewController *detail = [[DetailWebViewController alloc] init];
        detail.talkTopic = title;
        detail.titleStr = HTSTR(@"[卧]%@", title);
        detail.url = HTURL(webUrl);
        detail.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detail animated:YES];
    }

}


//  MARK:创建并加入聊天室
- (void)createGroupWithTitle:(NSString *)title
{
    [self showHudWaitingView:PromptTypeWating];
    HTBaseRequest *request = [HTBaseRequest createGroupWithGroupName:title];
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        
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
    
    conversationVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
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
    [self.tableView reloadData];
}

#pragma mark - Views

- (void)addTableHeaderView
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"世界有交集"];
    long number = 10.0f;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [string addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[string length])];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.width, 36)];
    titleLabel.attributedText = string;
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
