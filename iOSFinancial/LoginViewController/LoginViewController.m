//
//  LoginViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/7.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "LoginViewController.h"
#import "UIBarButtonExtern.h"
#import <ShareSDK/ShareSDK.h>
#import "SetNewPassViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "NSString+IsValidate.h"
#import "UIView+Animation.h"
#import "User.h"
#import "HTBaseRequest+Requests.h"
#import "SystemConfig.h"


@interface LoginViewController ()

@property (nonatomic, assign)   LoginViewType loginViewType;
@property (nonatomic, strong)   NSTimer *timeRuner;

@property (nonatomic, weak)   IBOutlet  UIView *backView1;
@property (nonatomic, weak)   IBOutlet  UIView *backView2;

@property (nonatomic, weak)   IBOutlet UILabel *telLabel;
@property (nonatomic, weak)   IBOutlet UILabel *codeLabel;

@property (nonatomic, weak)   IBOutlet UITextField *telFiled;
@property (nonatomic, weak)   IBOutlet UITextField *codeFiled;
@property (nonatomic, weak)   IBOutlet UIButton *forgetButton;

@property (nonatomic, weak)   IBOutlet UIView *lineView1;
@property (nonatomic, weak)   IBOutlet UIView *lineView2;

@property (nonatomic, weak)   IBOutlet UIView *lineViewHor;
@property (nonatomic, weak)   IBOutlet UIView *lineViewVer;

@property (nonatomic, weak)   IBOutlet UIButton *weiBoButton;
@property (nonatomic, weak)   IBOutlet UIButton *weChatButton;

@property (nonatomic, weak)   IBOutlet UILabel *promptLabel;

@property (nonatomic, weak) User *user;
@property (nonatomic, weak) UserInfoModel *userInfo;
@property (nonatomic, assign) NSInteger runCount;

@end

static NSString *userPhone;

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)dealloc
{
    [_timeRuner invalidate];
    _timeRuner = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_loginViewType != LoginViewTypeLogin) {
        [self enableReSendButton];
    }
    
    userPhone = _telFiled.text;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _telFiled.text = userPhone;
    
    [self.telFiled becomeFirstResponder];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andViewType:(LoginViewType)loginViewType
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    
    if (self) {
        self.runCount = 59;
        self.loginViewType = loginViewType;
        self.user = [User sharedUser];
        self.userInfo = self.user.userInfoModelTmp;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self awakeFromNib];
    
    [[SystemConfig defaultConfig] synchronize];
    
    UIBarButtonItem *item = nil;
    if (_loginViewType == LoginViewTypeLogin) {
        item = [UIBarButtonExtern buttonWithTitle:@"确认" target:self andSelector:@selector(loginButtonClicked)];
    }else {
        item = [UIBarButtonExtern buttonWithTitle:@"下一步" target:self andSelector:@selector(regeitNextStep)];
    }
    
    [self addKeyboardNotifaction];

    self.navigationItem.rightBarButtonItem = item;
    
    UITapGestureRecognizer *hideKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:hideKeyBoard];
    
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (void)cacheUserInfo
{
    NSString *tel = _telFiled.text;
    NSString *pass = _codeFiled.text;
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    userInfo.userPhone = tel;
    userInfo.userPass = [pass toMD5];
}

//  MARK:登陆按钮
- (void)loginButtonClicked
{
    NSString *tel = _telFiled.text;
    NSString *pass = _codeFiled.text;
    
    if (![tel isValidatePhone]) {
        [self showHudErrorView:@"请输入正确的手机号"];
        return;
    }
    
    if (pass.length < 6) {
        [self showHudErrorView:@"密码至少为6位"];
        return;
    }
    
    [self cacheUserInfo];
    
    [self showHudWaitingView:PromptTypeWating];
    
    HTBaseRequest *request = [HTBaseRequest loginWithUserInfo];
    
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

- (void)awakeFromNib
{
    _backView1.backgroundColor = [UIColor whiteColor];
    _backView2.backgroundColor = [UIColor clearColor];
    
    _telLabel.textColor = [UIColor jt_globleTextColor];
    _codeLabel.textColor = [UIColor jt_globleTextColor];
    
    _telFiled.keyboardType = UIKeyboardTypePhonePad;
    
    _promptLabel.textColor = [UIColor jt_lightGrayColor];
    
    [_forgetButton setTitleColor:[UIColor jt_barTintColor] forState:UIControlStateNormal];
    
    _lineView1.backgroundColor = [UIColor jt_lightGrayColor];
    _lineView2.backgroundColor = [UIColor jt_lightGrayColor];
    _lineViewHor.backgroundColor = [UIColor jt_lineColor];
    _lineViewVer.backgroundColor = [UIColor jt_lineColor];
    
    _lineView1.height = .5;
    _lineView2.height = .5;
    
    _lineViewHor.height = .5;
    _lineViewVer.width = .5;
    
    _telFiled.textColor = [UIColor jt_globleTextColor];
    _codeLabel.textColor = [UIColor jt_globleTextColor];
    _codeFiled.textColor = [UIColor jt_globleTextColor];
    
    if (_loginViewType == LoginViewTypeRegedit ||
        _loginViewType == LoginViewTypeFindPass) {
        _codeFiled.keyboardType = UIKeyboardTypeNumberPad;
        _codeLabel.text = @"获取验证码";
        _codeLabel.textColor = [UIColor jt_barTintColor];
        _codeFiled.secureTextEntry = NO;
        _codeFiled.placeholder = @"输入四位验证码";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeSignClicked)];
        [_codeLabel addGestureRecognizer:tap];
        _codeLabel.userInteractionEnabled = YES;
        _forgetButton.hidden = YES;
    }else {
        _codeLabel.text = @"密码";
    }
    
    if (_loginViewType == LoginViewTypeFindPass) {
        _backView2.hidden = YES;
        _forgetButton.hidden = YES;
        _weiBoButton.hidden = YES;
        _weChatButton.hidden = YES;
    }
}

