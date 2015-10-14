//
//  TalkListToolBar.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface TalkListToolBar : HTBaseView

@property (nonatomic, strong)   IBOutlet UIButton *talkButton;
@property (nonatomic, strong)   IBOutlet UIButton *commitListButton;
@property (nonatomic, strong)   IBOutlet UIButton *quiteButton;

@property (nonatomic, copy) void(^functionButtonBlock)(NSInteger index);

- (void)selectIndex:(NSInteger)index;

@end
