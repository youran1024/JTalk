//
//  JRJVersionManager.m
//  zhibo
//
//  Created by Mr.Yang on 14-3-21.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTVersionManager.h"
#import "NSString+BaseURL.h"
#import "NSDictionary+JSONExtern.h"
#import "CustomIOS7AlertView.h"

#define AppVersionLastCheckDate         @"AppVersionLastCheckDate"
#define AppVersionLastClickedCancelDate @"AppVersionLastClickedCancelDate"
#define AppVersionIsNotPromoteAgain     @"AppVersionIsNotPromoteAgain"
#define AppVersionLastUpdateVersion     @"AppVersionLastUpdateVersion"
#define AppVersionDownloadUrl           @"AppVersionDownloadUrl"
#define AppVersionForceUpdate           @"AppVersionForceUpdate"
#define AppVersionForceContent          @"AppVersionorceUpdatePromptContent"

#define AppVersionCheckInterval 60 * 30

#define AppVersionClickedCancelInterval 60 * 60 * 24 * 5

static HTVersionManager *versionManager;

@interface HTVersionManager () <UIAlertViewDelegate>
{
    NSString *_localVersion;
}

//  升级地址格式
//  itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",@"954270"

//  评分地址格式
//  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", @"954270"

//  分享链接
//  https://itunes.apple.com/cn/app/jian-dan-li-cai-zhu-ce-ji/id970895932?l=ch&mt=8

@property (nonatomic, strong)   HTBaseRequest *request;
@property (nonatomic, copy)     NSString *trackViewUrl;
@property (nonatomic, assign)   BOOL isNeedForceUpdate;
@property (nonatomic, assign)   NSTimeInterval lastCheckDate;
//  升级的版本号
@property (nonatomic, copy)     NSString *lastUpdateVersion;
//  不再提示的标记
@property (nonatomic, assign)   BOOL isNotPromoteAgain;
//  强制升级的提示语
@property (nonatomic, copy) NSString *forceUpdatePromptContent;

@end

@implementation HTVersionManager
+ (HTVersionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        versionManager = [[HTVersionManager alloc] init];
    });
    
    return versionManager;
}

- (id)init
{
    if (versionManager) {
        return versionManager;
    }
    
    self = [super init];
    if (self) {
        _lastCheckDate = [[HTUserDefaults valueForKey:AppVersionLastCheckDate] doubleValue];
        _isNotPromoteAgain = [[HTUserDefaults valueForKey:AppVersionIsNotPromoteAgain] boolValue];
        _lastUpdateVersion = [HTUserDefaults valueForKey:AppVersionLastUpdateVersion];
        _trackViewUrl = [HTUserDefaults valueForKey:AppVersionDownloadUrl];
        _forceUpdatePromptContent = [HTUserDefaults valueForKey:AppVersionForceContent];
        _isNeedForceUpdate = [[HTUserDefaults valueForKey:AppVersionForceUpdate] boolValue];
    }
    
    return self;
}

- (void)setLastCheckDate:(NSTimeInterval)lastCheckDate
{
    _lastCheckDate = lastCheckDate;
    [HTUserDefaults setValue:@(lastCheckDate) forKey:AppVersionLastCheckDate];
    [HTUserDefaults synchronize];
}

- (void)setIsNotPromoteAgain:(BOOL)isNotPromoteAgain
{
    _isNotPromoteAgain = isNotPromoteAgain;
    [HTUserDefaults setValue:@(_isNotPromoteAgain) forKey:AppVersionIsNotPromoteAgain];
    [HTUserDefaults synchronize];
}

- (void)setLastUpdateVersion:(NSString *)lastUpdateVersion
{
    _lastUpdateVersion = lastUpdateVersion;
    [HTUserDefaults setValue:_lastUpdateVersion forKey:AppVersionLastUpdateVersion];
    [HTUserDefaults synchronize];
}

- (void)setTrackViewUrl:(NSString *)trackViewUrl
{
    _trackViewUrl = trackViewUrl;
    [HTUserDefaults setValue:_trackViewUrl forKey:AppVersionDownloadUrl];
    [HTUserDefaults synchronize];
}

- (void)setIsNeedForceUpdate:(BOOL)isNeedForceUpdate
{
    _isNeedForceUpdate = isNeedForceUpdate;
    [HTUserDefaults setValue:@(_isNeedForceUpdate) forKey:AppVersionForceUpdate];
    [HTUserDefaults synchronize];
}

- (void)setForceUpdatePromptContent:(NSString *)forceUpdatePromptContent
{
    _forceUpdatePromptContent = forceUpdatePromptContent;
    [HTUserDefaults setValue:_forceUpdatePromptContent forKey:AppVersionForceContent];
    [HTUserDefaults synchronize];
}

