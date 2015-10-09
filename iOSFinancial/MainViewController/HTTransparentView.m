//
//  HTTransparentView.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-23.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTTransparentView.h"

@implementation HTTransparentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initlization];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = APPScreenFrame;
        [self initlization];
    }
    return self;
}

+ (HTTransparentView *)transparentView
{
    return [[self alloc] init];
}

- (void)initlization
{
    self.alpha  = .5;
    self.backgroundColor = [UIColor blackColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(transparentViewDidTaped:)]) {
        [_delegate transparentViewDidTaped:self];
    }
    
    if (_touchBlock) {
        _touchBlock();
    }
}

@end
