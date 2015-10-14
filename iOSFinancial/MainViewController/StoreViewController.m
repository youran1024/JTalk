//
//  StoreViewController.m
//  XianLife
//
//  Created by Mr.Yan on 15/10/13.
//  Copyright © 2015年 Mr.Yan. All rights reserved.
//

#import "StoreViewController.h"
#import "HTSeparateView.h"
#import "LocalStoreViewController.h"
#import "GlobleViewController.h"
#import "NewProductViewController.h"


@interface StoreViewController ()

@end

@implementation StoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商城";
    
    self.separateView.backgroundColor = [UIColor whiteColor];
    
}

- (NSArray *)functionTitles
{
    if (!_functionTitles) {
        _functionTitles = @[@"商城", @"全球精选", @"新品上市"];
    }
    
    return _functionTitles;
}

- (NSArray *)selectionControllers
{
    NSMutableArray *array = [@[]mutableCopy];
    
    if (!_selectionControllers) {
        LocalStoreViewController *investController = [[LocalStoreViewController alloc] init];
        [array addObject:investController];
        
        GlobleViewController *toInvest = [[GlobleViewController alloc] init];
        [array addObject:toInvest];
        
        NewProductViewController *finish = [[NewProductViewController alloc] init];
        [array addObject:finish];
        
        _selectionControllers = array;
    }
    
    return _selectionControllers;
}


@end
