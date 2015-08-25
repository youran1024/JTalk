//
//  HTADScrollIView.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-10.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTADScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIView+NoneDataView.h"

@interface AlphaTitleLabel : UIView

@property (nonatomic, readonly, strong)   UILabel *titleLabel;

@end

@interface AlphaTitleLabel ()

@end
@implementation AlphaTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = .5;
        self.backgroundColor = [UIColor blackColor];
        CGRect rect = frame;
        rect.origin.x = 10;
        rect.origin.y = 0;
        rect.size.width -= 10;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:_titleLabel];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    
    return self;
}

@end

@interface HTADScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong)   UIScrollView *scrollView;
@property (nonatomic, strong)   AlphaTitleLabel *titleLabel;
@property (nonatomic, strong)   UIPageControl *pageControl;
@property (nonatomic, strong)   NSTimer *adChangeTimer;

@end

@implementation HTADScrollView

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images andTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _images = images;
        _titles = titles;
        
        [self createViews];
    }
    
    return self;
}

- (void)refreshView:(NSArray *)images titles:(NSArray *)titles
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _images = images;
    _titles = titles;
    
    [self createViews];
}

- (void)createViews
{
    [self initView];
    
    [self addScrollViewContent];
    
    if (_images.count > 1) {
        [self startAdTimer];
        [self adjustPageControl];
    }
}

- (void)adjustPageControl
{
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
    [_pageControl sizeToFit];
    
    CGRect rect = _pageControl.frame;
    rect.size = [_pageControl sizeForNumberOfPages:_images.count];
    
    rect.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(rect) + 5;
    rect.origin.x = (CGRectGetWidth(self.frame) - CGRectGetWidth(rect)) / 2.0f;
    _pageControl.frame = rect;
}

- (void)initView
{
    [self addSubview:self.scrollView];
    
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;

    CGFloat height = 27;
    rect.origin.y = CGRectGetHeight(rect) - height;
    rect.size.height = height;
    
    _titleLabel = [[AlphaTitleLabel alloc] initWithFrame:rect];
    
    if (_titles.count) {
        [self addSubview:_titleLabel];
    }
    
    if (_images.count > 1) {
        [self addSubview:self.pageControl];
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.decelerationRate = .1;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHEX:0xe0e0e0];
        _pageControl.hidesForSinglePage = YES;
    }
    
    return _pageControl;
}

- (void)addScrollViewContent
{
    UIImageView *imageView;
    CGRect rect = self.frame;
    rect.origin.y = 0;
    
    NSInteger count = (_images.count == 0  || _images.count == 1) ? 1 : _images.count + 2;
    
    for (int i = 0; i < count; i++) {
        NSString *urlStr;
        if (_images.count > i) {
            urlStr =   [_images objectAtIndex:i];
        }
        
        int index = 0;
        if (i == 0) {
            urlStr = [_images lastObject];
            index = (int)[_images count] - 1;
            if (index < 0) {
                index = 0;
            }
        }else if (i == count - 1) {
            urlStr = [_images firstObject];
            index = 0;
        }else {
            urlStr = _images[i - 1];
            index = i - 1;
        }

        rect.origin.x = i * CGRectGetWidth(rect);
        imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.tag = index;
        NSURL *url = [NSURL URLWithString:urlStr];
        __weak UIImageView *weakView = imageView;
        
        [imageView showNoneDataView];
        [imageView sd_setImageWithURL:url placeholderImage:HTImage(@"loadingWating1") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [weakView removeNoneDataView];
            }

        }];
        imageView.userInteractionEnabled = YES;
        
        //add gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    
    if (_titles && _titles.count > 0) {
        _titleLabel.titleLabel.text = [_titles objectAtIndex:0];
    }else {
        _titleLabel.titleLabel.text = @"";
        [_titleLabel removeFromSuperview];
        _titleLabel = nil;
    }
    
    _scrollView.contentSize = CGSizeMake(count * CGRectGetWidth(rect), CGRectGetHeight(rect));
    [_scrollView setContentOffset:CGPointMake((_images.count == 0 || _images.count == 1) ? 0 : CGRectGetWidth(rect), 0) animated:NO];
}

- (void)imageViewTouched:(UITapGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if (_touchBlock) {
        _touchBlock(view.tag);
    }
}

- (void)startAdTimer
{
    [_adChangeTimer invalidate];
    _adChangeTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeAd) userInfo:nil repeats:YES];
    _adChangeTimer.tolerance = 3.0f;
}

- (void)changeAd
{
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    NSInteger i = _scrollView.contentOffset.x / width + 1;

    [_scrollView setContentOffset:CGPointMake(width * i, 0) animated:YES];
    
    if (i == _images.count + 1) {
        _pageControl.currentPage = 0;
    }else {
        _pageControl.currentPage = i - 1;
    }
    
    if (_titles) {
        _titleLabel.titleLabel.text = [_titles objectAtIndex:i];
    }
}

/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_scrollView.isDecelerating) {
        _scrollView.scrollEnabled = NO;
        return YES;
    }
 
    return [super pointInside:point withEvent:event];
}
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.frame);
    NSInteger i = scrollView.contentOffset.x / width;
    
    if ((i == 0 || i == _images.count + 1) && scrollView.isDecelerating) {
        scrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_adChangeTimer invalidate];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self startAdTimer];
    
    scrollView.scrollEnabled = YES;
    
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    NSInteger i = _scrollView.contentOffset.x / width;
    
    if (i == _images.count + 1) {
        [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startAdTimer];
    
    scrollView.scrollEnabled = YES;
    CGFloat width = CGRectGetWidth(scrollView.frame);
    NSInteger i = scrollView.contentOffset.x / width;
    
    if (i == 0) {
        [scrollView setContentOffset:CGPointMake(width *_images.count, 0) animated:NO];
        _pageControl.currentPage = _images.count - 1;
        
    }else if (i == _images.count + 1) {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:NO];
        _pageControl.currentPage = 0;
    }else {
        _pageControl.currentPage = i - 1;
    }
    
    if (_titles) {
        _titleLabel.titleLabel.text = [_titles objectAtIndex:i];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchBlock) {
        _touchBlock(_pageControl.currentPage);
    }
}

@end
