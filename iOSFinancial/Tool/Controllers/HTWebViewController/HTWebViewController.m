//
//  HTWebViewController.m
//  HTWebView
//
//  Created by Mr.Yang on 13-8-2.
//  Copyright (c) 2013年 Hunter. All rights reserved.
//

#import "HTWebViewController.h"


@protocol HTWebViewDelegate <NSObject>

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent;

@end

@interface UIWebView ()

// private API
-(id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource;
-(void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource;

@end


@interface HTWebProgressView : UIView

@property (nonatomic, assign)   CGFloat progressValue;
@property (nonatomic, strong)   UIColor *tintColor;

@end

@implementation HTWebProgressView

- (id)init
{
    self = [super init];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initVariables];
    }
    return self;
}

- (void)initVariables
{
    _tintColor = [UIColor greenColor];
    self.backgroundColor = HTHexColor(0x0066aa);
    _progressValue = 0.0f;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    if (progressValue > 1.0f) {
        progressValue = 1.0f;
    }
    
    if (progressValue < .0f) {
        progressValue = .0f;
    }
    
    CGRect rect = self.frame;
    static CGFloat width;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = rect.size.width;
    });

    if (progressValue > _progressValue) {
        _progressValue = progressValue;
        rect.size.width = width * _progressValue;
        self.frame = rect;
    }
}

@end

@implementation HTWebView

{
    CGFloat _totalCount;
    NSInteger _receiveCount;
}

- (id)webView:(id)view identifierForInitialRequest:(id)initialRequest fromDataSource:(id)dataSource
{
    [super webView:view identifierForInitialRequest:initialRequest fromDataSource:dataSource];
    
    return @(_totalCount++);
}

- (void)webView:(id)view resource:(id)resource didFinishLoadingFromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFinishLoadingFromDataSource:dataSource];
    
    _receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:_receiveCount/_totalCount ];
    }

    if (_receiveCount == _totalCount) {
        _receiveCount = 0.0;
        _totalCount = 0.0;
    }
}

- (void)webView:(id)view resource:(id)resource didFailLoadingWithError:(id)error fromDataSource:(id)dataSource
{
    [super webView:view resource:resource didFailLoadingWithError:error fromDataSource:dataSource];
    
    _receiveCount++;
    if (_progressDelegate && [_progressDelegate respondsToSelector:@selector(webView:didReceiveDataPresent:)]) {
        [_progressDelegate webView:self didReceiveDataPresent:(CGFloat)_receiveCount/(CGFloat)_totalCount ];
    }
    
    if (_receiveCount == _totalCount) {
        _receiveCount = 0.0;
        _totalCount = 0.0;
    }
}

@end


@interface HTWebViewController () <HTWebViewDelegate, UIWebViewDelegate>
{
    BOOL _loadError;
}

@property (nonatomic, strong)   NSMutableDictionary *headerDic;

@end

@implementation HTWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    __weakSelf;
    [self.loadingStateView setTouchBlock:^(LoadingStateView *view, LoadingState state){
        [weakSelf refresh:weakSelf.url];
    }];
}

- (void)setUrl:(NSURL *)url
{
    
//    if (![_url.absoluteString isEqualToString:url.absoluteString]) {
        _url = url;
        [self refresh:url];
//}
    
}

- (void)loadListRequest
{
    [self refresh:_url];
}

- (void)refresh:(NSURL *)url
{
    if (!url.absoluteString || url.absoluteString.length == 0) {
        return;
    }
    
    if (!_progressView) {
        _progressView = [[HTWebProgressView alloc] initWithFrame:CGRectMake(0, TransparentTopHeight, self.view.width, 3)];

        _progressView.backgroundColor = [UIColor jd_settingDetailColor];
    }
    
    _progressView.progressValue = .06f;
    
    if (!_webView) {
        _webView = [[HTWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.backgroundColor = [UIColor jt_backgroudColor];
        _webView.progressDelegate = self;
        [self.view addSubview:_webView];
    }
    
    [_webView addSubview:_progressView];
    
    [self showLoadingViewWithState:LoadingStateLoading];
    
    if (_loadData) {
        [_webView loadData:[NSData dataWithContentsOfURL:_url] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:_url];
        _webView.scalesPageToFit = NO;
        
    }else {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSMutableURLRequest *urlRequest = [request mutableCopy];
        urlRequest.allHTTPHeaderFields = [self addRequestHeader:urlRequest.allHTTPHeaderFields];
        [_webView loadRequest:urlRequest];
    }
}

- (void)setHeaderObject:(id)anObject forKey:(id)aKey
{
    [self.headerDic setValue:anObject forKey:aKey];
}

- (NSDictionary *)addRequestHeader:(NSDictionary *)headerDic
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
    
    [mutDic setValue:@"ios" forKey:@"fromApp"];
    
    for (NSString *key in [_headerDic allKeys]) {
        id obj = [_headerDic objectForKey:key];
        
        [mutDic setValue:obj forKey:key];
    }
    
    return mutDic;
}

- (void)webView:(HTWebView *)webView didReceiveDataPresent:(CGFloat)persent
{
    if (persent < .06f || _loadError) {
        return;
    }
    
    [self removeLoadingView];
    
    _progressView.progressValue = persent;
    
    if (persent >= 1.0f) {
        _progressView.hidden = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    _progressView.hidden = NO;
    _loadError = NO;
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadError = YES;
    _progressView.hidden = YES;
    
    [self showLoadingViewWithState:LoadingStateNetworkError];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeLoadingView];
}

- (NSString *)mimeType:(NSURL *)url
{
    //1NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2NSURLConnection
    
    //3 在NSURLResponse里，服务器告诉浏览器用什么方式打开文件。
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

#pragma mark -
- (NSString *)title
{
    if(self.titleStr && self.titleStr.length > 0){
        return self.titleStr;
    }
    
    return @"";
}

- (NSMutableDictionary *)headerDic
{
    if (!_headerDic) {
        _headerDic = [NSMutableDictionary dictionary];
    }
    
    return _headerDic;
}

@end
