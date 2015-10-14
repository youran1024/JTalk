//
//  ChatRoomCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ChatRoomCell.h"

@implementation ChatRoomCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
    
    self.nameLabel.textColor = [UIColor jt_globleTextColor];
    self.timeLabel.textColor = [UIColor jt_lightBlackTextColor];
}

@end
