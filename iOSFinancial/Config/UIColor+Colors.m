//
//  UIColor+Colors.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/23.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)jt_lightGrayColor
{
    return [UIColor colorWithHEX:0xdad9d9];
}

+ (UIColor *)jt_backgroudColor
{
    return [UIColor colorWithHEX:0xf8f8f8];
}

+ (UIColor *)jd_settingDetailColor
{
    return [UIColor colorWithHEX:0xf76425];
}

//  黑色深色值
+ (UIColor *)jt_darkBlackTextColor
{
    return [UIColor colorWithHEX:0x333333];
}

//  黑色中间值
+ (UIColor *)jt_globleTextColor
{
    return [UIColor colorWithHEX:0x666666];
}

//  黑色浅色值
+ (UIColor *)jt_lightBlackTextColor
{
    return [UIColor colorWithHEX:0xcccccc];
}

+ (UIColor *)jt_lineColor
{
    return [UIColor colorWithHEX: 0xe6e6e6];
}

+ (UIColor *)jt_barTintColor
{
    return [UIColor colorWithHEX:0xea5414];
}

+ (UIColor *)jd_textGray2Color;
{
    return [UIColor colorWithHEX:0xaaaaaa];
}

/**
 *  按钮默认色
 */
+ (UIColor *)jd_BigButtonNormalColor
{
    return [UIColor colorWithHEX:0xfa640e];
}
/**
 *  按钮高亮色
 */
+ (UIColor *)jd_BigButtonHightedColor
{
    return [UIColor colorWithHEX:0xea5414];
}
/**
 *  按钮不能点击色
 */
+ (UIColor *)jd_BigButtonDisabledColor
{
    return [UIColor colorWithHEX:0xcccccc];
}


//视图高亮背景轻灰色
+ (UIColor *)jd_lightGraySelectedColor
{
    return [UIColor flashColorWithRed:246 green:246 blue:246 alpha:1];
}

+ (UIColor *)jd_accountBackColor
{
    return [UIColor colorWithHEX:0xff6d1d];
}

@end
