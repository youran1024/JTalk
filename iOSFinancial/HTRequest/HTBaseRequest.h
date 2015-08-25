//
//  HTBaseRequest.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "YTKBaseRequest.h"
#import "ServerHostConfig.h"

@interface HTBaseRequest : YTKBaseRequest

@property (nonatomic, assign)   YTKRequestMethod requestMethod;
@property (nonatomic, copy)     NSString *detailUrl;
@property (nonatomic, strong)   NSMutableDictionary *requestParam;

//  是否允许显示错误信息
@property (nonatomic, assign)   BOOL shouldShowErrorMsg;


+ (instancetype)requestWithURL:(NSString *)detailURL;

- (instancetype)initWithURL:(NSString *)detailURL;

- (void)addValue:(id)value forKey:(NSString *)key;

//  添加请求的参数
//  get
- (void)addGetValue:(id)value forKey:(NSString *)key;
//  post
- (void)addPostValue:(id)value forKey:(NSString *)key;
//  put
- (void)addPutValue:(id)value forKey:(NSString *)key;
//  delete
- (void)addDelValue:(id)value forKey:(NSString *)key;

//  GetPost Method
- (void)setGetRequestParam:(NSDictionary *)paramDic;
//  Post
- (void)setPostRequestParam:(NSDictionary *)paramDic;
//  Put
- (void)setPutRequestParam:(NSDictionary *)paramDic;

- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success;


@end
