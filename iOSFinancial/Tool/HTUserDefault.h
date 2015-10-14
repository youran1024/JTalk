//
//  HTUserDefault.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTUserDefault : NSObject

+ (BOOL)cacheDataObj:(id)obj withKeyValue:(NSString *)keyValue;

@end
