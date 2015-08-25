//
//  AddSignViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "AddSignViewController.h"
#import "UIBarButtonExtern.h"


@interface AddSignViewController () <UITextFieldDelegate>

@property (nonatomic, strong)   UITextField *inputSignField;

@end

@implementation AddSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView         = [[UIView alloc] initWithFrame:CGRectMake(0, TransparentTopHeight, self.view.width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    [backView addSubview:self.inputSignField];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"添加" target:self andSelector:@selector(addSignButtonClicked)];

}

//  添加标签
- (void)addSignButtonClicked
{
    if (!isEmpty(_inputSignField.text)) {
        [self.willInsertString appendString:_inputSignField.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
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

- (NSString *)title
{
    return @"添加自定义标签";
}

@end
