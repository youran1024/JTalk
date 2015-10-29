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


@interface IndexLoginViewController ()

@property (nonatomic, strong) IBOutlet  UIButton *loginButton;
@property (nonatomic, strong) IBOutlet  UIButton *regeditButton;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *promptLabel;

@property (nonatomic, strong) IBOutlet UIView *topLine;
@property (nonatomic, strong) IBOutlet UIView *bottomLine;

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
    
    [self initView];
}

- (void)initView
{
    self.titleLabel.textColor = HTHexColor(0x555555);
    
    self.promptLabel.textColor = HTHexColor(0x2e2d2d);
    
    self.topLine.backgroundColor = HTHexColor(0x818282);
    self.bottomLine.backgroundColor = HTHexColor(0x818282);
    
    [self.loginButton setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    [self.regeditButton setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    
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
