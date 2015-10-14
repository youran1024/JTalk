//
//  HTWebViewController.h
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBaseViewController.h"

@class HTWebProgressView;
@protocol HTWebViewDelegate;

@interface HTWebView :UIWebView

@property (nonatomic, assign) id <HTWebViewDelegate> progressDelegate;

@end


@interface HTWebViewController : HTBaseViewController

@property (nonatomic, strong)   NSURL *url;
@property (nonatomic, strong, readonly) HTWebView *webView;
@property (nonatomic, strong)   HTWebProgressView *progressView;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) BOOL loadData;

- (void)setHeaderObject:(id)anObject forKey:(id)aKey;

@end
