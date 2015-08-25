//
//  LoginRequest.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseRequest.h"

@interface LoginRequest : HTBaseRequest

- (id)initWithUserName:(NSString *)userName andUserPass:(NSString *)userPass;

@end
