//
//  TalkViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkViewController.h"
#import "UIView+BorderColor.h"
#import "PersonalViewController.h"
#import "UIBarButtonExtern.h"
#import "CommitListViewController.h"
#import "TalkSettingViewController.h"


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
    [super viewDidLoad];

    /*
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.conversationMessageCollectionView.height -= 20.0f;
    self.conversationMessageCollectionView.top = 44.0f;
     */
    
    self.conversationMessageCollectionView.height = self.view.height - 44.0f;
    self.conversationMessageCollectionView.top = 64.0f;
    
    UIBarButtonItem *item1 = [UIBarButtonExtern buttonWithImage:@"talkPeopleList" target:self andSelector:@selector(showGroupJoinerListView)];
    UIBarButtonItem *item2 = [UIBarButtonExtern buttonWithImage:@"talkSetting" target:self andSelector:@selector(showTalkSettingViewController
                                                                                                                 )];
    self.navigationItem.rightBarButtonItems = @[item2, item1];
    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
}

- (void)showTalkSettingViewController
{
    TalkSettingViewController *setting = [[TalkSettingViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)showGroupJoinerListView
{
    CommitListViewController *commit = [[CommitListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    commit.groupTitle = self.groupTitle;
    [self.navigationController pushViewController:commit animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    PersonalViewController *personal = [[PersonalViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    personal.userId = userId;
    
    personal.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personal animated:YES];
}

@end
