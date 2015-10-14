//
//  User.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


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


+ (User *)sharedUser;

@end
