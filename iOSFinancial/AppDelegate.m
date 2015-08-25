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

//  友盟组件
#import "umsocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "MobClick.h"
//  推送
#import "UMessage.h"
//  腾讯bug反馈
#import <Bugly/CrashReporter.h>
//  分享
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <SMS_SDK/SMS_SDK.h>
//  融云
#import <RongIMKit/RongIMKit.h>
#import "NSString+BFExtension.h"

//  友盟反馈
#import <UMFeedback.h>
#import <UMOpus.h>

#import "IndexLoginViewController.h"
#import "HTBaseRequest+Requests.h"
#import "JSONKit.h"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000


@interface AppDelegate () <HTGuideManagerDelegate>
{
    
    
    
}


@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initFinishLaunch:application andOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    
    User *user = [User sharedUser];
    if (!user.isLogin) {

        [self presentUserLoginIndexViewControllerAnimated:YES];
    }
    
    //  MARK:远程推送
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [self handleRemoteNotification:userInfo];
    }
    
    //  MARK:显示引导页
    [HTGuideManager showGuideViewWithDelegate:self];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:__USER_LOGIN_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOutSuccess) name:__USER_LOGINOUT_SUCCESS object:nil];
    
    return YES;
}

- (void)presentUserLoginIndexViewControllerAnimated:(BOOL)animated
{
    UIViewController *loginViewController = [[IndexLoginViewController alloc] init];
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
    UIViewController *viewController = self.window.rootViewController;
    
    self.tabBarController.view.alpha = 0.0f;
    [UIView animateWithDuration:.25 animations:^{
        viewController.view.alpha = 0;
        self.tabBarController.view.alpha = 1.0f;
        self.tabBarController.view.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
    } completion:^(BOOL finished) {
        self.window.rootViewController = self.tabBarController;
    }];

}

//  MARK:用户注销成功
- (void)userLoginOutSuccess
{
    [self presentUserLoginIndexViewControllerAnimated:YES];
}

//  ----------------------------------------------------------------------------------------------------

//  MARK:UMeng Key and setting
- (void)setUMengpushSetting:(NSDictionary *)launchOptions
{
    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"54f52161fd98c52c280001a0" launchOptions:launchOptions];
    [UMessage setAutoAlert:NO];
    
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:settings];
        
    }else {
        
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    
}

//  远程推送
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    NSString *model = [userInfo stringForKey:@"model"];
    NSString *action = [userInfo stringForKey:@"action"];
    
    if ([model isEqualToString:@"discover"]) {
        //  open webview
        
    }else if ([model isEqualToString:@"project"]) {
        //  open project detail
        if (action.length > 0) {
            
            
        }else {

        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    
    if ([application applicationState] == UIApplicationStateInactive) {
        [self handleRemoteNotification:userInfo];
        
        
    }else {
        //  MARK:应用内前台运行时收到推送 暂不处理
        
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
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

#pragma mark GuideManager Delegate
- (void)guideManagerWantDisappear:(HTGuideManager *)guideManager
{
    [guideManager makeGuideViewDisappear];
    guideManager = nil;
}


#pragma mark - Appdelegate
#pragma mark -

- (void)initFinishLaunch:(UIApplication *)application  andOption:(NSDictionary *)launchOptions
{
    //  MARK:系统样式
    [self setAppStyle];
    
    //  MARK:融云
      [self rongYunInit];
    
    //  MARK:崩溃监测
        [self setBuglyReport];
    
    //  MARK:短信
    [self smsSDKInit];
    
    //  MARK:UMeng用户反馈
    [UMFeedback setAppkey:UMengAppKey];
    
    /*
    //  MARK:推送设置
        [self setUMengpushSetting:launchOptions];
    
     // MARK:友盟设置
        [self setUMengSetting];
        [self shareSDKInit];
     
     */
}

//  MARK: Setting

- (void)setAppStyle
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    
    //  去掉tabbar底下的黑线
    [[UITabBar appearance] setTintColor:[UIColor jt_barTintColor]];
    [[UITabBar appearance] setShadowImage:HTImage(@"")];
    
    //  修改navigation Bar底下的黑色线
    [[UINavigationBar appearance] setBarTintColor:[UIColor jt_barTintColor]];
    [[UINavigationBar appearance] setShadowImage:HTImage(@"")];//[[UIImage alloc] init]
    
    //修改返回按钮图片
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //returnBackIcon dismissIndicatior
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"returnBackIcon"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"returnBackIcon"]];
    
    [[UITableView appearance] setSeparatorColor:[UIColor jt_lineColor]];
    
    [[UISwitch appearance] setOnTintColor:[UIColor jt_barTintColor]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//   友盟设置
- (void)setUMengSetting
{
    //  友盟页面统计
    [MobClick startWithAppkey:UMengAppKey reportPolicy:BATCH   channelId:nil];
    
    //  友盟分享
    [UMSocialData setAppKey:UMengAppKey];
    
    [UMSocialConfig hiddenNotInstallPlatforms:nil];
    
    //  设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WeiXinAppKey appSecret:WeiXinAppSecreat url:kWebServiceURL];
    
    //  设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppKey url:kWebServiceURL];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    //若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil
    [UMSocialSinaHandler openSSOWithRedirectURL:nil];
}

//  设置bug报告
- (void)setBuglyReport
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

- (void)smsSDKInit
{
    [SMS_SDK registerApp:@"9714408bd484" withSecret:@"a1f086c784801056efcc857e974119d4"];
}


- (void)rongYunInit
{
    //vnroth0krcr4o  key
    
    //初始化融云SDK，
    [[RCIM sharedRCIM] initWithAppKey:__RongYunKey_];
 
    User *user = [User sharedUser];
    UserInfoModel *userInfo = user.userInfo;
    
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userInfo.userID
                                  name:userInfo.userName
                              portrait:userInfo.userPhoto];

    [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
    
    NSString *token = @"LvhvMGO8k+LHVATyYiup/+fCgUbrbGP7LiGzGZpG9Jz/16Axj4qg14+5BLS1v0BMfhn6y9gDDkl4yIMJbySJgNiJQlfi4r9cRIAiubQjsB9hwYt/cE3edw==";
    
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"%@", userId);
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"status%ld", (long)status);
        
    } tokenIncorrect:^{
        NSLog(@"token incorrect");
        
    }];
}

- (void)shareSDKInit
{
    
    [ShareSDK registerApp:@"api20"];//字符串api20为您的ShareSDK的AppKey
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"1020741709"
                               appSecret:@"b0be0a3e7020516a44540c4f8c92b622"
                             redirectUri:@"http://baidu.com"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1020741709"
                                appSecret:@"b0be0a3e7020516a44540c4f8c92b622"
                              redirectUri:@"http://baidu.com"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQAppId
                           appSecret:QQAppKey
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQAppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:WeiXinAppKey
                           appSecret:WeiXinAppSecreat
                           wechatCls:[WXApi class]];
    
}

@end
