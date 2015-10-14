//
//  HTBaseRequest.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseRequest.h"
#import "HTVersionManager.h"
#import "AppDelegate.h"
#import "HTBaseViewController.h"


@interface HTBaseRequest () <YTKRequestDelegate>

@end

@implementation HTBaseRequest

+ (instancetype)requestWithURL:(NSString *)detailURL
{
    HTBaseRequest *request = [[HTBaseRequest alloc] initWithURL:detailURL];
    
    return request;
}

- (instancetype)initWithURL:(NSString *)detailURL
{
    self = [super init];
    
    if (self) {
        _shouldShowErrorMsg = YES;
        
        self.delegate = self;
        _detailUrl = [detailURL copy];
    }
    
    return self;
}

//  15s超时
- (NSTimeInterval)requestTimeoutInterval {
    return 15;
}

#pragma mark - RequestDelegate

- (void)requestFinished:(YTKBaseRequest *)request
{
    NSInteger responseCode = [[request.responseJSONObject stringForKey:@"code"] integerValue];
    
    if (responseCode != 200 && _shouldShowErrorMsg) {
        
        NSLog(@"requestError:%@%@", request.baseUrl, request.requestUrl);
        HTBaseViewController *viewController = [self viewControllerOnScreen];
        NSString *message = [request.responseJSONObject stringForKey:@"message"];
        [viewController showHudErrorView:message];
    }
}

- (void)requestFailed:(YTKBaseRequest *)request
{
    NSLog(@"requestFalied:%@%@", request.baseUrl, request.requestUrl);
    
    HTBaseViewController *viewController = [self viewControllerOnScreen];
    
    if (viewController && _shouldShowErrorMsg) {
        [viewController showHudErrorView:PromptTypeError];
    }
}

- (HTBaseViewController *)viewControllerOnScreen
{
    AppDelegate *sharedApplication = [UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = sharedApplication.tabBarController.selectedViewController;
    
    if ([rootViewController isKindOfClass:[HTNavigationController class]]) {
        rootViewController = ((HTNavigationController *)rootViewController).visibleViewController;
    }
    
    if ([rootViewController isKindOfClass:[HTBaseViewController class]]) {
        return (HTBaseViewController *)rootViewController;
    }
    
    return nil;
}

#pragma mark - RequestEnd

- (YTKRequestMethod)requestMethod
{
    if (!_requestMethod) {
        _requestMethod = YTKRequestMethodGet;
    }
    
    return _requestMethod;
}

/// 请求的BaseURL
- (NSString *)baseUrl
{
    return jTalkServerURL;
}

/// 在HTTP报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    
    [mutDic setValue:@"iOS" forKey:@"paltid"];
    HTVersionManager *manager = [HTVersionManager sharedManager];
    [mutDic setValue:manager.localVersion forKey:@"appver"];
    UIDevice *device = [UIDevice currentDevice];
    
    //  硬件版本
    [mutDic setValue:device.model forKey:@"model"];
    
    [mutDic setValue:device.localizedModel forKey:@"localizedModel"];
    //  系统名称
    [mutDic setValue:device.systemName forKey:@"systemName"];
    //  系统版本号
    [mutDic setValue:device.systemVersion forKey:@"systemVersion"];
    
    [mutDic setValue:__RongYunKey_ forKey:@"App-Key"];
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    NSString *randm = HTSTR(@"%d", rand());
    [mutDic setValue:randm forKey:@"Nonce"];

    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    [mutDic setValue:timeSp forKey:@"Timestamp"];
    
    return mutDic;
}

//  返回具体的url
- (NSString *)requestUrl
{
    return _detailUrl;
}

- (id)requestArgument
{
    return _requestParam;
}

- (NSMutableDictionary *)requestParam
{
    if (!_requestParam) {
        _requestParam = [NSMutableDictionary dictionary];
    }
    
    return _requestParam;
}

- (void)addValue:(id)value forKey:(NSString *)key
{
    if (value && key) {
        [self.requestParam setValue:value forKey:key];
    }
}

#pragma mark - addRequestMethod

- (void)addGetValue:(id)value forKey:(NSString *)key
{
    [self addRequestValue:value forKey:key byMethod:YTKRequestMethodGet];
}

- (void)addPostValue:(id)value forKey:(NSString *)key
{
    [self addRequestValue:value forKey:key byMethod:YTKRequestMethodPost];
}

- (void)addPutValue:(id)value forKey:(NSString *)key
{
    [self addRequestValue:value forKey:key byMethod:YTKRequestMethodPut];
}

- (void)addDelValue:(id)value forKey:(NSString *)key
{
    [self addRequestValue:value forKey:key byMethod:YTKRequestMethodDelete];
}

- (void)addRequestValue:(id)value forKey:(NSString *)key byMethod:(YTKRequestMethod)method
{
    if (value && key) {
        _requestMethod = method;
        [self.requestParam setValue:value forKey:key];
    }
}

#pragma mark - SetDictionary

- (void)setGetRequestParam:(NSDictionary *)paramDic
{
   [self setRequestMethod:YTKRequestMethodGet ParamDic:paramDic];
}

- (void)setPostRequestParam:(NSDictionary *)paramDic
{
    [self setRequestMethod:YTKRequestMethodPost ParamDic:paramDic];
}

- (void)setPutRequestParam:(NSDictionary *)paramDic
{
    [self setRequestMethod:YTKRequestMethodPut ParamDic:paramDic];
}

- (void)setRequestMethod:(YTKRequestMethod)requestMethod ParamDic:(NSDictionary *)paramDic
{
    if (paramDic && [paramDic isKindOfClass:[NSDictionary class]]) {
        _requestMethod = requestMethod;
        _requestParam = [paramDic mutableCopy];
    }
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(YTKBaseRequest *request))success
{
    [self setCompletionBlockWithSuccess:success failure:nil];
    [self start];
}


@end
