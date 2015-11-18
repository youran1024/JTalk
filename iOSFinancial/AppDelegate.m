//
//  AppDelegate.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/26.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
#import "HTGuideManager.h"
#import "HTVersionManager.h"
#import "UIAlertView+RWBlock.h"

#import <Bugly/CrashReporter.h>
#import <SMS_SDK/SMS_SDK.h>
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <MobClick.h>

/* 融云 */
#import <RongIMKit/RongIMKit.h>
#import "NSString+BFExtension.h"
#import "RCDataBaseManager.h"
#import "RCDRCIMDataSource.h"
//  友盟反馈
#import <UMFeedback.h>
#import <UMOpus.h>
#import "IndexLoginViewController.h"
#import "HTBaseRequest+Requests.h"
#import "UIAlertView+RWBlock.h"
#import "SystemConfig.h"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000


@interface AppDelegate () <HTGuideManagerDelegate, RCIMReceiveMessageDelegate, RCIMConnectionStatusDelegate>
{
    
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [self initFinishLaunch:application andOption:launchOptions];
    
    BOOL isMessageNotifacion = [[HTUserDefaults valueForKey:kJTalkMessageStoreKey] boolValue];
    [RCIM sharedRCIM].disableMessageNotificaiton = isMessageNotifacion;
    [RCIM sharedRCIM].disableMessageAlertSound = isMessageNotifacion;
   
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    //  获取图片地址， 获取七牛Token
    [[SystemConfig defaultConfig] synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    
    User *user = [User sharedUser];
    if (!user.isLogin) {

        [self presentUserLoginIndexViewControllerAnimated:NO];
    }
    
    //  MARK:远程推送
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        
    }
    
    //  MARK:显示引导页
    [HTGuideManager showGuideViewWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:__USER_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOutSuccess) name:__USER_LOGINOUT_SUCCESS object:nil];
    
    return YES;
}

- (void)presentUserLoginIndexViewControllerAnimated:(BOOL)animated
{
    UIViewController *loginViewController = [[IndexLoginViewController alloc] initWithNibName:@"IndexLoginViewController" bundle:nil];
    HTNavigationController *nav = [[HTNavigationController alloc] initWithRootViewController:loginViewController];
    
    [self.tabBarController presentViewController:nav animated:animated completion:^{
        
    }];
}

- (HTTabBarController *)tabBarController
{
    if (!_tabBarController) {
        _tabBarController = [[HTTabBarController alloc] init];
    }

    return _tabBarController;
}

//  MARK:用户登录成功
- (void)userLoginSuccess
{
    self.tabBarController.selectedIndex = 0;
    
    [self rongYunConnection];
    
    //  获取图片地址， 获取七牛Token
    [[SystemConfig defaultConfig] synchronize];
}

//  MARK:用户注销成功
- (void)userLoginOutSuccess
{
    [self presentUserLoginIndexViewControllerAnimated:YES];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([application applicationState] == UIApplicationStateInactive) {
        
        
    }else {
        //  MARK:应用内前台运行时收到推送 暂不处理
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

//  MARK:程序状态的存储和恢复
#pragma mark - Restoreatoin
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        
    }
}

#pragma mark GuideManager Delegate
- (void)guideManagerWantDisappear:(HTGuideManager *)guideManager
{
    [guideManager makeGuideViewDisappear];
    guideManager = nil;
}

#pragma mark - RCIMReceiveMessageDelegate
#pragma mark - 

// MARK:网络状态的变化
/**
 * 网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    User *user = [User sharedUser];
    
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您"
                              @"的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        
        [user doLoginOut];
    
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView =
            [[UIAlertView alloc] initWithTitle:nil
                                       message:@"Token已过期，请重新登录"
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil, nil];
            [alertView show];
            
            [user doLoginOut];
        });
    }
}

- (void)rongYunConnection
{
    User *user = [User sharedUser];
    UserInfoModel *userInfo = user.userInfo;
    
    if (user.isLogin) {
        
        RCUserInfo *_currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:userInfo.userID
                                      name:userInfo.userName
                                  portrait:userInfo.userPhoto];
        
        [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
        
        [[RCIM sharedRCIM] connectWithToken:userInfo.userToken success:^(NSString *userId) {
            NSLog(@"%@", userId);
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"status%ld", (long)status);
            
        } tokenIncorrect:^{
            NSLog(@"token incorrect");
            
            [user doLoginOut];
        }];
    }
}

#pragma mark - APP Init

- (void)initFinishLaunch:(UIApplication *)application  andOption:(NSDictionary *)launchOptions
{
    //  MARK:系统样式
    [self initAppStyle];
    
    //  MARK:融云
    [self initRongYun];
    
    //  MARK:崩溃监测
    [self initBuglyReport];
    
    //  MARK:短信
    [self initSMS_SDK];
    
    //  MARK:友盟统计
    [self initUmengAnalytics];
    
    //  MARK:友盟分享
    [self initUmengShare];
    
    //  MARK:友盟用户反馈
    [self initUmengUserFeedBack];
    
}

- (void)initUmengAnalytics
{
    [MobClick startWithAppkey:UMengAppKey reportPolicy:BATCH channelId:@"itunes"];
    [MobClick setEncryptEnabled:YES];
}

- (void)initUmengShare
{
    [UMSocialData setAppKey:UMengAppKey];
    [UMSocialSinaHandler openSSOWithRedirectURL:_SinaShareSDKCallBackURL_];
    
    [UMSocialWechatHandler setWXAppId:WeChatAppKey appSecret:WeChatAppSecret url:_JTalkCallBackURL_];
    
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppKey url:_JTalkCallBackURL_];
}

- (void)initUmengUserFeedBack
{
    [UMFeedback setAppkey:UMengAppKey];
}

//  MARK: Setting
- (void)initAppStyle
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    //  去掉tabbar底下的黑线 (顶部的阴影线 是 shoadowImage 造成的)
    [[UITabBar appearance] setTintColor:[UIColor jt_barTintColor]];
    
    //  修改navigation Bar底下的黑色线
    [[UINavigationBar appearance] setBarTintColor:[UIColor jt_barTintColor]];
    [[UINavigationBar appearance] setShadowImage:HTImage(@"")];
    
    //修改返回按钮图片
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //returnBackIcon dismissIndicatior
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"returnBackIcon"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"returnBackIcon"]];
    
    [[UITableView appearance] setSeparatorColor:[UIColor jt_lineColor]];
    
    [[UISwitch appearance] setOnTintColor:[UIColor jt_barTintColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -160)
                                                         forBarMetrics:UIBarMetricsDefault];
}


//  设置bug报告
- (void)initBuglyReport
{
    //  版本渠道信息
    [[CrashReporter sharedInstance] setChannel:__APP_CHANNEL];
    //  合并上传
    [[CrashReporter sharedInstance] setExpMergeUpload:YES];
    //  设置appId
    [[CrashReporter sharedInstance] installWithAppId:__BUGLY_APP_ID];
    //  打开Log
    [[CrashReporter sharedInstance] enableLog:YES];
}

- (void)initSMS_SDK
{
    [SMS_SDK registerApp:SMSAppKey withSecret:SMSAppSecret];
    [SMS_SDK enableAppContactFriends:NO];
}

- (void)initRongYun
{
    //初始化融云SDK，
    [[RCIM sharedRCIM] initWithAppKey:__RongYunKey_];
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    
    [self rongYunConnection];
}

@end
