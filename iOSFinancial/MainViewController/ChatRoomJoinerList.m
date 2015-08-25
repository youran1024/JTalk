//
//  ChatRoomJoinerList.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ChatRoomJoinerList.h"
#import "HTBaseCell.h"
#import "ChatRoomInfo.h"
#import "ShareTitleView.h"
#import "ChatRoomCell.h"

@interface ChatRoomJoinerList ()

@property (nonatomic, strong)   ShareTitleView *titleView;
@property (nonatomic, strong)   ChatRoomInfo *chatRoomInfo;

@end

@implementation ChatRoomJoinerList


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshChatRoomInfo];
    
    self.navigationItem.titleView = self.titleView;
    self.titleView.codeLabel.text = @"88人正在看球";
    
}

- (void)refreshChatRoomInfo
{
    self.chatRoomInfo.headerImageView.image = HTImage(@"app_icon");
    self.chatRoomInfo.tailLabel.text = @"256人";
}

- (ShareTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[ShareTitleView alloc] init];
        _titleView.titleLabel.text = self.title;
    }
    
    return _titleView;
}

- (ChatRoomInfo *)chatRoomInfo
{
    if (!_chatRoomInfo) {
        _chatRoomInfo = [ChatRoomInfo xibView];
    }
    
    return _chatRoomInfo;
}

#pragma mark - 
#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 70.0f;
    }
    
    return .001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.chatRoomInfo;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"talkFriendsCell";
    ChatRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [ChatRoomCell newCell];
    }
    
    cell.headImageView.image = HTImage(@"app_icon");
    cell.nameLabel.text = @"小学生";
    cell.timeLabel.text = @"1分钟前";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
