//
//  JRJVersionManager.h
//  zhibo
//
//  Created by Mr.Yang on 14-3-21.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  版本控制
 */

@interface HTVersionManager : NSObject

//  最新的版本号
@property (nonatomic, readonly) NSString *lastVersion;
//  本地的版本号
@property (nonatomic, readonly) NSString *localVersion;

//  是否是最新的版本
@property (nonatomic, assign) BOOL isNewest;


+ (HTVersionManager *)sharedManager;


- (void)checkAppversion;

- (void)clean;

@end
