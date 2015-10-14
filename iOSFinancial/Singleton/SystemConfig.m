//
//  SystemConfig.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/28.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SystemConfig.h"

static NSString *kIndexPageBackImage = @"kIndexPageBackImage";
static NSString *kPersonalBackImage = @"kPersonalBackImage";
static NSString *kQiNiuCloudToken = @"kQiNiuCloudToken";

@implementation SystemConfig
@synthesize firstIndexBackImage = _firstIndexBackImage;
@synthesize personalBackImage = _personalBackImage;
@synthesize qiniuCloudToken = _qiniuCloudToken;


+ (SystemConfig *)defaultConfig
{
    static SystemConfig *__systemConfig = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __systemConfig = [[self alloc] init];
    });
    
    return __systemConfig;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        if (!self.firstIndexBackImage) {
            //  如果从本地读取的为空，则使用默认的图片
            self.firstIndexBackImage = @"findMoreImage1";
        }
        
        if (!self.personalBackImage) {
            self.personalBackImage = @"personal1";
        }
    }

    return self;
}

- (NSString *)qiniuCloudToken
{
    if (!_qiniuCloudToken) {
        _qiniuCloudToken = [HTUserDefaults valueForKey:kQiNiuCloudToken];
    }
    
    return _qiniuCloudToken;
}

- (void)setQiniuCloudToken:(NSString *)qiniuCloudToken
{
    if (![_qiniuCloudToken isEqualToString:qiniuCloudToken]) {
        _qiniuCloudToken = qiniuCloudToken;
        [self saveValue:_qiniuCloudToken forKey:kQiNiuCloudToken];
    }
}

- (NSString *)personalBackImage
{
    if (!_personalBackImage) {
        _personalBackImage = [HTUserDefaults valueForKey:kPersonalBackImage];
    }
    
    return _personalBackImage;
}

- (void)setPersonalBackImage:(NSString *)personalBackImage
{
    if (![_personalBackImage isEqualToString:personalBackImage]) {
        _personalBackImage = personalBackImage;
        [self saveValue:_personalBackImage forKey:kPersonalBackImage];
    }
}

- (NSString *)firstIndexBackImage
{
    if (!_firstIndexBackImage) {
        _firstIndexBackImage = [HTUserDefaults valueForKey:kIndexPageBackImage];
    }
    
    return _firstIndexBackImage;
}

- (void)setFirstIndexBackImage:(NSString *)firstIndexBackImage
{
    if (![_firstIndexBackImage isEqualToString:firstIndexBackImage]) {
        _firstIndexBackImage = firstIndexBackImage;
        [self saveValue:_firstIndexBackImage forKey:firstIndexBackImage];
    }
}

- (void)saveValue:(id)value forKey:(NSString *)key
{
    [HTUserDefaults setValue:value forKey:key];
    [HTUserDefaults synchronize];
}

- (void)synchronize
{
    HTBaseRequest *request = [HTBaseRequest requestSystemSetting];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger state = [[dic stringIntForKey:@"code"] integerValue];
        if (state == 200) {
            dic = [dic dictionaryForKey:@"result"];
            //  succes
            NSString *mainImageStr = [dic stringForKey:@"main_back_img"];
            if (!isEmpty(mainImageStr)) {
                self.firstIndexBackImage = mainImageStr;
            }
            
            NSString *qiNiuToken = [dic stringForKey:@"qiniu_token"];
            if (!isEmpty(qiNiuToken)) {
                self.qiniuCloudToken = qiNiuToken;
            }
            
            NSString *qiniu_token_domain = [dic stringForKey:@"qiniu_token_domain"];
            if (!isEmpty(qiniu_token_domain)) {
                self.qiniuServiceServer = qiniu_token_domain;
            }
        }  
        
    } failure:^(YTKBaseRequest *request) {
        
        
    }];
}



@end
