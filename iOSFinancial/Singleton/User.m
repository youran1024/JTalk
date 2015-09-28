//
//  User.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "User.h"

static NSString * const kUserNameKey = @"kUserNameValue";
static NSString * const kUserNickKey = @"kUserNickValue";
static NSString * const kUserNameStatus = @"real_name_status";
static NSString * const kUserMobilePhoneKey = @"kUserMobilePhone";
static NSString * const kUserToken = @"kUserToken";
static NSString * const kLastUserLoginTime = @"kLastUserLoginTime";
static NSString * const kIsBalanceIncomeOpen = @"kIsBalanceIncomeOpen";


@implementation User

+ (User *)sharedUser
{
    static User *__sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedUser = [[self alloc] init];
    });

    return __sharedUser;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _userInfo = [[UserInfoModel alloc] init];
        [_userInfo readSynchronizeData];
    }

    return self;
}

- (RCUserInfo *)rcUserinfo
{
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:_userInfo.userID name:_userInfo.userName portrait:_userInfo.userPhoto];

    return userInfo;
}

- (BOOL)isLogin
{
    _isLogin = !isEmpty(_userInfo.userToken);
    return _isLogin;
}

- (void)exchangeUserInfo
{
    [self.userInfo exchangeUserInfoWithTmp:_userInfoModelTmp];
    
    _userInfoModelTmp = nil;
}

- (UserInfoModel *)userInfoModelTmp
{
    if (!_userInfoModelTmp) {
        _userInfoModelTmp = [[UserInfoModel alloc] init];
    }
    
    return _userInfoModelTmp;
}

- (void)refreshUserInfoTmp
{
    _userInfoModelTmp = nil;
    _userInfoModelTmp = [self.userInfo copy];
}

- (UserInfoModel *)userInfo
{
    if (!_userInfo) {
        _userInfo = [[UserInfoModel alloc] init];
    }
    
    return _userInfo;
}

#pragma mark - Login Out

- (void)doLoginOut
{
    [self clearUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:__USER_LOGINOUT_SUCCESS object:nil];
}

- (void)clearUserData
{
    [_userInfo clearUserInfoData];
    
    _userInfoModelTmp = nil;
}


@end
