//
//  NSObject+IsValidate.h
//  HealthChat3.0
//
//  Created by Hunter on 3/19/13.
//  Copyright (c) 2013 maomao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsValidate)


//  字符串是不是 == 0
- (BOOL)isValidate;

//  6 ~ 16
- (BOOL)isValidatePass;

//  6 ~ 32
- (BOOL)isValidatePass32;

- (BOOL)isValidate14DateStr;

- (BOOL)isValidateLength;

- (BOOL)isValidateTelPhoneNum;

- (BOOL)isValidatePhone;

- (BOOL)isValidateFaxCode;

- (BOOL)isValidateMailCode;

- (BOOL)isValidatePrice;

- (BOOL)isNumber;

- (BOOL)isValidateCardId;

- (BOOL)validateByRegular:(NSString *)regular;

- (BOOL)isFloatValue;

@end
