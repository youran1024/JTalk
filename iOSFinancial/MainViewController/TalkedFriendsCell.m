//
//  TalkedFriendsCell.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkedFriendsCell.h"

@implementation TalkedFriendsCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
    
    self.nameLabel.textColor = [UIColor jt_globleTextColor];
    self.promptLabel.textColor = [UIColor jt_lightBlackTextColor];
    self.timeLabel.textColor = [UIColor jt_lightBlackTextColor];
    
    self.timeLabel.right = self.width - 15.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.timeLabel.right = self.width - 15.0f;
}


@end
