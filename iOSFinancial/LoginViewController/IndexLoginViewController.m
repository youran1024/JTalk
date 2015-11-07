//
//  LoginViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/7.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "IndexLoginViewController.h"
#import "LoginViewController.h"
#import "SystemConfig.h"
#import "UMSocial.h"
#import "EditInfoViewController.h"


@interface IndexLoginViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *backIamgeView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *regeditButton;

@property (nonatomic, strong) IBOutlet UIView *lineView1;
@property (nonatomic, strong) IBOutlet UIView *lineView2;

@end

@implementation IndexLoginViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *imageName = @"IndexLogin4";
    
    if (is55Inch) {
        imageName = @"IndexLogin55";
    }else if (is47Inch) {
        imageName = @"IndexLogin47";
    }else if (is35Inch) {
        imageName = @"IndexLogin35";
    }
    
    self.backIamgeView.image = HTImage(imageName);
    
    self.loginButton.layer.cornerRadius = 5.0f;
    self.regeditButton.layer.cornerRadius = 5.0f;
    
    [self.loginButton setTitleColor:HTHexColor(0x2e2d2d) forState:UIControlStateNormal];
    [self.regeditButton setTitleColor:HTHexColor(0x2e2d2d) forState:UIControlStateNormal];
    
    [self.regeditButton setBackgroundColor:HTHexColor(0xe3e3e3)];
    [self.loginButton setBackgroundColor:HTHexColor(0xe3e3e3)]; //HTHexColor(0x68d093)];
    
    UIColor *color = [UIColor colorWithHEX:0xd5d5d5];
    self.lineView1.backgroundColor = color;
    self.lineView2.backgroundColor = color;
    
}

//  重写左上角的关闭按钮
- (void)addCloseBarbutton
{
    
}


#pragma mark - 
#pragma mark ButtonClicked
- (IBAction)loginButtonClicked:(UIButton *)button
{
    LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController"andViewType:LoginViewTypeLogin];
    
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (IBAction)regeditButtonClicked:(UIButton *)button
{
    LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController"
                                                                    andViewType:LoginViewTypeRegedit];
    
    [self.navigationController pushViewController:loginVc animated:YES];
}

#pragma mark - QuickLoad

- (IBAction)qqLoginClicked:(id)sender
{
    [self loginWithType:UMShareToQQ];
}

- (IBAction)weChatClicked:(id)sender
{
    [self loginWithType:UMShareToWechatSession];
}

- (IBAction)weBoClicked:(id)sender
{
    [self loginWithType:UMShareToSina];
}

- (void)loginWithType:(NSString *)snsName
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES, ^(UMSocialResponseEntity *response) {
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsName];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            UserLoginType loginType = -1;
            
            UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
            userInfo.userID = snsAccount.usid;
            userInfo.userAccessToken = snsAccount.accessToken;
            userInfo.userPhoto = snsAccount.iconURL;
            userInfo.userName = snsAccount.userName;
            
            if ([snsName isEqualToString:UMShareToQQ]) {
                loginType = UserLoginTypeQQ;
            }else if ([snsName isEqualToString:UMShareToWechatSession]) {
                loginType = UserLoginTypeWeChat;
            }else {
                loginType = UserLoginTypeWeibo;
            }
            
            userInfo.userLoginType = loginType;
            
            /*不需要检测，直接登录，如果没有这个用户则需要注册*/
            [self doLogin];
            
            //[self isUserExists:snsAccount.accessToken andLoginType:loginType];
            
        }
    });
}

- (void)isUserExists:(NSString *)userToken andLoginType:(UserLoginType)loginType
{
    HTBaseRequest *request = [HTBaseRequest userRegisteCheck:loginType userId:userToken];
    request.shouldShowErrorMsg = NO;
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSInteger code = [[request.responseJSONObject stringIntForKey:@"code"] integerValue];
        
        UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
        userInfo.userToken = userToken;
        userInfo.userLoginType = loginType;
        
        if (code == Error_UserExists) {
            //  用户已经存在, 直接登陆
            [self doLogin];
            
        }else {
            
            userInfo.userID = userToken;
            //  用户没有注册
            [self doRegister];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [self showHudErrorView:@"网络链接错误"];
    }];
}

- (void)doRegister
{
    //  MARK:完善用户资料
    EditInfoViewController *editor = [[EditInfoViewController alloc] init];
    [self.navigationController pushViewController:editor animated:YES];
}

- (void)doLogin
{
    [self showHudWaitingView:PromptTypeWating];
    
    HTBaseRequest *request = [HTBaseRequest userLogin];
    
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSInteger responseCode = [[request.responseJSONObject stringForKey:@"code"] integerValue];
        NSDictionary *dict = [request.responseJSONObject dictionaryForKey:@"result"];
        
        if (responseCode == 200) {
            //  登陆成功
            [self showHudSuccessView:@"登录成功"];
            
            [[User sharedUser].userInfo parseWithDictionary:dict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:__USER_LOGIN_SUCCESS object:nil];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (UIButton *)customButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 114, 64);
    button.titleLabel.font = HTFont(16.0f);
    [button setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    
    return button;
}

- (NSString *)title
{
    return @"交言";
}

@end
