//
//  JRJSelectionController.m
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-10-15.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTSelectionController.h"
#import "HTBaseTableViewController.h"

@interface HTSelectionController () <UIScrollViewDelegate>


@end

@implementation HTSelectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  从外边传过来的array
    [self initContentSubViewsWithTitleArray:nil];
}

- (void)initContentSubViewsWithTitleArray:(NSArray *)array
{
    if (array) {
        _functionTitles = array;
    }

    if (self.functionTitles.count == 1) {
        
        //  添加动态，消息，观点视图
        [self addContentViewController];
        
    }else if (self.functionTitles.count > 1) {
        
        //  导航条
        [self.view addSubview:self.separateView];
        
        //  多页切换控制
        [self.view addSubview:self.pageScrollView];
        
        //  添加动态，消息，观点视图
        [self addContentViewController];
    }
    
}

- (void)isHaveMessage:(BOOL)isHaveMessage atIndex:(NSInteger)index
{
    [self.separateView isHaveMessage:isHaveMessage atIndex:index];
}

- (NSInteger)selectedButtonIndex
{
    return [self.separateView indexSelectedButton];
}

/**
 *  AddSubControllers
 */
- (void)addContentViewController
{
    CGFloat viewHeight = self.view.height - self.separateView.height - self.separateView.frame.origin.y;
    CGFloat viewWidth = self.view.width;
    
    NSArray *controllers = self.selectionControllers;
    
    if (self.selectionControllers.count == 1) {
        viewHeight = self.view.height;
    }
    
    for (UIViewController *controller in controllers) {
        NSInteger index = [controllers indexOfObject:controller];
        
        controller.view.frame = CGRectMake(viewWidth * index, 0, viewWidth, viewHeight);
        
        [controller willMoveToParentViewController:self];
        
        if (self.selectionControllers.count == 1) {
            [self.view addSubview:controller.view];
        }else {
            [_pageScrollView addSubview:controller.view];
        }
        
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
        
        if ([controller isKindOfClass:[HTBaseTableViewController class]]) {
            HTBaseTableViewController *tableVc = (HTBaseTableViewController *)controller;
            
            if (index == 0) {
                tableVc.tableView.scrollsToTop = YES;
            }else {
                tableVc.tableView.scrollsToTop = NO;
            }
        }
    }
    
    if (self.selectionControllers.count > 0) {
        _pageScrollView.contentSize = CGSizeMake(self.view.width * self.functionTitles.count, 0);
    }
    
}

/**
 *  SubControllers End
 */

- (UIScrollView *)pageScrollView
{
    if (!_pageScrollView) {
        CGFloat height = _separateView.frame.origin.y + CGRectGetHeight(_separateView.frame);
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
        _pageScrollView.scrollsToTop = NO;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.showsVerticalScrollIndicator = NO;
        _pageScrollView.pagingEnabled = YES;
    }
    
    return _pageScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [_separateView selectButtonAtIndex:index animated:YES];
}

- (HTSeparateView *)separateView
{
    if (!_separateView) {
        _separateView =[[HTSeparateView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
//        _separateView.backgroundColor = [UIColor whiteColor];
        _separateView.htdelegate = self;
        NSArray *titleArray = self.functionTitles;
    
        __weakSelf;
        [_separateView setButtonClicked:^(NSInteger index) {
        
            [weakSelf.pageScrollView setContentOffset:CGPointMake(CGRectGetWidth(weakSelf.view.frame) * index, 0) animated:YES];
            
        }];
        
        [_separateView setTitles:titleArray];
    }
    
    return _separateView;
}

//  MARK: 是否可以改变导航标签   separate的代理
- (BOOL)separateViewShouldChangeMenuAtIndex:(NSInteger)index
{   
    if (!self.selectionControllers) {
        return NO;
    }
    
    id controller = [self.selectionControllers objectAtIndex:index];
    
    if ([controller isKindOfClass:[HTBaseTableViewController class]]) {
        HTBaseTableViewController *tableVc = (HTBaseTableViewController *)controller;
        tableVc.tableView.scrollsToTop = YES;
    }
    
    NSInteger selectIndex = [self selectedButtonIndex];
    
    if (selectIndex >= self.selectionControllers.count) {
        return YES;
    }
    
    id willChangeController = [self.selectionControllers objectAtIndex:[self selectedButtonIndex]];
    controller = willChangeController;
    
    if ([controller isKindOfClass:[HTBaseTableViewController class]]) {
        HTBaseTableViewController *tableVc = (HTBaseTableViewController *)controller;
        tableVc.tableView.scrollsToTop = NO;
    }

    return YES;
}

#pragma mark - Message
- (void)setIsHaveMessage:(BOOL)isHaveMessage
{
    if (_isHaveMessage != isHaveMessage) {
        _isHaveMessage = isHaveMessage;
        
        [self.separateView isHaveMessage:_isHaveMessage];
    }
}

@end
