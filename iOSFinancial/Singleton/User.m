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
        
    }

    return self;
}

@end
