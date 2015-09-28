//
//  User.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import <RCIM.h>


typedef NS_ENUM(NSInteger, UserNameAuthState) {
    UserNameAuthStateUnAuth  = 0,   //  未认证
    UserNameAuthStateAuthing = 1,   //  认证中
    UserNameAuthStateAuthed  = 2,   //  认证通过
    UserNameAuthStateFailed  = 3,   //  认证失败
    UserNameAuthStateOutTime = -1   //  超过次数
};


@interface User : NSObject
{
    @private
    BOOL _isLogin;
}

@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, strong)   UserInfoModel *userInfo;

//   注册用的临时用户信息
@property (nonatomic, strong)   UserInfoModel *userInfoModelTmp;

+ (User *)sharedUser;

- (RCUserInfo *)rcUserinfo;

//  用户信息修改完成之后，用临时的替换新的
- (void)exchangeUserInfo;

//  刷新userModelTmp数据
- (void)refreshUserInfoTmp;

//  清除用户数据
- (void)clearUserData;

- (void)doLoginOut;

@end
