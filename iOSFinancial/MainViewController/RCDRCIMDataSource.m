//
//  RCDRCIMDelegateImplementation.m
//  RongCloud
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "RCDRCIMDataSource.h"
#import "RCDUserInfo.h"
#import "RCDGroupInfo.h"
#import "DBHelper.h"
#import "RCDataBaseManager.h"


@interface RCDRCIMDataSource ()

@end

@implementation RCDRCIMDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置信息提供者
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    }
    
    return self;
}

+ (RCDRCIMDataSource*)shareInstance
{
    static RCDRCIMDataSource* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];

    });
    return instance;
}

-(void) syncGroups
{
    //开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
    //客户端创建，然后同步
    
}

-(void) syncFriendList:(void (^)(NSMutableArray* friends))completion
{
    //  同步用户信息
    
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString*)groupId completion:(void (^)(RCGroup*))completion
{
    if ([groupId length] == 0)
        return;
    
    //开发者调自己的服务器接口根据userID异步请求数据
    HTBaseRequest *request = [HTBaseRequest requestGroupInfo];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray * array = [dic arrayForKey:@"result"];
            NSString *groupName;
            for (NSDictionary *dic in array) {
                NSString *group_id = [dic stringForKey:@"group_id"];
                if ([group_id isEqualToString:groupId]) {
                    groupName = [dic stringForKey:@"group_name"];
                    break;
                }
            }
            
            RCGroup *group = [[RCGroup alloc] initWithGroupId:groupId groupName:groupName portraitUri:@"appIcon"];
            
            completion(group);
            
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        
    }];
    
}
 
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    HTBaseRequest *request = [HTBaseRequest otherUserInfo:userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dic = [request.responseJSONObject dictionaryForKey:@"result"];
        NSString *userName = [dic stringForKey:@"name"];
        NSString *userPortrait = [dic stringForKey:@"photo"];
        
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:userName portrait:userPortrait];
        
        completion(userInfo);
        
    }];
    
}
- (void)cacheAllUserInfo:(void (^)())completion
{

    
}

- (void)cacheAllGroup:(void (^)())completion
{
    
    
}

- (void)cacheAllFriends:(void (^)())completion
{
    
    
}
- (void)cacheAllData:(void (^)())completion
{
    
    
}

- (NSArray *)getAllUserInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllUserInfo];
    if (!allUserInfo.count) {
       [self cacheAllUserInfo:^{
           completion();
       }];
    }
    return allUserInfo;
}

/*
 * 获取所有群组信息
 */
- (NSArray *)getAllGroupInfo:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllGroup];
    if (!allUserInfo.count) {
        [self cacheAllGroup:^{
            completion();
        }];
    }
    return allUserInfo;
}

- (NSArray *)getAllFriends:(void (^)())completion
{
    NSArray *allUserInfo = [[RCDataBaseManager shareInstance] getAllFriends];
    if (!allUserInfo.count) {
        [self cacheAllFriends:^{
            completion();
        }];
    }
    return allUserInfo;
}
@end
