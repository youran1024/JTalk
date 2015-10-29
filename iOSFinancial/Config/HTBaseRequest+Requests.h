//
//  HTBaseRequest+Requests.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseRequest.h"

@interface HTBaseRequest (Requests)

+ (HTBaseRequest *)userRegister;

+ (HTBaseRequest *)userInfoEdit;

+ (HTBaseRequest *)userLogin;

+ (HTBaseRequest *)resetUserPass;

//  获取个人信息
+ (HTBaseRequest *)getUserInfo:(NSString *)getUserId;

//  首页热门词汇
+ (HTBaseRequest *)hotWordList;

/**
 *    拉黑
 */

//  拉黑用户
+ (HTBaseRequest *)pullUserToBlackList:(NSString *)userId;

//  查获黑名单列表 //get
+ (HTBaseRequest *)fetchBlackList;

//  移除拉黑用户
+ (HTBaseRequest *)removeUserFromBlackList:(NSString *)userId;

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
+ (HTBaseRequest *)reportUserInGroup:(NSString *)reportUserId andReportType:(NSInteger)type;

//  群外举报用户
+ (HTBaseRequest *)reportUser:(NSString *)reportUserId anReportType:(NSInteger)type;


/**
 *  系统设置
 */

+ (HTBaseRequest *)requestSystemSetting;


@end
