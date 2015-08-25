//
//  HTGuideManager.h
//  JRJNews
//
//  Created by Mr.Yang on 14-6-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  程序启动引导页
 */

//  GuideView Version 引导页的版本号
#define __HTGuideViewVersion      @"2.1"

#define __HTGuideViewPages        4

/**
 *  系统自动读取要展示的图片，但是图片名称要符合规范
 *  guideImage35 ， guideImage
 *  除了3.5寸屏，其它的全部用5.5寸屏的做拉伸
 */

@class HTGuideManager;
@protocol HTGuideManagerDelegate <NSObject>

- (void)guideManagerWantDisappear:(HTGuideManager *)guideManager;

@end

@interface HTGuideManager : NSObject

@property (nonatomic, weak) UIWindow *showWindow;

//  页面指示器,可以修改颜色
@property (nonatomic, strong, readonly)   UIPageControl *pageControl;
//  最后一页的完成按钮
@property (nonatomic, strong)   UIButton *finishButton;
//  移除界面前的事件回调
@property (nonatomic, weak) id <HTGuideManagerDelegate>delegate;

+ (HTGuideManager *)showGuideViewWithDelegate:(id <HTGuideManagerDelegate>)delegate;

//  使视图消失
- (void)makeGuideViewDisappear;

@end
