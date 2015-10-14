//
//  SystemConfig.h
//  JRJNews
//
//  Created by Mr.Yang on 14-3-28.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


/*---------------------------- 运行环境 ------------------------------*/

//  测试环境  1
//  线上环境  0

#define __APP_TEST__  1


#if __APP_TEST__

static NSString *jTalkServerURL     = @"http://182.92.78.106";
static NSString *qiNiuCloudServerURL = @"http://7xlrvb.com2.z0.glb.qiniucdn.com";//@"http://7xlo3b.com2.z0.glb.qiniucdn.com";

#else

static NSString *jTalkServerURL     = nil;

#endif




