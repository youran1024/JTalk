//
//  ChatRoomInfo.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ChatRoomInfo.h"

@interface ChatRoomInfo ()

@property (nonatomic, assign) IBOutlet  UIView *lineView;

@end


@implementation ChatRoomInfo

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.width / 2.0f;
    
    self.nameLabel.textColor = [UIColor jt_globleTextColor];
    self.tailLabel.textColor = [UIColor jt_barTintColor];
    self.lineView.backgroundColor = [UIColor jt_lineColor];
}



@end
