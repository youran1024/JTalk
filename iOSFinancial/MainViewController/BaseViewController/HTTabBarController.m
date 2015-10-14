//
//  HTTabBarController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/27.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTTabBarController.h"
#import "HTNavigationController.h"
#import "StoreViewController.h"
#import "CartViewController.h"
#import "FindViewController.h"
#import "MyStoreViewController.h"
#import "MineViewController.h"


@interface HTTabBarController ()

@end

@implementation HTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    
    self.viewControllers = [self subViewControllers];
    
    //  去掉顶部的阴影线
    self.tabBar.clipsToBounds = YES;
    
    [self changeShowdImageColor];
}

//  改变阴影线颜色
- (void)changeShowdImageColor
{
    CGRect rect = CGRectMake(0, 0, APPScreenWidth, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,HTHexColor(0xefeeee).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
}
 
- (NSArray *)subViewControllers
{
    StoreViewController *store = [[StoreViewController alloc]init];
    store.tabBarItem = [self tabbarItemWithTitle:@"商城" andItemImage:@"shangjia_icon"];
    HTNavigationController *nav1 = [[HTNavigationController alloc] initWithRootViewController:store];
    
    CartViewController *cart = [[CartViewController alloc]init];
    cart.tabBarItem = [self tabbarItemWithTitle:@"购物车" andItemImage:@"gouwuche_icon"];
    HTNavigationController *nav2 = [[HTNavigationController alloc] initWithRootViewController:cart];
    
    FindViewController *find = [[FindViewController alloc]init];
    find.tabBarItem = [self tabbarItemWithTitle:@"寻鲜" andItemImage:@"xunxian_icon"];
    HTNavigationController *nav3 = [[HTNavigationController alloc] initWithRootViewController:find];
    
    MyStoreViewController *myStore = [[MyStoreViewController alloc]init];
    myStore.tabBarItem = [self tabbarItemWithTitle:@"我的店" andItemImage:@"wode_icon"];
    HTNavigationController *nav4 = [[HTNavigationController alloc] initWithRootViewController:myStore];
    
    MineViewController *mine = [[MineViewController alloc]init];
    mine.tabBarItem = [self tabbarItemWithTitle:@"我的" andItemImage:@"maishoudian_icon"];
    HTNavigationController *nav5 = [[HTNavigationController alloc] initWithRootViewController:mine];
    
    return @[nav1, nav2, nav3, nav4, nav5];
}

- (UITabBarItem *)tabbarItemWithTitle:(NSString *)title andItemImage:(NSString *)imageStr
{
    UIImage *selectImage = HTImage(HTSTR(@"%@_2", imageStr));
    UIImage *normalImage = HTImage(HTSTR(@"%@_1", imageStr));
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectImage];
    
    return tabBarItem;
}


@end
