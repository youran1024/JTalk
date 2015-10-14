//
//  SystemConfig.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/28.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfig : NSObject

@property (nonatomic, copy) NSString *firstIndexBackImage;
@property (nonatomic, copy) NSString *personalBackImage;
@property (nonatomic, copy) NSString *qiniuCloudToken;
@property (nonatomic, copy) NSString *qiniuServiceServer;


+ (SystemConfig *)defaultConfig;

@end


