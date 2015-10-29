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


@implementation HTBaseRequest (Requests)

/**
 *  用户信息
 */
//------------------------------------

+ (HTBaseRequest *)userRequest:(YTKRequestMethod)requestMethod
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user"];
    request.requestMethod = requestMethod;
    [request addUserId];
    
    return request;
}

+ (HTBaseRequest *)regeditNewAccount
{
    HTBaseRequest *request = [self userRequest:YTKRequestMethodPost];
    [request addUserInfoEdit:NO];
    
    return request;
}

+ (HTBaseRequest *)editUserInfo
{
    HTBaseRequest *request = [self userRequest:YTKRequestMethodPut];
    [request addUserInfoEdit:YES];
    
    return request;
}

+ (HTBaseRequest *)getUserInfo
{
    return [HTBaseRequest userRequest:YTKRequestMethodGet];
}

/**
 *  用户登录
 */
//------------------------------------

+ (HTBaseRequest *)loginWithUserInfo
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/login"];
    request.requestMethod = YTKRequestMethodPost;
    [request addRegeditUserInfo];
    
    return request;
}


/**
 *  其他用户信息
 */
//------------------------------------

+ (HTBaseRequest *)otherUserInfo:(NSString *)otherUserId
{
    if (!otherUserId.length) {
        NSLog(@"otherUserId is nil %@", otherUserId);
        return nil;
    }
    
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/other"];
    [request addGetValue:otherUserId forKey:@"other_user_id"];
    [request addGetValue:__userInfoId forKey:@"user_id"];
    
    return request;
}


/**
 *  找回密码
 */
//------------------------------------

+ (HTBaseRequest *)resetUserPass
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/pwd"];
    
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
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/words"];
    [request addGetValue:__userInfoId forKey:@"user_id"];
    [request addGetValue:@(0) forKey:@"type"];
    
    return request;
}

/**
 *    拉黑
 */
//------------------------------------

+ (HTBaseRequest *)pullBlackUserRequest:(YTKRequestMethod)requestMethod
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/black"];
    request.requestMethod = requestMethod;
    [request addUserId];
    
    return request;
}

//  查获黑名单列表 //get
+ (HTBaseRequest *)fetchBlackUserList
{
    HTBaseRequest *request = [self pullBlackUserRequest:YTKRequestMethodGet];
    
    return request;
}

//  拉黑用户
+ (HTBaseRequest *)pullBlackUser:(NSString *)userId
{
    HTBaseRequest *request = [self pullBlackUserRequest:YTKRequestMethodPut];
    [request addValue:userId forKey:@"black_user_id"];
    
    return request;
}

//  从用户拉黑列表移除
+ (HTBaseRequest *)removeUserFromPullBlackList:(NSString *)userId
{
    HTBaseRequest *request = [self pullBlackUserRequest:YTKRequestMethodDelete];
    [request addValue:userId forKey:@"black_user_id"];

    return request;
}

/**
 *  用户搜索
 */
//------------------------------------

+ (HTBaseRequest *)userSearchRequest:(YTKRequestMethod)requestMethod
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/search"];
    request.requestMethod = requestMethod;
    [request addUserId];
    
    return request;
}

//  记录用户检索词汇
+ (HTBaseRequest *)recoderUserSearchWord:(NSString *)word
{
    HTBaseRequest *request = [self userSearchRequest:YTKRequestMethodPost];
    [request addValue:word forKey:@"word"];
    request.shouldShowErrorMsg = NO;
    
    return request;
}

//  查询个人检索词历史
+ (HTBaseRequest *)fetchUserSearchList
{
    HTBaseRequest *request = [self userSearchRequest:YTKRequestMethodGet];
    
    return request;
}

//  删除个人查询的词汇
+ (HTBaseRequest *)deleteUserSearchWord:(NSString *)word
{
    HTBaseRequest *request = [self userSearchRequest:YTKRequestMethodDelete];
    [request addValue:word forKey:@"word"];
    
    return request;
}

/**
 *    群组聊天
 */

//  创建群组
+ (HTBaseRequest *)createGroupWithGroupName:(NSString *)groupName
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/group/create"];
    [request addUserId];
    [request addGetValue:groupName forKey:@"word"];
    
    return request;
}

+ (HTBaseRequest *)requestGroupInfo
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/group"];
    [request addUserId];
    request.requestMethod = YTKRequestMethodGet;
    
    return request;
}

// 群成员列表
+ (HTBaseRequest *)groupUserList:(NSString *)groupId andPageIndex:(NSInteger)index
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/group/user/list"];
    [request addUserId];
    [request addGetValue:groupId forKey:@"group_id"];
    [request addGetValue:@(index) forKey:@"page_index"];
    
    return request;
}

//  群里举报用户
+ (HTBaseRequest *)reportUserInGroup:(NSString *)reportUserId andReportType:(NSInteger)type
{
    //  1.色情， 2.广告 3.骚扰 4.诈骗
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/group/user/report"];
    [request addUserId];
    [request addPostValue:reportUserId forKey:@"report_user_id"];
    [request addPostValue:@(type) forKey:@"type"];
    
    return request;
}

+ (HTBaseRequest *)reportUser:(NSString *)reportUserId anReportType:(NSInteger)type
{
    HTBaseRequest *request = [HTBaseRequest requestWithURL:@"/user/report"];
    [request addUserId];
    [request addPostValue:reportUserId forKey:@"report_user_id"];
    [request addPostValue:@(type) forKey:@"type"];
    
    return request;
}


/**
 *  系统设置
 */

+ (HTBaseRequest *)requestSystemSetting
{
    HTBaseRequest   *request = [HTBaseRequest requestWithURL:@"/sys/setting"];
    request.shouldShowErrorMsg = NO;
    [request addUserId];
    request.requestMethod = YTKRequestMethodGet;
    
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
        [self addValue:userInfo.userID forKey:@"user_id"];
        
    }else {
        //  注册用户
        [self addRegeditUserInfo];
    }

    [self addValue:userInfo.userName forKey:@"name"];
    [self addValue:userInfo.userPrompt forKey:@"signature"];
    
    NSInteger sex = [userInfo.userSex isEqualToString:@"男"] ? 1 : 2;
    [self addValue:@(sex) forKey:@"sex"];
    [self addValue:userInfo.userLocation forKey:@"region"];
    [self addValue:userInfo.userPhone forKey:@"phone"];
    
    [self addValue:[userInfo.userPhoto URLEncodedString] forKey:@"photo"];
}

- (void)addRegeditUserInfo
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    //  注册用户
    [self addValue:userInfo.userPhone forKey:@"id"];
    [self addValue:userInfo.userPass forKey:@"pwd"];
    [self addValue:@(userInfo.userLoginType) forKey:@"type"];
}

- (void)addUserId
{
    [self addValue:__userInfoId forKey:@"user_id"];
}



@end
