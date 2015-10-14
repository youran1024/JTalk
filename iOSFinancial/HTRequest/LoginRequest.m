//
//  LoginRequest.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "LoginRequest.h"
#import "NSString+BaseURL.h"



@implementation LoginRequest
{
    NSString *_userName;
    NSString *_userPass;
}

- (id)initWithUserName:(NSString *)userName andUserPass:(NSString *)userPass
{
    self = [super init];
    
    if (self) {
        _userPass = userPass;
        _userName = userName;
    }

    return self;
}

- (NSString *)requestUrl
{
    return nil;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPost;
}

- (id)requestArgument
{
    NSString *ipAddress = [NSString wideIpAddress];
    
    if (isEmpty(ipAddress)) {
        ipAddress = @"";
    }
    
    return @{
             @"username": _userName,
             @"password": _userPass,
             @"ip" : ipAddress
             };
}


@end
