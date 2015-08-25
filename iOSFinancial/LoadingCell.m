
//
//  LoadingCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/11.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "LoadingCell.h"

@interface LoadingCell ()

@property (nonatomic, strong) IBOutlet  UIActivityIndicatorView *indicatorView;



@end


@implementation LoadingCell

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    if (loading) {
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
    }else {
        [_indicatorView stopAnimating];
        _indicatorView.hidden = YES;
    }
}


@end