// MARK:获取验证码
- (void)codeSignClicked
{
    NSString *tel = _telFiled.text;
    if (![tel isValidatePhone]) {
        [self showHudErrorView:@"请输入正确的手机号码"];
        return;
    }
    
    //  保存用户注册手机号
    self.userInfo.userPhone = tel;
    
    [self showHudWaitingView:@"请稍候..."];
    [SMS_SDK getVerificationCodeBySMSWithPhone:tel zone:@"86" result:^(SMS_SDKError *error) {
        if (error) {
            [self showHudErrorView:HTSTR(@"获取失败,%@", error)];
        }else {
            [self timeRuner];
            _codeLabel.userInteractionEnabled = NO;
        }
    }];
}

- (NSTimer *)timeRuner
{
    if (!_timeRuner) {
        _timeRuner = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    }
    
    return _timeRuner;
}

- (void)timerRun:(NSTimer *)timer
{
    [self removeHudInManaual];
    
    if (_runCount == 1) {
        [self enableReSendButton];
    }else {
        _codeLabel.text = HTSTR(@"%ld", (long)_runCount--);
    }
    
//    [_codeLabel flashAnimation];
}

//  MARK:重新发送验证码按钮(可用3258)
- (void)enableReSendButton
{
    _runCount = 59;
    _codeLabel.text = @"获取验证码";
    _codeLabel.userInteractionEnabled = YES;
    [_timeRuner invalidate];
    _timeRuner = nil;

}

//  MARK:完成手机号， 下一步
- (void)regeitNextStep
{
    if(isEmpty(_codeFiled.text)) {
        [_codeFiled becomeFirstResponder];
        [self showHudErrorView:@"请输入验证码"];
        return;
    }
    
    //  是重新设置密码 还是 注册过程中得设置密码
    if (_loginViewType == LoginViewTypeFindPass ||
        _loginViewType == LoginViewTypeRegedit) {
        
        //  提交验证码
        [SMS_SDK commitVerifyCode:_codeFiled.text result:^(enum SMS_ResponseState state) {
            if (state) {
                //  是重新设置密码 还是 注册过程中得设置密码
                SetPassType type = _loginViewType == LoginViewTypeFindPass ? SetPassTypeReset : SetPassTypeNew;
                SetNewPassViewController *setNewPass = [[SetNewPassViewController alloc] initWithSetPassType:type];
                [self.navigationController pushViewController:setNewPass animated:YES];
                
            }else {
                [self showHudErrorView:@"请输入正确的验证码"];
            }
        }];
    }
    
}

- (void)showPassViewController
{
    SetPassType type = _loginViewType == LoginViewTypeFindPass ? SetPassTypeReset : SetPassTypeNew;
    SetNewPassViewController *setNewPass = [[SetNewPassViewController alloc] initWithSetPassType:type];
    [self.navigationController pushViewController:setNewPass animated:YES];
}

//  MARK:忘记密码
- (IBAction)forgetButtonClicked
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" andViewType:LoginViewTypeFindPass];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (NSString *)title
{
    if (_loginViewType == LoginViewTypeRegedit) {
        return @"手机注册";
    }else if (_loginViewType == LoginViewTypeLogin) {
        return @"登录";
    }else {
        return @"找回密码";
    }
}

#pragma mark -
#pragma mark 暂时不用的


- (IBAction)weiBoButtonClicked:(id)sender
{
    
    
}

- (IBAction)weChatButtonClicked:(id)sender
{
    
    
}


@end