- (void)checkAppversion
{
    if (_lastUpdateVersion.length != 0 &&
        [_lastUpdateVersion compare:self.localVersion] == NSOrderedDescending) {
        
        if (_isNeedForceUpdate) {
            [self showUpdate:YES content:_forceUpdatePromptContent];
            return;
        }
    }
    
    if (_request) {
        [_request stop];
    }
    
    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
    
    // 检测时间间隔至少 30 分钟
    if (nowInterval - self.lastCheckDate < AppVersionCheckInterval) {
        return;
    }
    
    //TODO:暂时设置空值
    HTBaseRequest *request = [HTBaseRequest requestWithURL:nil];
    _request = request;

    request.shouldShowErrorMsg = NO;
    
    __weak HTVersionManager *weakSelf = self;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = [request.responseJSONObject dictionaryForKey:@"result"];
        if (dic) {
            weakSelf.isNeedForceUpdate = NO;
            //设置上次检查时间,检查频率间隔一天
            weakSelf.lastCheckDate = [[NSDate date] timeIntervalSince1970];
            
            //1强制升级 0可以升级
            NSString * updateType = [dic stringIntForKey:@"I_FORCE"];
            
            //  升级描述
            NSString *content = [dic stringForKey:@"CH_DESCRIPTION"];
            weakSelf.forceUpdatePromptContent = content;
            //  升级包下载地址
            weakSelf.trackViewUrl = [dic stringForKey:@"CH_URL"];
            //  版本号
            NSString *updateVersion = [dic stringForKey:@"CH_NAME"];
            weakSelf.lastUpdateVersion = updateVersion;
            
            if ([updateVersion compare:self.localVersion] != NSOrderedAscending) {
                //  如果要更新的版本号，小于等于当前版本号，则不升级
                return ;
            }
            
            //  可以升级
            if ([updateType isEqualToString:@"0"]) {
                
                //  如果与上次版本号相同
                if ([updateVersion isEqualToString:weakSelf.lastUpdateVersion]) {
                    //  如果用户点击了不再提示
                    if (weakSelf.isNotPromoteAgain) {
                        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                        NSTimeInterval duration = nowTime - weakSelf.lastCheckDate;
                        //  同一版本的提示，间隔为
                        if (duration < AppVersionClickedCancelInterval) {
                            return;
                        }else {
                            weakSelf.isNotPromoteAgain = NO;
                        }
                    }
                    
                }else {
                    weakSelf.isNotPromoteAgain = NO;
                    weakSelf.lastUpdateVersion = updateVersion;
                }
                
                [weakSelf showUpdate:NO content:content];
                
            }else {
                //  强制升级
                weakSelf.isNeedForceUpdate = YES;
                [weakSelf showUpdate:YES content:content];
            }
        }
        
    }];
    
}

- (void)showUpdate:(BOOL)isForce content:(NSString *)content
{
    NSString *cancelTitle = nil;
    NSString *rightButton = nil;
    
    CustomIOS7AlertView *alert = [[CustomIOS7AlertView alloc] init];
    
    if (isForce) {
        rightButton = @"确定";
        alert.buttonTitles = @[rightButton];
        
    }else {
        cancelTitle = @"稍后再说";
        rightButton = @"立即升级";
        alert.buttonTitles = @[cancelTitle, rightButton];
    }

    alert.containerView = [self containerView:content];
    
    if (isForce) {
        //强制升级
        alert.tag = 200;
    }else{
        //可以升级
        alert.tag = 300;
    }
    
    [alert setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        
        if (buttonIndex == 0) {
            
            if (alertView.tag == 200) {
                //  强制升级
                [self doUpdateAction];
                
            }else {
                //  不再提示
                self.isNotPromoteAgain = YES;
            }
            
        }else {
            //   升级
            [self doUpdateAction];
        }
    }];
    
    [alert show];
}

- (void)doUpdateAction
{
    NSURL *url = [NSURL URLWithString:_trackViewUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (UIView *)containerView:(NSString *)content
{
    CGFloat scale = 270.0f / 320.0f;
    if (is55Inch) {
        scale -= .1;
    }
    CGFloat width = APPScreenWidth * scale;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 36)];
    titleLabel.textColor = HTHexColor(0x595959);
    titleLabel.backgroundColor = HTClearColor;
    titleLabel.font = HTFont(16.0f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"升级提示";
    [view addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.text = content;
    textView.textColor = HTHexColor(0x595959);
    textView.font = HTFont(15.0f);
    textView.editable = NO;
    CGSize size = [textView sizeThatFits:CGSizeMake(width - 30, 160)];
    if (size.height < 50) {
        size.height = 50;
    }
    
    size.width = width - 30;
    textView.size = size;
    textView.backgroundColor = HTClearColor;
    textView.left = 15.0f;
    textView.top = CGRectGetHeight(titleLabel.frame) - 8;
    [view addSubview:textView];
    view.height = CGRectGetMaxY(textView.frame) + 10;

    return view;
}

/*
- (void)showUpdate:(BOOL)isForce content:(NSString *)content
{
    NSString *cancelTitle = nil;
    NSString *rightButton = nil;
    if (isForce) {
        cancelTitle = @"退出";
        rightButton = @"确定";
    }else {
        cancelTitle = @"稍后再说";
        rightButton = @"立即升级";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:rightButton, nil];
     
     if (isForce) {
     //强制升级
     alert.tag = 200;
     }else{
     //可以升级
     alert.tag = 300;
     }
     
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [NSURL URLWithString:_trackViewUrl];
    
    if (alertView.tag == 200) {
        //强制升级
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:url];
        }else {
            //  退出
            exit(0);
        }
        
    }else if(alertView.tag == 300){
        //可以升级
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:url];
        }else {
            //  不再提示
            self.isNotPromoteAgain = YES;
        }
    }
}
 */

#pragma mark -

- (BOOL)isNewest
{
    return [_lastVersion isEqualToString:_localVersion];
}

- (NSString *)localVersion
{
    if (!_localVersion || _localVersion.length == 0) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        _localVersion = [infoDic stringForKey:@"CFBundleShortVersionString"];
    }
    
    return _localVersion;
}

- (NSString *)versionDescription
{
    return HTSTR(@"当前应用程序的版本号是:%@", [self localVersion]);
}

- (void)clean
{
    [_request stop];
    _trackViewUrl = nil;
}

@end
