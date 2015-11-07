//
//  HTBaseRequest+Requests.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseRequest+Requests.h"
#import "ServerHostConfig.h"
#import "NSString+URLEncoding.h"

#define HTRequestWithUserInfoByURL(__url_)  [[HTBaseRequest requestWithURL:__url_] addUserId]


@implementation HTBaseRequest (Requests)

+ (HTBaseRequest *)userRegisteCheck:(UserLoginType)loginType userId:(NSString *)userId
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/exists");
    [request addPostValue:userId forKey:@"id"];
    [request addPostValue:@(loginType) forKey:@"type"];
    
    return request;
}

/**
 *  用户信息
 */
//------------------------------------

+ (HTBaseRequest *)userRegister
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/register");
    [request addUserInfoEdit:NO];
    
    return request;
}

+ (HTBaseRequest *)userInfoEdit
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/edit");
    [request addUserInfoEdit:YES];
    
    return request;
}

/**
 *  用户登录
 */
//------------------------------------

+ (HTBaseRequest *)userLogin
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/login");

    [request addRegeditUserInfo];
    
    return request;
}


/**
 *  获取用户信息
 */
//------------------------------------

+ (HTBaseRequest *)getUserInfo:(NSString *)getUserId
{
    if (!getUserId.length) {
        getUserId = __userInfoId;
    }
    
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/get");
    [request addPostValue:getUserId forKey:@"get_user_id"];
    
    return request;
}

/**
 *  找回密码
 */
//------------------------------------

+ (HTBaseRequest *)resetUserPass
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    HTBaseRequest *request = HTRequestWithURL(@"/user/pwd");
    
    [request addPostValue:userInfo.userPhone forKey:@"phone"];
    [request addPostValue:userInfo.userPass forKey:@"pwd"];
    
    return request;
}

/**
 *  首页热词列表
 */
//------------------------------------

+ (HTBaseRequest *)hotWordList
{
    HTBaseRequest *request = HTRequestWithURL(@"/main/words");
    [request addPostValue:__userInfoId forKey:@"user_id"];
    [request addPostValue:@(0) forKey:@"type"];
    
    return request;
}

/**
 *    拉黑
 */
//------------------------------------

//  拉黑用户
+ (HTBaseRequest *)pullUserToBlackList:(NSString *)userId
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/black/add");
    [request addValue:userId forKey:@"black_user_id"];
    
    return request;
}

//  查获黑名单列表 //get
+ (HTBaseRequest *)fetchBlackList
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/black/list");
    
    return request;
}

//  从用户拉黑列表移除
+ (HTBaseRequest *)removeUserFromBlackList:(NSString *)userId
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/black/delete");
    [request addPostValue:userId forKey:@"black_user_id"];

    return request;
}

/**
 *  用户搜索
 */
//------------------------------------

//  记录用户检索词汇
+ (HTBaseRequest *)recoderUserSearchWord:(NSString *)word
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/search/submit");
    [request addValue:word forKey:@"word"];
    
    request.shouldShowErrorMsg = NO;
    
    return request;
}

//  查询个人检索词历史
+ (HTBaseRequest *)fetchUserSearchList
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/group/list");
    
    return request;
}

//  删除个人查询的词汇
+ (HTBaseRequest *)deleteUserSearchWord:(NSString *)word
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"words/delete");
    
    [request addValue:word forKey:@"word"];
    
    return request;
}

/**
 *    群组聊天
 */

//  创建群组
+ (HTBaseRequest *)createGroupWithGroupName:(NSString *)groupName
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/group/create");
    [request addPostValue:groupName forKey:@"word"];
    
    return request;
}

+ (HTBaseRequest *)requestGroupInfoById:(NSString *)groupId
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/group/get");
    [request addPostValue:groupId forKey:@"group_id"];
    
    return request;
}

// 群成员列表
+ (HTBaseRequest *)groupUserList:(NSString *)groupId andPageIndex:(NSInteger)index
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/group/user/list");
    [request addPostValue:groupId forKey:@"group_id"];
    [request addPostValue:@(index) forKey:@"page_index"];
    
    return request;
}

//  群里举报用户
+ (HTBaseRequest *)reportUserInGroup:groupId andReporterId:(NSString *)reportUserId andReportType:(NSInteger)type
{
    //  1.色情， 2.广告 3.骚扰 4.诈骗
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/group/user/report");
    [request addPostValue:reportUserId forKey:@"report_user_id"];
    [request addPostValue:@(type) forKey:@"type"];
    
    return request;
}

+ (HTBaseRequest *)reportUser:(NSString *)reportUserId andReportType:(NSInteger)type
{
    HTBaseRequest *request = HTRequestWithUserInfoByURL(@"/user/report");
    [request addPostValue:reportUserId forKey:@"report_user_id"];
    [request addPostValue:@(type) forKey:@"type"];
    
    return request;
}


/**
 *  系统设置
 */

+ (HTBaseRequest *)requestSystemSetting
{
    HTBaseRequest   *request = HTRequestWithUserInfoByURL(@"/sys/setting");
    request.shouldShowErrorMsg = NO;
    
    return request;
}

/**
 *  Functions
 */

- (void)addUserInfoEdit:(BOOL)isEdit
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    if (isEdit) {
        //  修改用户资料
        [self addPostValue:userInfo.userID forKey:@"user_id"];
        
    }else {
        //  注册用户
        [self addRegeditUserInfo];
    }

    [self addPostValue:userInfo.userName forKey:@"name"];
    [self addPostValue:userInfo.userPrompt forKey:@"signature"];
    
    NSInteger sex = [userInfo.userSex isEqualToString:@"男"] ? 1 : 2;
    [self addPostValue:@(sex) forKey:@"sex"];
    [self addPostValue:userInfo.userLocation forKey:@"region"];
    [self addPostValue:userInfo.userPhone forKey:@"phone"];
    
    [self addPostValue:[userInfo.userPhoto URLEncodedString] forKey:@"photo"];
}

- (void)addRegeditUserInfo
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    //  注册用户
    if (userInfo.userLoginType == UserLoginTypePhone) {
        [self addPostValue:userInfo.userPhone forKey:@"id"];
        [self addPostValue:userInfo.userPass forKey:@"pwd"];
        
    }else {
        [self addPostValue:userInfo.userID forKey:@"id"];
        [self addPostValue:userInfo.userName forKey:@"name"];
        [self addPostValue:userInfo.userPhoto forKey:@"photo"];
    }
    
    [self addPostValue:@(userInfo.userLoginType) forKey:@"type"];
}

- (HTBaseRequest *)addUserId
{
    [self addPostValue:__userInfoId forKey:@"user_id"];
    
    return self;
}



@end
