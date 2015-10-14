//
//  NSString+Size.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-16.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFont:(UIFont *)font
{
   return [self sizeWithFont:font maxSize:CGSizeMake(APPScreenWidth, NSIntegerMax)];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic
                              context:nil
            ].size;
}

//  MARK: 数字格式化
- (NSString *)formatNumberString
{
    NSRange range = [self rangeOfString:@"."];
    NSString *decimal = @"";
    NSString *integer = self;
    if (range.length > 0) {
        decimal = [self substringFromIndex:range.location];
        integer = [self substringToIndex:range.location];
    }
    
    NSInteger num = integer.length / 3;
    NSInteger num1 = integer.length % 3;
    if (num1 == 0) {
        num -= 1;
    }
    
    NSMutableString *integerMut = [NSMutableString stringWithString:integer];
    if (num > 0) {
        for (NSInteger i = 0; i < num; i++) {
            NSInteger index = 3 * (i + 1) + i;
            [integerMut insertString:@"," atIndex:integerMut.length - index];
        }
    }
    
    [integerMut appendString:decimal];
    
    return integerMut;
}

@end
