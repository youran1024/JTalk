
//  Created by Hunter on 13-03-16.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "NSDictionary+JSONExtern.h"

@implementation NSDictionary (JSONExtern)

- (NSString *)stringForKey:(id)key
{
    NSString * const kEmptyStrings = @"";
    NSString *result = [self objectForKey:key];
    if([result isKindOfClass:[NSString class]])
    {
        return result;
        
    }else if ([result isKindOfClass:[NSNumber class]]){
        return [NSString stringWithFormat:@"%lf", [result doubleValue]];
    }
        return kEmptyStrings;
}

- (NSString *)stringNoneForKey:(id)key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        NSString *resultStr = result;
        if (resultStr.length == 0) {
            return @"暂无数据";
        }
        
        return result;
    }
    
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%ld", (long)[result integerValue]];
    }
    
    return @"暂无数据";
}

#pragma mark - double
- (NSString *)stringDoubleValueForKey:(id) key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%lf", [result doubleValue]];
    }
    return @"";
}

#pragma mark - intenger
- (NSString *)stringIntForKey:(id)key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%ld", (long)[result integerValue]];
    }
    
    return @"";
}

#pragma mark - float
- (NSString *)stringFloatForKey:(id)key
{
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%.2f", [result floatValue]];
    }
    return @"";
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    NSDictionary *result = [self objectForKey:key];
    if([result isKindOfClass:[NSDictionary class]])
    {
        return result;
    }
    
    return nil;
}

// jason: return nil if the object is null or not a NSArray.
- (NSArray *)arrayForKey:(id)key
{
    NSArray *result = [self objectForKey:key];
    if([result isKindOfClass:[NSArray class]])
    {
        return result;
    }
    return nil;
}

@end
