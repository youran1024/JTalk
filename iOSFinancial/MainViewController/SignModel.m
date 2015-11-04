//
//  SignModel.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SignModel.h"

static NSString *kSignModelTitle = @"signModelTitle";
static NSString *kSignModelTag = @"signModelTag";
static NSString *kSignModelTagType = @"signModelTagType";

@implementation SignModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.title = @"天津大事件";
        self.signTagType = SignTagTypeNormal;
        self.signTag = @"新";
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:kSignModelTitle];
        self.signTag = [aDecoder decodeObjectForKey:kSignModelTag];
        self.signTagType = [[aDecoder decodeObjectForKey:kSignModelTagType] integerValue];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kSignModelTitle];
    [aCoder encodeObject:@(self.signTagType) forKey:kSignModelTagType];
    [aCoder encodeObject:self.signTag forKey:kSignModelTag];
}

- (void)parseWithDictionary:(NSDictionary *)dic
{
    self.title = [dic stringForKey:@"word"];
    self.signTag = [dic stringForKey:@"type"];
    self.signId = [dic stringForKey:@"word_id"];
    
    if ([self.signTag isEqualToString:@"热"]) {
        self.signTagType = SignTagTypeHot;
        
    }else if ([self.signTag isEqualToString:@"新"]) {
        self.signTagType = SignTagTypeNew;
        
    }else {
        self.signTagType = SignTagTypeNormal;
    }
}

@end
