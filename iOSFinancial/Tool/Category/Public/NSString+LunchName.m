//
//  NSString+LunchName.m
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 15/2/5.
//  Copyright (c) 2015年 jrj. All rights reserved.
//

#import "NSString+LunchName.h"

@implementation NSString (LunchName)

+ (NSString *)lunchImageNamed:(NSString *)lunchName
{
    NSString *imageStr = nil;
    if (is4Inch) {
        imageStr = @"700-568h";
    }else if (is47Inch) {
        imageStr = @"800-667h";
    }else if (is55Inch) {
        imageStr = @"800-Portrait-736h";
    }else {
        imageStr = @"700";
    }
    
    return [NSString stringWithFormat:@"%@-%@", lunchName, imageStr];
}

@end
