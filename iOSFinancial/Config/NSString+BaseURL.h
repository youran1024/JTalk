//
//  NSString+BaseURL.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHostConfig.h"

/*
*  NOTE:接口文档地址
*  URL:https://github.com/jiandanlicai/earth/blob/master/dev_docs/app_api_v1.0.1.md
*/

@interface NSString (BaseURL)

//  硬件版本号
+ (NSString *)platform;

+ (NSString*)machineName;

+ (NSString *)wideIpAddress;
//  判断网络环境
+ (int)dataNetworkTypeFromStatusBar;

/*-------------------------  APP  --------------------------*/

//  用户信息 (注册(post), 获取(get), 编辑(put))
+ (NSString *)user;



@end
