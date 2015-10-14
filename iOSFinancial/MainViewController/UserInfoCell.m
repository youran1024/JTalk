//
//  UserInfoCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib
{
    self.headerImageView.layer.cornerRadius = self.headerImageView.width / 2.0f;
    self.headerImageView.layer.masksToBounds = YES;

    self.nameLabel.textColor = [UIColor jt_globleTextColor];
}


@end
