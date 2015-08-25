//
//  HTEditCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTEditCell.h"

@implementation HTEditCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.returnKeyType = UIReturnKeyDone;
    self.titleLabel.textColor = [UIColor jt_globleTextColor];
    self.textField.textColor = [UIColor colorWithHEX:0xb1b0b0];
    
}

@end
