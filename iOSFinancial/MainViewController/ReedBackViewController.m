//
//  IdeaSendViewController.m
//  iOSFinancial
//
//  Created by Mr.Yan on 15/4/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ReedBackViewController.h"
#import "PlaceHolderTextView.h"
#import "UIBarButtonExtern.h"
#import <UMengFeedback/UMFeedback.h>


@interface ReedBackViewController ()

@property (nonatomic, strong) HTPlaceHolderTextView *textView1;

@end

@implementation ReedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textView1];
    self.textView1.placeholder = @"非常感谢您的支持, 辛苦~";
    
    /*
    UIButton *btn = [Sundry BigBtnWithHihtY:_textView1.bottom + 10 withTitle:@"提交"];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(postMessage) forControlEvents:UIControlEventTouchDown];
    */
     
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"提交" target:self andSelector:@selector(confirmButtonClicked:)];
}

- (HTPlaceHolderTextView *)textView1
{
    if (!_textView1) {
        _textView1 = [[HTPlaceHolderTextView alloc] init];
        _textView1.frame = CGRectMake(10, 10 + TransparentTopHeight, APPScreenWidth - 20, 200);
        _textView1.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
        _textView1.font = [UIFont systemFontOfSize:15];
        _textView1.textColor = [UIColor jt_globleTextColor];
        _textView1.placeholderColor = [UIColor jt_lightBlackTextColor];
        _textView1.layer.cornerRadius = 3.0;
        _textView1.layer.borderWidth = .3;
        _textView1.layer.borderColor = [[UIColor jt_lineColor] CGColor];
    }
    
    return _textView1;
}

- (void)confirmButtonClicked:(UIBarButtonItem *)barbutton
{
    [self postMessage];
}

- (void)postMessage
{
    [self.view endEditing:YES];
    
    if (self.textView1.text.length < 5) {
        [self showHudAuto:@"文字长度不能低于5个字符 ，谢谢合作"];
        return;
    }else
    {
        NSString *text = _textView1.text;
        text = text.length > 2000 ? [text substringToIndex:2000] : text;
        
        NSDictionary *param = @{@"content": text};
        [[UMFeedback sharedInstance] post:param completion:^(NSError *error) {
            [self showHudSuccessView:@"反馈成功，感谢您的支持!"];
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0f];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [self.view endEditing:YES];
}

- (NSString *)title
{
    return @"意见反馈";
}

@end
