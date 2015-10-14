//
//  NSObject+IsValidate.m
//  HealthChat3.0
//
//  Created by Hunter on 3/19/13.
//  Copyright (c) 2013 maomao. All rights reserved.
//
#import "NSString+IsValidate.h"

#define isValidateString  [self validateByRegular:reg]  

@implementation NSString (IsValidate)

- (BOOL)validateByRegular:(NSString *)regular{
    NSTextCheckingResult *result = [[[NSRegularExpression alloc] initWithPattern:regular options:0 error:nil] firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return result != nil;
}

- (BOOL)isValidate
{
    return self.length > 0;
}

- (BOOL)isValidatePass
{
    return self.length > 5 && self.length < 17;
}

- (BOOL)isValidatePass32
{
    return self.length > 5 && self.length < 17;
}


//-------------------------------------------------------
//  检查字符串型日期是否合法符合服务器12位
//-------------------------------------------------------

- (BOOL)isValidate14DateStr
{
    if (![self isKindOfClass:[NSString class]] || [self length] < 13) {
        return NO;
    }
    return YES;
}

//-------------------------------------------------------
//  检查长度是不是零
//-------------------------------------------------------

- (BOOL)isValidateLength
{
    return self.length > 0;
}

//  验证有两位小数的正实数
//-------------------------------------------------------
- (BOOL)isValidatePrice
{
    NSString *reg = @"^[0-9]+(.[0-9]{2})?$";
    return isValidateString;
}

//-------------------------------------------------------
//  检查电话号码
//-------------------------------------------------------
- (BOOL)isValidateTelPhoneNum
{
    //电话号和手机号
    NSString *reg = @"(^(\\d{3,4}-)?\\d{7,8})$|(13[0-9]{9})";
    return isValidateString;
}

//#13,14,15,18开头
- (BOOL)isValidatePhone
{
//    NSString *reg = @"/^(?:13\\d|14|15|18)-?\\d{5}(\\d{3}|\\*{3})$/";
    NSString *reg = @"^0?(13[0-9]|15[0-9]|17[0-9]|18[0-9]|14[57])[0-9]{8}$";
    return isValidateString;
}

//-------------------------------------------------------
//  检查座机电话号码和传真号，可以“+”开头，除数字外，可含有“-”
//-------------------------------------------------------
- (BOOL)isValidateFaxCode
{
    NSString *reg = @"/^[+]{0,1}(\\d){1,3}[ ]?([-]?((\\d)|[ ]){1,12})+$/";
    return isValidateString;
}

//-------------------------------------------------------
// 校验邮政编码
//-------------------------------------------------------
- (BOOL)isValidateMailCode
{
    NSString *reg = @"/^[+]{0,1}(\\d){1,3}[ ]?([-]?((\\d)|[ ]){1,12})+$/";
    return isValidateString;
}

- (BOOL)isNumber
{
    //NSString *reg = @"[0-9]+(.[0-9]+)?";//
//    NSString *reg = @"^\\d*\\.?\\d?$";
    NSString *reg = @"[0-9]";
    return isValidateString;
}

- (BOOL)isFloatValue
{
    NSString *reg = @"[0-9]+(.[0-9]+)?";//
    return isValidateString;
}

//-------------------------------------------------------
// 身份证验证
//-------------------------------------------------------

- (BOOL)isValidateCardId
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

@end
