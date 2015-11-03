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

static NSString *jTalkServer         = @"http://api.dev.xxxxtalk.com";
static NSString *qiNiuCloudServerURL = @"http://7xlrvb.com2.z0.glb.qiniucdn.com";

#else

static NSString *jTalkServer         = @"http://api.xxxxtalk.com";
static NSString *qiNiuCloudServerURL = @"http://7xlrvb.com2.z0.glb.qiniucdn.com";

#endif




