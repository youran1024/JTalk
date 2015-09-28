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
    
//    [self printSubViews:self.tabBar];
}

- (void)printSubViews:(UIView *)view
{
    if ([view.subviews count] == 0) {
        return;
    }
    
    for (UIView *subView in view.subviews) {
        NSLog(@"%@ -> %@",NSStringFromClass([view class]), NSStringFromClass([subView class]));

        //UITabBarButton        //UITabBarSwappableImageView
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            subView.backgroundColor = HTRedColor;
            subView.top = view.height;
//            [subView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(@(view.centerY));
//            }];
            
            continue;
        }
        
        [self printSubViews:subView];
    }
}

- (NSArray *)subViewControllers
{
    NSMutableArray *viewControllers = [@[] mutableCopy];
    
    StateListViewController *stateVC = [[StateListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    stateVC.tabBarItem = [self tabbarItemWithTitle:@"" andItemImage:@"sign"];
    HTNavigationController *nav2 = [[HTNavigationController alloc] initWithRootViewController:stateVC];
    [viewControllers addObject:nav2];
    
    NSArray *conversations = @[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)];
//    NSArray *collectionConversations = @[@(ConversationType_GROUP)];
    TalkedFriendsVIewController *talkVC = [[TalkedFriendsVIewController alloc] initWithDisplayConversationTypes:conversations collectionConversationType:nil];
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
    aboutVC.tabBarItem = [self tabbarItemWithTitle:nil andItemImage:@"me"];
    HTNavigationController *nav3 = [[HTNavigationController alloc] initWithRootViewController:aboutVC];
    [viewControllers addObject:nav3];
    
    return viewControllers;
}

- (UITabBarItem *)tabbarItemWithTitle:(NSString *)title andItemImage:(NSString *)imageStr
{
    UIImage *selectImage = HTImage(HTSTR(@"%@_selected", imageStr));
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:HTImage(imageStr) selectedImage:selectImage];
    
    return tabBarItem;
}


@end
