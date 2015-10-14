//
//  UIView+Prompting.h
//  zhibo
//
//  Created by Mr.Yang on 14-3-19.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIView (Prompting)

//  等待提示
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt;

//  文字提示
- (MBProgressHUD *)showHudAuto:(NSString *)text;
- (MBProgressHUD *)showHudManaual:(NSString *)text;

//  成功失败提示
- (MBProgressHUD *)showHudSuccessView:(NSString *)text;
- (MBProgressHUD *)showHudErrorView:(NSString *)text;

//  消除视图
- (void)removeMBProgressHudInManaual;

@end
