//
//  ContainerViewController.h
//  JRJNews
//
//  Created by Mr.Yang on 14-4-14.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseViewController.h"

@protocol ContainerViewControllerDelegate <NSObject>

@required
//将要添加的Controller
- (void)viewControllerDidChanged:(UIViewController *)changedViewController;

@end

/**
 *  容器类，实现视图切换
 */

@interface ContainerViewController : HTBaseViewController
{
    @package
    NSArray *_viewControllers;
}

/**
 *  当前选中的试图控制器
 */
@property (nonatomic, strong)   UIViewController *selectedViewController;
/**
 *  管理的所有控制器
 */
@property (nonatomic, strong)   NSArray *viewControllers;

/**
 *  需要显示的控制器
 *
 *  @param index 控制器所在的位置
 */
- (void)presentViewControllerAtIndex:(NSInteger)index;

/**
 *  以下方法需要子类重写
 */

//  重新调整视图大小
- (void)adjustContainterViewFrame;

//  需要管理的Controllers
- (NSArray *)getViewControllers;

@end
