//
//  HTUserDefault.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTUserDefault.h"

@implementation HTUserDefault

+ (BOOL)cacheDataObj:(id)obj withKeyValue:(NSString *)keyValue
{
    BOOL isSuccess = NO;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:obj forKey:keyValue];
    isSuccess = [userDefault synchronize];
    
    return isSuccess;
}

@end
