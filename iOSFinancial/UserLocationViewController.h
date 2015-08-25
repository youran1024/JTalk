//
//  UserLocationViewController.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/11.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseTableViewController.h"

typedef void(^GetCityNameBlock)(NSString *cityName);

@interface UserLocationViewController : HTBaseTableViewController

@property (nonatomic, copy) void(^userSelectedBlock)(NSString *cityName);

- (void)getCityNameWithBlock:(GetCityNameBlock)block;

@end

