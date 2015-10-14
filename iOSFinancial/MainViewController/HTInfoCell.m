//
//  HTInfoCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTInfoCell.h"

@implementation HTInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titleLabel.textColor = [UIColor jt_globleTextColor];
    _placeHolderView.placeholderColor = [UIColor jt_lightGrayColor];
    _placeHolderView.font = [UIFont systemFontOfSize:15.0f];
    _placeHolderView.textColor = [UIColor colorWithHEX:0xb1b0b0];;
}


@end
