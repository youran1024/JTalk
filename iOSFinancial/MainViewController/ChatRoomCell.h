//
//  ChatRoomCell.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/4.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"

@interface ChatRoomCell : HTBaseCell


@property (nonatomic, strong)   IBOutlet UIImageView *headImageView;
@property (nonatomic, strong)   IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)   IBOutlet UILabel *timeLabel;

@end
