//
//  AddCustomSignViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "AddCustomSignViewController.h"
#import "UIBarButtonExtern.h"

@interface AddCustomSignViewController () <UITextFieldDelegate>

@property (nonatomic, strong)   UITextField *inputSignField;
@property (nonatomic, strong)   UIButton *submitButton;

@end

@implementation AddCustomSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView         = [[UIView alloc] initWithFrame:CGRectMake(0, TransparentTopHeight, self.view.width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    [backView addSubview:self.inputSignField];
    
    UILabel *promptLabel = [self promptLabel];
    promptLabel.frame    = CGRectInset(promptLabel.frame, 30, 0);
    promptLabel.top      = backView.bottom + 15.0f;
    
    [self.view addSubview:promptLabel];
    
    UIButton *signButton = [self signCheckButton];
    signButton.centerX   = self.view.centerX;
    signButton.top       = promptLabel.bottom + 15.0f;
    
    [self.view addSubview:signButton];
    
    self.submitButton.centerX = self.view.centerX;
    self.submitButton.top = signButton.bottom + 15.0f;
    
    [self.view addSubview:self.submitButton];
    
}

//  保存到常用标签的事件
- (void)signCheckButtonClicked:(UIButton *)button
{
    button.selected = !button.selected;
    
    
}

//  确认添加
- (void)submitButtonClicked:(UIButton *)button
{
    
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *replaceString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.submitButton.enabled = !isEmpty(replaceString);
    
    return YES;
}

#pragma mark - Views

- (UITextField *)inputSignField
{
    if (!_inputSignField) {
        _inputSignField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        _inputSignField.font = [UIFont systemFontOfSize:15.0f];
        _inputSignField.delegate = self;
        _inputSignField.placeholder = @"添加自定义状态标签";
        _inputSignField.frame = CGRectInset(_inputSignField.frame, 15, 3);
    }
    
    return _inputSignField;
}

- (UILabel *)promptLabel
{
    UILabel *promptLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 50)];
    promptLabel.text          = @"自定义标签可以更个性化您的生活，但可能不容易找到其他小伙伴儿";
    promptLabel.textColor     = [UIColor jt_lightGrayColor];
    promptLabel.font          = [UIFont systemFontOfSize:15.0f];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 0;
    
    return promptLabel;
}

- (UIButton *)signCheckButton
{
    UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame           = CGRectMake(0, 0, 200, 30);
    button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 25);
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    [button setImage:HTImage(@"signCheck") forState:UIControlStateNormal];
    [button setImage:HTImage(@"signCheckSelect") forState:UIControlStateSelected];
    [button setTitle:@"保存到我的常用标签" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor jt_lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor jt_barTintColor] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(signCheckButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(0, 0, 172, 44);
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _submitButton.enabled = NO;
        
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:HTImage(@"bulidButtonGray") forState:UIControlStateDisabled];
        [_submitButton setBackgroundImage:HTImage(@"bulidButtonGreen") forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitButton;
}

- (NSString *)title
{
    return @"添加自定义标签";
}

@end
