//
//  AppDelegate.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/26.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTabBarController.h"
#import "HTNavigationController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  HTTabBarController *tabBarController;

@end

