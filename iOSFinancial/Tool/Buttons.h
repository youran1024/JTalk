//
//  Buttons.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/28.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Buttons : NSObject

+ (UIButton *)buttonWithTitle:(NSString *)title andTarget:(id)target andSelector:(SEL)selector;

@end
