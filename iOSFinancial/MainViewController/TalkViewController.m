//
//  TalkViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkViewController.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self revertNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self revertNavigationBar];
}

- (void)revertNavigationBar
{
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor jt_barTintColor];
}

- (void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;
    [super viewDidLoad];
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    
}

- (void)keyboardDidDissmiss
{
    [self viewWillLayoutSubviews];
}

/*
- (void)didTouchEmojiButton:(UIButton *)sender
{
    if (self.emojiBoardView.bottom == self.view.bottom) {
        self.emojiBoardView.top = self.view.bottom;
        self.chatSessionInputBarControl.bottom = self.view.bottom;
    }else {
        self.emojiBoardView.bottom = self.view.bottom;
        self.chatSessionInputBarControl.bottom = self.emojiBoardView.top;
    }
}
 */


@end
