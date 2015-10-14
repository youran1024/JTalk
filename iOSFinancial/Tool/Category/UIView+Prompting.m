//
//  UIView+Prompting.m
//  zhibo
//
//  Created by Mr.Yang on 14-3-19.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "UIView+Prompting.h"

@implementation UIView (Prompting)

//等待提示框
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt
{
    /*
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     */
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = prompt;
    hud.color = [UIColor flashColorWithRed:97 green:97 blue:97 alpha:1];
    
    hud.minSize = CGSizeMake(132.f, 108.0f);
    return hud;
}

//提示警告信息
- (MBProgressHUD *)showHudAuto:(NSString *)text
{
    return [self showMBHudView:text customerView:nil removeAuto:YES];
}

//成功的警告框
- (MBProgressHUD *)showHudSuccessView:(NSString *)text
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:HTImage(@"hudSuccess")];
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    return [self showMBHudView:text customerView:imageView removeAuto:YES];
}

//错误的警告框
- (MBProgressHUD *)showHudErrorView:(NSString *)text
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:HTImage(@"hudError")];
    imageView.frame = CGRectMake(0, 0, 32, 32);
    
    return [self showMBHudView:text customerView:imageView removeAuto:YES];
}

- (MBProgressHUD *)showHudManaual:(NSString *)text
{
    return [self showMBHudView:text customerView:nil removeAuto:NO];
}

//  手动关闭的提示框
- (void)removeMBProgressHudInManaual
{
    /*
     UIWindow *window = [UIApplication sharedApplication].keyWindow;
     */
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    
}

- (MBProgressHUD *)showMBHudView:(NSString *)text customerView:(UIView *)customerView removeAuto:(BOOL)autoremove
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:NO];
    hud.color = [UIColor flashColorWithRed:97 green:97 blue:97 alpha:1];
    hud.removeFromSuperViewOnHide = YES;
    hud.customView = customerView;
    hud.mode = customerView ? MBProgressHUDModeCustomView : MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
    hud.minSize = CGSizeMake(132.f, 108.0f);
    
    if (autoremove) {
        [hud hide:YES afterDelay:1];
    }
    
    return hud;
}

@end
