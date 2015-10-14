//
//  UIViewController+GuideVIew.m
//  JRJNews
//
//  Created by Mr.Yang on 14-6-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTGuideManager.h"

#define __HTGuideViewVersionKey   @"guideViewVersionKeyVer1.0"

static HTGuideManager *__guideManager = nil;

@interface HTGuideManager () <UIScrollViewDelegate>
{
    NSInteger _windowLevel;
    UIPageControl *_pageControl;
}

@property (nonatomic, strong)   UIScrollView *guideScrollView;


@end

@implementation HTGuideManager

+ (HTGuideManager *)showGuideViewWithDelegate:(id<HTGuideManagerDelegate>)delegate
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *version = [userDefault valueForKey:__HTGuideViewVersionKey];
    
    if (!isEmpty(version) && [version compare:__HTGuideViewVersion] != NSOrderedAscending) {
        return nil;
    }
    
    if (__guideManager) {
        [__guideManager makeGuideViewDisappear];
        __guideManager = nil;
    }
    
    //  keep self
    __guideManager = [[HTGuideManager alloc] init];
    
    if (__guideManager) {
        __guideManager.delegate = delegate;
        [__guideManager showGuidPage:YES];
    }
    
    return __guideManager;
}

- (UIScrollView *)guideScrollView
{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.showsHorizontalScrollIndicator = NO;
        _guideScrollView.delegate = self;
    }

    return _guideScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _pageControl.pageIndicatorTintColor = HTHexColor(0xeeeeee);
        _pageControl.currentPageIndicatorTintColor = HTHexColor(0xcccccc);
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }

    return _pageControl;
}

- (void)showGuidPage:(BOOL)animated
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageScrollviewGesture:)];
    
    NSInteger numPages = __HTGuideViewPages;
    for (int i = 0; i < numPages; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.guideScrollView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //  add tapGesutreAction at last page
        if (i == (numPages - 1)){
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
        }
        
        imageView.left = APPScreenWidth * i;
        
        NSString *imageStr;
        
        if (is4Inch) {
            imageStr = HTSTR(@"guideImage4%d", i);
        }else if (is47Inch) {
            imageStr = HTSTR(@"guideImage47%d", i);
        }else if (is55Inch) {
            imageStr = HTSTR(@"guideImage55%d", i);
        }else {
            imageStr = HTSTR(@"guideImage%d", i);
        }
        
        UIImage *image = HTImage(imageStr);
        
        if (!image) {
            [self makeGuideViewDisappear];
            return;
        }
        
        imageView.image = image;
        
        [self.guideScrollView addSubview:imageView];
        
        if (i == (numPages - 1)) {
            CGFloat buttonWith = 128.0;
            CGFloat buttonHeight = 33.0f;
            
            [self.guideScrollView addSubview:self.finishButton];
            
            CGFloat margin = .0f;
            if (is55Inch) {
                margin = 100.0f;
                buttonWith = 168.0f;
                buttonHeight = 44.0f;
                
            }else if (is35Inch) {
                margin = 55.0f;
                
            }else {
                margin = 70.0f;
            }
            
            self.finishButton.frame = CGRectMake(i * APPScreenWidth + (int)(APPScreenWidth - buttonWith) / 2, APPScreenHeight - margin, buttonWith, buttonHeight);
        }
    }
    
    _guideScrollView.contentSize = CGSizeMake(APPScreenWidth * numPages, CGRectGetHeight(_guideScrollView.frame));
    
    CATransition *animation = [CATransition animation];
    animation.duration = .25;
    animation.type = kCATransitionFade;
    [_guideScrollView.layer addAnimation:animation forKey:@"remove"];
    
    UIWindow *keyWindow = self.showWindow;
    _windowLevel = keyWindow.windowLevel;
    keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
    [keyWindow addSubview:_guideScrollView];
    
    self.pageControl.numberOfPages = numPages;
    [self.pageControl sizeToFit];
    [keyWindow addSubview:self.pageControl];
    
    self.pageControl.left = (APPScreenWidth - self.pageControl.width) / 2.0f;
    self.pageControl.bottom = RealScreenHeight - (is35Inch ? 10 : 10);
    
    _guideScrollView.alpha = 0;
    
    [UIView animateWithDuration:animated ? .25 : 0 animations:^{
        _guideScrollView.alpha = 1;
    }];
}

- (UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _finishButton.backgroundColor = [UIColor clearColor];
        
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"guide_button_confirm"] forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_finishButton addTarget:self action:@selector(btnEnterAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _finishButton;
}

- (UIWindow *)showWindow
{
    if (!_showWindow) {
        _showWindow = [[UIApplication sharedApplication] keyWindow];
    }

    return _showWindow;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger numberOfPage = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = numberOfPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != _guideScrollView) {
        return;
    }

    if (scrollView.contentOffset.x > (scrollView.contentSize.width - CGRectGetWidth(scrollView.frame))) {

        scrollView.backgroundColor = [UIColor clearColor];
    }else {
        scrollView.backgroundColor = [UIColor jt_backgroudColor];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView != _guideScrollView) {
        return;
    }
    
    if (scrollView.contentOffset.x > scrollView.contentSize.width - APPScreenWidth + 20.0f) {
        [self doDisappearAnimation];
    }
}

- (void)imageScrollviewGesture:(UITapGestureRecognizer *)tap
{
    [self doDisappearAnimation];
}

- (void)btnEnterAction:(UIButton *)button
{
    [self doDisappearAnimation];
}

- (void)doDisappearAnimation
{
    __weak HTGuideManager *weakGuideManager = self;
    [UIView animateWithDuration:.25 animations:^{
        weakGuideManager.guideScrollView.alpha = .0;
        weakGuideManager.pageControl.alpha = .0;
    } completion:^(BOOL finished) {
        [weakGuideManager doNotifaction];
    }];
}

- (void)doNotifaction
{
    if (_delegate && [_delegate respondsToSelector:@selector(guideManagerWantDisappear:)]) {
        [_delegate guideManagerWantDisappear:__guideManager];
    }
}

- (void)makeGuideViewDisappear
{
    self.showWindow.windowLevel = _windowLevel;
    
    //  存储引导页版本
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:__HTGuideViewVersion forKey:__HTGuideViewVersionKey];
    [userDefault synchronize];
    
    [_guideScrollView removeFromSuperview];
    _guideScrollView = nil;
    
    [_pageControl removeFromSuperview];
    _pageControl = nil;
    
    __guideManager = nil;
}

@end
