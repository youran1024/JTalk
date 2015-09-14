//
//  HTBaseRequest+Requests.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseRequest.h"

@interface HTBaseRequest (Requests)

+ (HTBaseRequest *)regeditNewAccount;

+ (HTBaseRequest *)editUserInfo;

+ (HTBaseRequest *)loginWithUserInfo;

+ (HTBaseRequest *)resetUserPass;

//  获取自己的用户信息
+ (HTBaseRequest *)getUserInfo;

//  获取某人的信息
+ (HTBaseRequest *)otherUserInfo:(NSString *)otherUserId;

//  首页热门词汇
+ (HTBaseRequest *)hotWordList;

/**
 *    拉黑
 */

//  拉黑用户
+ (HTBaseRequest *)pullBlackUser:(NSString *)userID;

//  查获黑名单列表 //get
+ (HTBaseRequest *)fetchBlackUserList;

//  移除拉黑用户
+ (HTBaseRequest *)removeUserFromPullBlackList:(NSString *)userId;

/**
 *    搜索
 */

//  提交个人检索词汇 (包括用户点击)
+ (HTBaseRequest *)recoderUserSearchWord:(NSString *)word;

//  查询个人检索词历史
+ (HTBaseRequest *)fetchUserSearchList;

//  删除个人查询的词汇
+ (HTBaseRequest *)deleteUserSearchWord:(NSString *)word;

/**
 *    群组聊天
 */

//  创建群组
+ (HTBaseRequest *)createGroupWithGroupName:(NSString *)groupName;

//  获取群组信息
+ (HTBaseRequest *)requestGroupInfo;

//  获取群组内的成员列表
+ (HTBaseRequest *)groupUserList:(NSString *)groupId andPageIndex:(NSInteger)index;

//  举报用户
+ (HTBaseRequest *)reportUserInGroup:(NSString *)reportUserId;

//  群外举报用户
+ (HTBaseRequest *)reportUser:(NSString *)reportUserId;


/**
 *  系统设置
 */

+ (HTBaseRequest *)requestSystemSetting;


@end
