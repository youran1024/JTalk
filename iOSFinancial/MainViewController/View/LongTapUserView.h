//
//  LongTapUserView.h
//  JTalk
//
//  Created by Mr.Yang on 15/9/14.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface LongTapUserView : HTBaseView

@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, strong)  IBOutlet UIImageView *headImageView;
@property (nonatomic, strong)   IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)   IBOutlet UILabel *promptLabel;


//  1. 屏蔽举报  //2. @TA  //3.取消
@property (nonatomic, copy) void(^buttonClickBlock)(UIButton *button, NSInteger type);

@end
