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


@interface PersonalViewController ()

@property (nonatomic, strong)   UIImageView *backImageView;
@property (nonatomic, strong)   PersonalInfoView *personalInfoView;
@property (nonatomic, strong)   SignListView *signListView;
@property (nonatomic, strong)   UIView *alphaView;
@property (nonatomic, strong)   UIView *navBackView;
@property (nonatomic, strong)   UIButton *talkButton;

@property (nonatomic, strong)   SignListModel *signListModel;
@property (nonatomic, strong)   UserInfoModel *userInfoModel;

//  当前人与要聊天的人得关系， 拉黑， 朋友， 。。。。
@property (nonatomic, assign)   NSInteger balckType;

@end

@implementation PersonalViewController

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
    
}

- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    [self requestUserInfo];
}

- (void)requestUserInfo
{
    
#warning fixMe
    HTBaseRequest *request = [HTBaseRequest otherUserInfo:__userInfoId];
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
    _signListModel = [[SignListModel alloc] init];
    [_signListModel parseWithDictionary:dict];
    [_signListView refreWithModel:_signListModel];
    
    [self.userInfoModel parseWithDictionary:dict];
    
    [self configPersonalViewInfo];
}

- (void)addBackImageView
{
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:HTImage(@"personal1")];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView = backImageView;
    backImageView.width = APPScreenWidth;
    backImageView.height = APPScreenWidth;
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
        
        [weakSelf showTalkListViewController:model];
    }];
    
    [listView setChangeAnotherBlock:^(UIButton *button) {
        //  单击了更换
        
        
    }];
    
    return cell;
}

- (void)showTalkListViewController:(SignModel *)model
{
    TalkListViewController *talkVc = [[TalkListViewController alloc] init];
    talkVc.signModel = model;
    [self.navigationController pushViewController:talkVc animated:YES];
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
    
    
    
}


- (PersonalInfoView *)personalInfoView
{
    if (!_personalInfoView) {
        _personalInfoView = [PersonalInfoView xibView];
        _personalInfoView.width = APPScreenWidth;
        _personalInfoView.height = APPScreenWidth;
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



@end