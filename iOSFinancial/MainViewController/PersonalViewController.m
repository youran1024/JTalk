//
//  PersonalViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "PersonalViewController.h"
#import "SignModel.h"
#import "SignListModel.h"
#import "SignListView.h"
#import "TalkListViewController.h"
#import "PersonalInfoView.h"
#import "UIView+BorderColor.h"
#import "TalkViewController.h"
#import "SystemConfig.h"
#import "UIBarButtonExtern.h"


#define __HeaderView_Height_Offset   100

@interface PersonalViewController () <UIActionSheetDelegate>

@property (nonatomic, strong)   UIImageView *backImageView;
@property (nonatomic, strong)   PersonalInfoView *personalInfoView;
@property (nonatomic, strong)   SignListView *signListView;
@property (nonatomic, strong)   UIView *alphaView;
@property (nonatomic, strong)   UIView *navBackView;
@property (nonatomic, strong)   UIButton *talkButton;

@property (nonatomic, strong)   SignListModel *signListModel;
@property (nonatomic, strong)   UserInfoModel *userInfoModel;

//  当前人与要聊天的人得关系， 拉黑， 朋友， 。。。。

//  0 可以正常聊天
//  1 表示我将别人拉黑
//  2 表示别人将我拉黑
//  3 表示互相拉黑

@property (nonatomic, assign)   NSInteger balckType;

@end

@implementation PersonalViewController

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
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = nil;
    [self getBackView:self.navigationController.navigationBar withHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self getBackView:self.navigationController.navigationBar withHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackImageView];
    self.tableView.tableHeaderView = self.personalInfoView;
    
    [self configPersonalViewInfo];
    
    self.showRefreshHeaderView = YES;
    [self.refreshHeaderView makeWhite];
    
    [self.refreshHeaderView beginRefreshing];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (![_userId isEqualToString:__userInfoId]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithImage:@"reportAction" target:self andSelector:@selector(reportButtonClicked)];
    }
}

- (void)reportButtonClicked
{
    [self showPullBackList];
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    [self requestUserInfo];
}

- (void)requestUserInfo
{
    if (isEmpty(_userId)) {
        NSAssert(isEmpty(_userId), @"userid is empty");
        return;
    }
    
    HTBaseRequest *request = [HTBaseRequest otherUserInfo:_userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        [self endRefresh];
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            //  成功
            [self parseWithDictionary:[dict dictionaryForKey:@"result"]];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [self endRefresh];
    }];
}

- (void)parseWithDictionary:(NSDictionary *)dict
{
    self.balckType = [[dict stringForKey:@"black_type"] integerValue];
    
    if ([self.userId isEqualToString:__userInfoId]) {
        //  如果是自己则可以跟自己聊天
        self.balckType = 0;
    }
    
    _signListModel = [[SignListModel alloc] init];
    [_signListModel parseWithPersonalArray:[dict arrayForKey:@"user_words"]];
    [_signListView refreWithModel:_signListModel];
    
    
    self.userInfoModel.userID = _userId;
    [self.userInfoModel parseWithDictionaryWithOutSync:dict];
    
    [self configPersonalViewInfo];
}

- (void)addBackImageView
{
    SystemConfig *system = [SystemConfig defaultConfig];
    NSString *imageStr = system.personalBackImage;
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:HTImage(imageStr)];
    
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView = backImageView;
    backImageView.width = APPScreenWidth;
    backImageView.height = APPScreenWidth - __HeaderView_Height_Offset - 20;
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.tableView];
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

- (void)configPersonalViewInfo
{
    [self.personalInfoView.imageView sd_setImageWithURL:HTURL(_userInfoModel.userPhoto) placeholderImage:HTImage(@"app_icon")];
    self.personalInfoView.nameLabel.text = _userInfoModel.userName;
    self.personalInfoView.promptLabel.text = HTSTR(@"%@, %@", _userInfoModel.userSex, _userInfoModel.userLocation);
    self.personalInfoView.locationLabel.text = _userInfoModel.userPrompt;
    
    [self.tableView reloadData];
}

#pragma mark -
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat offset = point.y / 100.0f > .5 ? .5 : point.y / 100.0f;
    offset = 1.0f - offset > 1.0f ? 1.0f - offset : 1.0f;
    
    self.backImageView.transform = CGAffineTransformMakeScale(offset, offset);
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset > 0) {
        self.backImageView.top = -offset;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.balckType > 0) {
        return 0;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 160.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 100)];
    
    [view addSubview:self.talkButton];
     self.talkButton.centerX = view.centerX;
    
    return view;
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
        
        _signListView = listView;
    }
    
    SignListView *listView = (SignListView *)[cell viewWithTag:__SignListCellTag];
    
    [listView refreWithModel:self.singListModel];
    
    __weakSelf;
    [listView setSignClickBlock:^(SignModel *model, UIButton *button) {
        //  单击了标签
        
        [weakSelf createGroupWithTitle:model.title];
    }];
    
    [listView setChangeAnotherBlock:^(UIButton *button) {
        //  单击了更换
        
    }];
    
    return cell;
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

