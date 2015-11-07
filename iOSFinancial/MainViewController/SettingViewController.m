//
//  SettingViewController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SettingViewController.h"
#import "EditInfoViewController.h"
#import "ReedBackViewController.h"
#import <UMengFeedback/UMFeedback.h>
#import "SearchHistoryViewController.h"
#import "UserInfoCell.h"
#import <RongIMKit/RongIMKit.h>
#import "UserPullBackListViewController.h"
#import "UMSocial.h"


@interface SettingViewController () <UMSocialUIDelegate>

@property (nonatomic, strong)   UISwitch *switchButton;
@property (nonatomic, strong)   UserInfoCell *infoCell;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (UISwitch *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _switchButton.on = [RCIM sharedRCIM].disableMessageNotificaiton;
    }
    
    return _switchButton;
}

//  消息接收事件
- (void)switchButtonClicked:(UISwitch*)switchbutton
{
    BOOL isOpen = switchbutton.on;
    [HTUserDefaults setValue:@(isOpen) forKey:kJTalkMessageStoreKey];
    [HTUserDefaults synchronize];
    
    [RCIM sharedRCIM].disableMessageNotificaiton = isOpen;
    [RCIM sharedRCIM].disableMessageAlertSound = isOpen;
}

#pragma mark - 
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return .01f;
    }
    return 25.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ||
        section == 2) {
        return 1;
    }
    
    return 6;
}

- (UserInfoCell *)infoCell
{
    if (!_infoCell) {
        UserInfoCell *infoCell = [UserInfoCell newCell];
        infoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _infoCell = infoCell;
    }
    
    return _infoCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoModel *userInfo = [User sharedUser].userInfo;
    
    if (indexPath.section == 0) {
        
        if (userInfo.userPhotoImage) {
            self.infoCell.headerImageView.image = userInfo.userPhotoImage;
        }else {
            [self.infoCell.headerImageView sd_setImageWithURL:HTURL(userInfo.userPhoto) placeholderImage:HTImage(@"app_icon")];
        }
        
        self.infoCell.nameLabel.text = userInfo.userName;
        
        return self.infoCell;
    }
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    HTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.imageView.image = nil;
    
   if(indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryView = self.switchButton;
       
    }
    
    if (indexPath.section == 0 ||
        (indexPath.section == 1 && (indexPath.row != 1))) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if (indexPath.section != 0) {
        cell.textLabel.text = [self titleAtIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        EditInfoViewController *editor = [[EditInfoViewController alloc] init];
        editor.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editor animated:YES];
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            //  搜索历史
            
            SearchHistoryViewController *search = [[SearchHistoryViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            search.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:search animated:YES];
            
        }else if (indexPath.row == 1) {
            
            
        }else if (indexPath.row == 2) {
            //  评分
            [[UIApplication sharedApplication] openURL:HTURL(kApplicationEvaluateURL)];

        }else if (indexPath.row == 3){
            //UMeng feedBack
            //[self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            
            ReedBackViewController *back = [[ReedBackViewController alloc] init];
            back.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:back animated:YES];
            
        }else if (indexPath.row == 4) {
            //  邀请好友
            [self inviteFriends];
            
        } else {
            //  拉黑名单
            UserPullBackListViewController *pullBlack = [[UserPullBackListViewController alloc] init];
            pullBlack.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pullBlack animated:YES];
        }
        
    }else {
        //  退出登录
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self alertUserLoginOutMessage];
    }
}

- (void)alertUserLoginOutMessage
{
    [self showActionSheet:nil message:@"确定要退出吗？" buttonTitle:@[@"退出", @"取消"] style:UIAlertControllerStyleActionSheet handler:^(UIActionSheet *action, NSInteger clickedIndex) {
        if (clickedIndex == 0) {
            //  退出
            [self userLoginOut];
        }
    }];
}

#pragma mark - 
#pragma mark 分享

- (void)inviteFriends
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMengAppKey
                                      shareText:@"Hello,I am JTalk, http://xxxxTalk.com  -- test ^^"
                                     shareImage:[UIImage imageNamed:@"personal1"]
                                shareToSnsNames:@[UMShareToQQ, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToSina]
                                       delegate:self];
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

//  MARK:用户退出按钮
- (void)userLoginOut
{
    [[RCIM sharedRCIM] disconnect];
    User *user = [User sharedUser];
    [user clearUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:__USER_LOGINOUT_SUCCESS object:nil];
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return @"搜索历史";
            case 1: return @"新消息提醒";
            case 2: return @"去评分";
            case 3: return @"意见反馈";
            case 4: return @"邀请好友";
            case 5: return @"拉黑名单";
            default:
                break;
        }
        
    }else {
        return @"退出登录";
    }
    
    return @"";
}

- (NSString *)title
{
    return @"设置";
}


@end
