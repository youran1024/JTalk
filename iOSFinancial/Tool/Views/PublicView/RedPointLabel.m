//
//  RedPointLabel.m
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-10-9.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "RedPointLabel.h"

@interface RedPointLabel  ()

@property (nonatomic, strong)   UIImageView *pointView;

@end

@implementation RedPointLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.pointView];

    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self addSubview:self.pointView];
    }
    
    return self;
}

- (void)setIsHaveMessage:(BOOL)isHaveMessage
{
    if (_isHaveMessage != isHaveMessage) {
        _isHaveMessage = isHaveMessage;
        
        _pointView.hidden = !_isHaveMessage;
    }
}

- (UIImageView *)pointView
{
    if (!_pointView) {
        _pointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPoint"]];
        _pointView.backgroundColor = [UIColor clearColor];
    }
    
    return _pointView;
}

- (void)layoutSubviews
{
    self.pointView.left = CGRectGetWidth(self.frame);
}

@end
