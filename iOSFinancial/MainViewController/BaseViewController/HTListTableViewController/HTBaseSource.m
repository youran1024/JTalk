//
//  HTBaseSource.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/31.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseSource.h"

@implementation HTBaseSource

+ (Class)cellClass
{
    return [UITableViewCell class];
}

- (CGFloat)height
{
    if (_height > 0.0f) {
        return _height;
    }
    
    CGFloat cellHeight = [self cellHeight];
    
    if (cellHeight > 0.0f) {
        _height = cellHeight;
        return cellHeight;
    }
    
    return _height;
}

- (CGFloat)cellHeight
{
    return [[[self class] cellClass] fixedHeight];
}

@end
