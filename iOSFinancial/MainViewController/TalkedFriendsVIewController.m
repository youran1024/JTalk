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
#import "TalkViewController.h"
#import "RCDChatListCell.h"
#import "RCDUserInfo.h"
#import "PersonalViewController.h"
#import "HTBaseRequest+Requests.h"


@interface TalkedFriendsVIewController ()

@property (nonatomic, strong)   TalkedFriendsTopView *topView;

@end

@implementation TalkedFriendsVIewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationItemTitleView];
    
    [self notifyUpdateUnreadMessageCount];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //showConnectingStatusOnNavigatorBar设置为YES时，需要重写setNavigationItemTitleView函数来显示已连接时的标题。
    self.showConnectingStatusOnNavigatorBar = YES;
    [super updateConnectionStatusOnNavigatorBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.showConnectingStatusOnNavigatorBar = NO;
}

//- (void)setNavigationItemTitleView {
//    
//    if (self.isEnteredToCollectionViewController) {
//        return;
//    }
//    
//    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
//    titleView.backgroundColor = [UIColor clearColor];
//    titleView.font = [UIFont boldSystemFontOfSize:19];
//    titleView.textColor = [UIColor whiteColor];
//    titleView.textAlignment = NSTextAlignmentCenter;
//    titleView.text = @"会话";
//    self.tabBarController.navigationItem.titleView = titleView;
//    
//}

#pragma mark -
- (void)clearBackBarButtonItemTitle
{
    //  左侧返回标题为空
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
    returnButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = returnButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self clearBackBarButtonItemTitle];
}

- (void)notifyUpdateUnreadMessageCount
{
    [self updateBadgeValueForTabBarItem];
}

- (void)updateBadgeValueForTabBarItem
{
    __weakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
        if (count>0) {
            weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        }else
        {
            weakSelf.tabBarItem.badgeValue = nil;
        }
        
    });
}

/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        TalkViewController *_conversationVC = [[TalkViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.groupTitle = model.conversationTitle;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        
        _conversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
        
    }else if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
    
        //聚合会话类型，此处自定设置。
        TalkedFriendsVIewController *temp = [[TalkedFriendsVIewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
        
    }
    
}

//*********************插入自定义Cell*********************//

/*
//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    
    return dataSource;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.0f;
}

//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    
    __block NSString *userName    = nil;
    __block NSString *portraitUri = nil;
    
    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    if (nil == model.extend) {
        // Not finished yet, To Be Continue...
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
        NSDictionary *_cache_userinfo = [[NSUserDefaults standardUserDefaults]objectForKey:_contactNotificationMsg.sourceUserId];
        if (_cache_userinfo) {
            userName = _cache_userinfo[@"username"];
            portraitUri = _cache_userinfo[@"portraitUri"];
        } else {

        }
        
    }else{
        
        RCDUserInfo *user = (RCDUserInfo *)model.extend;
        userName    = user.name;
        portraitUri = user.portraitUri;
    }
    
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
    return cell;
}
*/

//*********************插入自定义Cell*********************//

/*
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        if (message.conversationType != ConversationType_SYSTEM) {
            NSLog(@"好友消息要发系统消息！！！");
#if DEBUG
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
#endif
        }
        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
        
        //该接口需要替换为从消息体获取好友请求的用户信息
//        [RCDHTTPTOOL getUserInfoByUserID:_contactNotificationMsg.sourceUserId
//                              completion:^(RCUserInfo *user) {
        HTBaseRequest *request = [HTBaseRequest otherUserInfo:_contactNotificationMsg.sourceUserId];
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            
            User *user = [User sharedUser];
            UserInfoModel *userInfo = user.userInfo;
            RCDUserInfo *rcduserinfo_ = [RCDUserInfo new];
            rcduserinfo_.name = @"Mr.Yang";
            rcduserinfo_.userId = __userInfoId;
            rcduserinfo_.portraitUri = userInfo.userPhoto;
            
            RCConversationModel *customModel = [RCConversationModel new];
            customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
            customModel.extend = rcduserinfo_;
            customModel.senderUserId = message.senderUserId;
            customModel.lastestMessage = _contactNotificationMsg;
            //[_myDataSource insertObject:customModel atIndex:0];
            
            //local cache for userInfo
            NSDictionary *userinfoDic = @{@"username": rcduserinfo_.name,
                                          @"portraitUri":rcduserinfo_.portraitUri
                                          };
            [[NSUserDefaults standardUserDefaults]setObject:userinfoDic forKey:_contactNotificationMsg.sourceUserId];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //调用父类刷新未读消息数
                [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
                //[super didReceiveMessageNotification:notification];
                [blockSelf_ resetConversationListBackgroundViewIfNeeded];
                [self notifyUpdateUnreadMessageCount];
                
                //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
                //原因请查看super didReceiveMessageNotification的注释。
                NSNumber *left = [notification.userInfo objectForKey:@"left"];
                if (0 == left.integerValue) {
                    [super refreshConversationTableViewIfNeeded];
                }
            });
        }];
       
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
        });
        
    }
}
*/

- (NSString *)title
{
    return @"聊天";
}

@end
