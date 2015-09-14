//
//  TalkSettingViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/9/1.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkSettingViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "UIAlertView+RWBlock.h"


@interface TalkSettingViewController ()

@property (nonatomic, strong) UISwitch *messageSwitch;

@end

@implementation TalkSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showHudWaitingView:PromptTypeWating];
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:_groupId success:^(RCConversationNotificationStatus nStatus) {
        self.messageSwitch.on = nStatus == DO_NOT_DISTURB;
        
        [self removeHudInManaual];
        
    } error:^(RCErrorCode status) {
        
        [self showHudErrorView:@"获取数据错误"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.5f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"开启后，您将不再收到该聊天室的新消息提醒通知";
    }
    
    return @"退出后，您将不再接受聊天时消息，并退出通讯录";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50.0f)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, APPScreenWidth - 30, 30)];
    title.font = HTFont(14.0f);
    title.textColor = [UIColor jt_lightBlackTextColor];
    title.text = [self tableView:tableView titleForFooterInSection:section];
    [view addSubview:title];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = [UIColor jt_globleTextColor];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"消息免打扰";
        cell.accessoryView = self.messageSwitch;
        
    }else {
        cell.textLabel.text = @"退出聊天室";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认要退出?" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //  确认
                [self quiteGroup];
            }
        }];
        
        [alert show];
    }
}

- (void)quiteGroup
{
    [self showHudWaitingView:PromptTypeWating];
    
    [[RCIMClient sharedRCIMClient] quitGroup:_groupId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHudSuccessView:@"退出成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHudErrorView:@"退出失败"];
        });
    }];
}

- (void)switchValueChanged:(UISwitch *)_switch
{
    [self showHudWaitingView:PromptTypeWating];
    
    __weakSelf;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:_groupId isBlocked:_switch.on success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"valueChanged:%ld", (long)nStatus);
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeHudInManaual];
        });
        
    } error:^(RCErrorCode status) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf showHudErrorView:HTSTR(@"错误码：%ld", (long)status)];
        });
        _switch.on = !_switch.on;
    }];
}

- (UISwitch *)messageSwitch
{
    if (!_messageSwitch) {
        _messageSwitch = [[UISwitch alloc] init];
        [_messageSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _messageSwitch;
}

- (NSString *)title
{
    return @"聊天室设置";
}

@end
