//
//  TalkListToolBar.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkListToolBar.h"

@implementation TalkListToolBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor jt_barTintColor];

}

- (IBAction)functionClicked:(UIButton *)button
{
    button.selected = YES;
    
    if (button.tag == 0) {
        _commitListButton.selected = NO;
    }else {
        _talkButton.selected = NO;
    }
    
    if (_functionButtonBlock) {
        _functionButtonBlock(button.tag);
    }

}

- (void)selectIndex:(NSInteger)index
{
    if (index == 0) {
        _talkButton.selected = YES;
        _commitListButton.selected = NO;
    }else {
        _talkButton.selected = NO;
        _commitListButton.selected = YES;
    }

}

@end
