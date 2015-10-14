//
//  UIView+NoneDataView.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/6/25.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingStateView.h"


@interface UIView (NoneDataView)

- (LoadingStateView *)showNoneDataView;
- (void)removeNoneDataView;

@end
