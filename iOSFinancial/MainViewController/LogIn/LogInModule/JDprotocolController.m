//
//  JDprotocolController.m
//  iOSFinancial
//
//  Created by Mr.Yan on 15/4/24.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "JDprotocolController.h"
@interface JDprotocolController()<UIWebViewDelegate>
@end
@implementation JDprotocolController

- (void)addURL:(NSString *)URL withTitle:(NSString *)title
{
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    [web loadData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:URL]];
    self.title = title;
    [self.view addSubview:web];
}

@end
