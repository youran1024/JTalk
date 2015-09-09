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

@implementation SystemConfig

+ (SystemConfig *)sharedConfig
{
    static SystemConfig *__systemConfig = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __systemConfig = [[self alloc] init];
    });
    
    return __systemConfig;
}

- (void)setPersonalBackImage:(NSString *)personalBackImage
{
    if (![_personalBackImage isEqualToString:personalBackImage]) {
        _personalBackImage = personalBackImage;
        [self saveValue:_personalBackImage forKey:kPersonalBackImage];
    }
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


@end
