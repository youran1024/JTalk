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


@interface SettingViewController ()

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
    
    return 4;
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

        }else {
            //UMeng feedBack
            //[self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            
            ReedBackViewController *back = [[ReedBackViewController alloc] init];
            back.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:back animated:YES];
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
    return @"我";
}


@end
