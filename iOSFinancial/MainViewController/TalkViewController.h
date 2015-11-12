//
//  TalkViewController.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "BaseTalkViewController.h"
#import <RongIMKit/RongIMKit.h>

/**
 *  聊天室
 */

@interface TalkViewController : RCConversationViewController <RCChatSessionInputBarControlDelegate>

/**
 *  会话数据模型
 */
@property (strong,nonatomic) RCConversationModel *conversation;

//  聊天群组标题
@property (nonatomic, copy) NSString *groupTitle;

//  群组人数
@property (nonatomic, copy) NSString *groupPeople;


@end