//  加入群组
- (void)joinGroupByGroupId:(NSString *)groupId andGroupName:(NSString *)groupName
{
    __weakSelf;
    [[RCIMClient sharedRCIMClient] joinGroup:groupId groupName:groupName success:^{
        [weakSelf removeHudInManaual];
        
        [weakSelf recoderUserClickWord:groupName];
        
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

//  MARK:记录用户点击过的标签
- (void)recoderUserClickWord:(NSString *)word
{
    HTBaseRequest *request = [HTBaseRequest recoderUserSearchWord:word];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
    } failure:^(YTKBaseRequest *request) {
        
    }];
}

#pragma mark - 
#pragma mark Views

- (UserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[UserInfoModel alloc] init];
    }
    
    return _userInfoModel;
}

- (UIButton *)talkButton
{
    if (!_talkButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 23.0f;
        button.layer.masksToBounds = YES;
        [button setTitle:@"聊聊" forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor redColor];
        [button setBackgroundColor:[UIColor colorWithHEX:0x5dd48d]];
        button.frame = CGRectMake(0, 46, 220, 50);
        _talkButton = button;
        [button addTarget:self action:@selector(talkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _talkButton;
}

//  MARK:聊天按钮
- (void)talkButtonClicked:(UIButton *)button
{
    if (!_userInfoModel) {
        [self showHudAuto:@"请刷新当前页面后重试"];
        return;
    }
    
    TalkViewController *conversationVC = [[TalkViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = _userInfoModel.userID; // 接收者的 targetId，这里为举例。
    conversationVC.userName = _userInfoModel.userName;
    conversationVC.title = _userInfoModel.userName; // 会话的 title。
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (PersonalInfoView *)personalInfoView
{
    if (!_personalInfoView) {
        _personalInfoView = [PersonalInfoView xibView];
        _personalInfoView.width = APPScreenWidth;
        _personalInfoView.height = APPScreenWidth - __HeaderView_Height_Offset;
    }
    
    return _personalInfoView;
}

- (SignListModel *)singListModel
{
    if (!_signListModel) {
        _signListModel = [[SignListModel alloc] init];
    }
    
    return _signListModel;
}


#pragma mark - 屏蔽并举报

#define pullBackListTag     10001
#define pullBackResionTag   10002

- (void)showPullBackList
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"屏蔽并举报", @"屏蔽", nil];
    choiceSheet.tag = pullBackListTag;
    
    [choiceSheet showInView:self.view];
    
}

#pragma mark -
#pragma mark Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == pullBackListTag) {
        if (buttonIndex == 0) {
            //  屏蔽并举报
            UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles: @"淫秽色情", @"垃圾广告", @"骚扰", @"诈骗", nil];
            choiceSheet.tag = pullBackResionTag;
            
            [choiceSheet showInView:self.view];
            
        }else if (buttonIndex == 1){
            //
            [self pullToBlackList];
        }
        
    }else {
        if (buttonIndex != 4) {
            
            [self pullToBlackList];
            //  举报
            [self reportUserReqeust:buttonIndex];
        }
    }
}

- (void)pullToBlackList
{
    //  屏蔽
    [self sendPullBlackRequestWithPrompt:NO];
    
    //  拉黑
    [[RCIMClient sharedRCIMClient] addToBlacklist:self.userId success:^{
        
    } error:^(RCErrorCode status) {
        
    }];
    
}

- (void)reportUserReqeust:(NSInteger)type
{
    [self showHudWaitingView:PromptTypeWating];
    
    HTBaseRequest *request = [HTBaseRequest reportUserInGroup:self.userId andReportType:type];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            [self showHudSuccessView:@"举报成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        [self showHudErrorView:@"举报失败"];
        
    }];
}

- (void)sendPullBlackRequestWithPrompt:(BOOL)prompt
{
    if (prompt) {
        [self showHudWaitingView:PromptTypeWating];
    }
    
    HTBaseRequest *request = [HTBaseRequest pullBlackUser:self.userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200 && prompt) {
            [self showHudSuccessView:@"屏蔽成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        if (prompt) {
            [self showHudErrorView:@"屏蔽失败"];
        }
        
    }];
}


@end
