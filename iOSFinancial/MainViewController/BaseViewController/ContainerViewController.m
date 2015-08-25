//
//  ContainerViewController.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-14.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
    if (_selectedViewController) {
        [_selectedViewController.view removeFromSuperview];
        [_selectedViewController removeFromParentViewController];
        _selectedViewController = nil;
    }
     */
}

- (void)presentViewControllerAtIndex:(NSInteger)index
{
    UIViewController <ContainerViewControllerDelegate> *addVC;
    
    if (index < self.viewControllers.count) {
        addVC = [self.viewControllers objectAtIndex:index];
    }else{
        return;
    }
    
    if (addVC == _selectedViewController) {
        return;
    }
    
    if (_selectedViewController) {
        [_selectedViewController.view removeFromSuperview];
        [_selectedViewController removeFromParentViewController];
    }

    //调整子视图（方案1，在ViewDidLoad之前）
    //[self adjustContainterViewFrame];
    
    addVC.view.frame = self.view.frame;
    
    [addVC willMoveToParentViewController:self];
    [self.view addSubview:addVC.view];
    [self addChildViewController:addVC];
    [addVC didMoveToParentViewController:self];
    
    self.selectedViewController = addVC;
    
    //调整子视图
    //[addVC viewWillAppear:YES];
    [self adjustContainterViewFrame];
    
    //[addVC viewDidAppear:YES];
    
    //处理标题
    
    if ([addVC respondsToSelector:@selector(viewControllerDidChanged:)]) {
        [addVC viewControllerDidChanged:addVC];
    }    

}

- (NSArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [self getViewControllers];
    }
    
    return _viewControllers;
}

- (NSArray *)getViewControllers
{
    return nil;
}

- (void)adjustContainterViewFrame
{
    
}

@end
