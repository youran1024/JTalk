//
//  UIColor+Colors.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/23.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HTExtension.h"

@interface UIColor (Colors)

/*
 *  浅灰色 dad9d9
 */

+ (UIColor *)jt_lightGrayColor;

/**
 *  系统背景色
 */
+ (UIColor *)jt_backgroudColor;

/**
 *  更多页面的详情字体颜色
 */
+ (UIColor *)jd_settingDetailColor;

/**
 *  黑色深色值
 */
+ (UIColor *)jt_darkBlackTextColor;

/**
 *  全局的字体颜色
 */
+ (UIColor *)jt_globleTextColor;

/**
 *  黑色浅色值
 */
+ (UIColor *)jt_lightBlackTextColor;

/**
 *  线的颜色
 */
+ (UIColor *)jt_lineColor;

/**
 *  导航条的颜色
 */
+ (UIColor *)jt_barTintColor;

/**
 *  视图高亮背景轻灰色
 */
+ (UIColor *)jd_lightGraySelectedColor;

/**
 *  默认字体二级灰
 */
+ (UIColor *)jd_textGray2Color;

/**
 *  按钮默认色
 */
+ (UIColor *)jd_BigButtonNormalColor;
/**
 *  按钮高亮色
 */
+ (UIColor *)jd_BigButtonHightedColor;
/**
 *  按钮不能点击色
 */
+ (UIColor *)jd_BigButtonDisabledColor;

/*
 *  账户，手势的背景颜色
 */
+ (UIColor *)jd_accountBackColor;

@end
