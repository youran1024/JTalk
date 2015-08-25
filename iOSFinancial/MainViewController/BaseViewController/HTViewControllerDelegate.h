//
//  HTViewControllerDelegate.h
//  zhibo
//
//  Created by Mr.Yang on 14-3-21.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

#define PromptTypeSuccess   @"成功"
#define PromptTypeWating    @"请稍候..."
#define PromptTypeError     @"网络连接异常，请稍后再试"
#define PromptTypeLoading   @"加载中..."

typedef enum {
    NetworkStatusTypeSuccess = 1,
    NetworkStatusTypeWaiting,
    NetworkStatusTypeLoading,
    NetworkStatusTypeNotReachable,
    
}NetworkStatusType;

@protocol ViewControllerPromptingDelegate <NSObject>

@optional
//警告框
- (void)showAlert:(NSString *)message;
- (void)alertViewWithButtonsBlock:(NSArray *(^)(void))buttonsBlock
                   andHandleBlock:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))handleBlock andMessage:(NSString *)message;
/**
 *  兼容ios8 actionsheet
 *  @param title
 *  @param message
 *  @param buttonTitles 从index 0 开始的button 标题
 *  @param handler      回调，返回对应点击的index
 */

- (id)showActionSheet:(NSString *)title
                message:(NSString *)message
            buttonTitle:(NSArray *)buttonTitles
                handler:(void (^)(UIActionSheet *action , NSInteger clickedIndex))handler;

- (id)showActionSheet:(NSString *)title
                message:(NSString *)message
            buttonTitle:(NSArray *)buttonTitles
                style:(UIAlertControllerStyle)style
                handler:(void (^)(UIActionSheet *action , NSInteger clickedIndex))handler;


//  等待提示
- (MBProgressHUD *)showHudWaitingView:(NSString *)prompt;

//  文字提示
- (MBProgressHUD *)showHudAuto:(NSString *)text;
- (MBProgressHUD *)showHudManaual:(NSString *)text;

//  成功失败提示
- (MBProgressHUD *)showHudSuccessView:(NSString *)text;
- (MBProgressHUD *)showHudErrorView:(NSString *)text;

//  消除视图
- (void)removeHudInManaual;

//  ios8 ActionSheet弹框(传参还是之前ios7的样式传参 比如取消，保存，删除) buttonIndex的大小是根据数组元素的先后顺序来的
- (void)showActionSheet:(NSString *)title andButtonArray:(NSArray *)buttonArray andButtonBlcok:(void(^)(NSInteger buttonIndex))handleBlock;

@end

@protocol ViewControllerKeyboardNotificationDelegate <NSObject>

//键盘监听
- (void)addKeyboardNotifaction;
- (void)keyboardWillDisappear:(NSNotification *)noti withKeyboardRect:(CGRect)rect;
- (void)keyboardWillAppear:(NSNotification *)noti withKeyboardRect:(CGRect)rect;
- (void)keyboardDidDisappear:(NSNotification *)noti withKeyboardRect:(CGRect)rect;
- (void)keyboardDidAppear:(NSNotification *)noti withKeyboardRect:(CGRect)rect;

@end

@protocol ViewControllerDismissDelegate <NSObject>

@required
//将视图消失
- (void)dismissViewController;
- (void)dismissViewController:(void(^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)animation  complainBlock:(void(^)(void))completion;

//--------------------------------
//视图将要被 pop 或者 dismiss
- (void)viewControllerWillDismiss;
- (void)viewControllerDidDismiss;

@end

