//
//  LoginViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/7.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "IndexLoginViewController.h"
#import "LoginViewController.h"



@interface IndexLoginViewController ()

@property (nonatomic, strong)   UIButton *loginButton;
@property (nonatomic, strong)   UIButton *regeditButton;

@end

@implementation IndexLoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.regeditButton];
    [self.view addSubview:self.loginButton];
    
}

//  重写左上角的关闭按钮
- (void)addCloseBarbutton
{

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.regeditButton.bottom = self.view.height;
    self.regeditButton.left = 0;
    
    self.loginButton.bottom = self.view.height;
    self.loginButton.right = self.view.width;
}

#pragma mark - 
#pragma mark ButtonClicked
- (void)loginButtonClicked:(UIButton *)button
{
    LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController"andViewType:LoginViewTypeLogin];
    
    [self.navigationController pushViewController:loginVc animated:YES];

}

- (void)regeditButtonClicked:(UIButton *)button
{
    LoginViewController *loginVc = [[LoginViewController alloc] initWithNibName:@"LoginViewController"
                                                                    andViewType:LoginViewTypeRegedit];
    
    [self.navigationController pushViewController:loginVc animated:YES];
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [self customButton];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (UIButton *)regeditButton
{
    if (!_regeditButton) {
        _regeditButton = [self customButton];
        [_regeditButton setTitle:@"注册" forState:UIControlStateNormal];
        [_regeditButton addTarget:self action:@selector(regeditButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _regeditButton;
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
