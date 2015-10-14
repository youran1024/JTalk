//
//  ShareTitleView.m
//  JRJNews
//
//  Created by guohaibin on 14-8-14.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "ShareTitleView.h"

@implementation ShareTitleView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 44)];
    if (self) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:18.0f];
        [self addSubview:label];
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        codeLabel.textColor = [UIColor whiteColor];
        codeLabel.textAlignment = NSTextAlignmentCenter;
        codeLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self addSubview:codeLabel];
        
        _codeLabel = codeLabel;
        _titleLabel = label;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_titleLabel.text.length == 0) {
        return;
    }
    
    CGFloat maxWidth = 0.0f;
    [_titleLabel sizeToFit];
    
    if (_titleLabel.size.width > 200) {
        _titleLabel.width = 200;
    }
    
    maxWidth = _titleLabel.width;
    _titleLabel.left = 0;
    _titleLabel.top = 5;
    _titleLabel.height = 22;
    
    [_codeLabel sizeToFit];
    _codeLabel.left = 0;
    _codeLabel.top = 26;
    _codeLabel.height = 18;
    if (_codeLabel.width > maxWidth) {
        maxWidth = _codeLabel.width;
    }
    
    _titleLabel.width = maxWidth;
    _codeLabel.width = maxWidth;
    self.width = maxWidth;
}


@end
