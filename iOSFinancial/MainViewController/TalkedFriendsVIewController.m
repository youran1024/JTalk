//
//  TalkedFriendsVIewController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkedFriendsVIewController.h"
#import "TalkedFriendsCell.h"
#import "TalkedFriendsTopView.h"
#import "XMBadgeView.h"
#import "UIBarButtonExtern.h"
#import "IndexLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "BaseTalkViewController.h"

@interface TalkedFriendsVIewController ()

@property (nonatomic, strong)   TalkedFriendsTopView *topView;

@end

@implementation TalkedFriendsVIewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTopView];
    
    self.showRefreshHeaderView = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"登录" target:self andSelector:@selector(loginButtonClicked)];
    
}

- (void)loginButtonClicked
{
    /*
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
    
    return;
*/
    IndexLoginViewController *login = [[IndexLoginViewController alloc] init];
    
    [self.navigationController pushViewController:login animated:YES];
    
    /*
    BaseTalkViewController *talk = [[BaseTalkViewController alloc]
                                    initWithDisplayConversationTypes:
                                    @[@(ConversationType_CUSTOMERSERVICE),
                                      @(ConversationType_PRIVATE) ,
                                      @(ConversationType_DISCUSSION),
                                      @(ConversationType_GROUP)]
                                    collectionConversationType:
                                    @[
                                      @(ConversationType_CUSTOMERSERVICE)]];
    
    [self.navigationController pushViewController:talk animated:YES];
     */
    
}

- (void)refreshTopView
{
    self.topView.headImageView.image = HTImage(@"app_icon");
    self.topView.titleLabel.text = @"已加入：看球";
    self.topView.promptLabel.text = @"3分钟后自动退出聊天室";
}

#pragma mark - RefreshView

//  下拉刷新
- (void)refreshViewBeginRefresh:(MJRefreshBaseView *)baseView
{
    
}

#pragma mark - 
#pragma mark TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 71.0f;
    }
    
    return .001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
      return self.topView;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"talkFriendsCell";
    TalkedFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [TalkedFriendsCell newCell];
    }
    
    if (indexPath.row % 2 == 0) {
        XMBadgeView *badgeView = [[XMBadgeView alloc] initWithParentView:cell alignment:XMBadgeViewAlignmentCenterRight];
        badgeView.badgeText = HTSTR(@"%d", (int)indexPath.row + 10);
        cell.accessoryView = badgeView;
        [cell layoutIfNeeded];
        
    }else {
        cell.accessoryView = nil;
    }
    
    cell.nameLabel.text = @"Hunter";
    cell.headImageView.image = HTImage(@"app_icon");
    cell.timeLabel.text = @"2015.8.3";
    cell.promptLabel.text = @"[语音] 3.10''";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = @"55d81cd1b217c414ea07eb9c"; // 接收者的 targetId，这里为举例。
    conversationVC.userName = @"Mr.Yang"; // 接受者的 username，这里为举例。
    conversationVC.title = @"Mr.Yang_Hello"; // 会话的 title。
    
    // 把单聊视图控制器添加到导航栈。
    conversationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - Views
- (TalkedFriendsTopView *)topView
{
    if (!_topView) {
        _topView = [TalkedFriendsTopView xibView];
    }
    
    return _topView;
}

@end
