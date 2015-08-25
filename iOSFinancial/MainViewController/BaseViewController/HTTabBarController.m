//
//  HTTabBarController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTTabBarController.h"
#import "HTNavigationController.h"
#import "TalkedFriendsVIewController.h"
#import "ChatRoomJoinerList.h"
#import "StateListViewController.h"
#import "SettingViewController.h"


@interface HTTabBarController ()

@end

@implementation HTTabBarController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.tabBar.translucent = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewControllers = [self subViewControllers];
    
    self.tabBar.translucent = NO;
    self.tabBar.clipsToBounds = YES;
    
    UITabBarItem *item = [[self.tabBar items] objectAtIndex:1];
    item.badgeValue = @"12";
}

- (NSArray *)subViewControllers
{
    NSMutableArray *viewControllers = [@[] mutableCopy];
    
    StateListViewController *stateVC = [[StateListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    stateVC.tabBarItem = [self tabbarItemWithTitle:@"" andItemImage:@"sign"];
    HTNavigationController *nav2 = [[HTNavigationController alloc] initWithRootViewController:stateVC];
    [viewControllers addObject:nav2];
    
    TalkedFriendsVIewController *talkVC = [[TalkedFriendsVIewController alloc] init];
    talkVC.tabBarItem = [self tabbarItemWithTitle:@"" andItemImage:@"commit"];
    HTNavigationController *nav = [[HTNavigationController alloc] initWithRootViewController:talkVC];
    [viewControllers addObject:nav];
    
    /*
    ChatRoomJoinerList *chatVC = [[ChatRoomJoinerList alloc] init];
    chatVC.tabBarItem = [self tabbarItemWithTitle:@"聊天室" andItemImage:@"address"];
    chatVC.title = @"聊天室";
    HTNavigationController *nav1 = [[HTNavigationController alloc] initWithRootViewController:chatVC];
    [viewControllers addObject:nav1];
    */
    
    SettingViewController *aboutVC = [[SettingViewController alloc] init];
    aboutVC.tabBarItem = [self tabbarItemWithTitle:@"" andItemImage:@"me"];
    HTNavigationController *nav3 = [[HTNavigationController alloc] initWithRootViewController:aboutVC];
    [viewControllers addObject:nav3];
    
    return viewControllers;
}

- (UITabBarItem *)tabbarItemWithTitle:(NSString *)title andItemImage:(NSString *)imageStr
{
    UIImage *selectImage = HTImage(HTSTR(@"%@_selected", imageStr));
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:HTImage(imageStr) selectedImage:selectImage];
    
    return tabBarItem;
}


@end
