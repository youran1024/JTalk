//
//  TalkListViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkListViewController.h"
#import "TalkListToolBar.h"
#import "HTBaseTableViewController.h"
#import "TalkViewController.h"
#import "CommitListViewController.h"
#import "TalkedFriendsVIewController.h"


@interface TalkListViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)   TalkListToolBar *toolbar;
@property (nonatomic, strong)   UIScrollView *pageScrollView;
//  需要切换的Controller
@property (nonatomic, strong)   NSArray *selectionControllers;

@property (nonatomic, strong)   TalkViewController *talkViewController;



@end

@implementation TalkListViewController

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
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.pageScrollView];

    [self.view addSubview:self.toolbar];
    
    [self addContentViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDissmiss) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidDissmiss) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardDidDissmiss
{
    [self viewWillLayoutSubviews];
}

- (void)viewWillLayoutSubviews
{
//    [self layoutViews];
    
    self.talkViewController.conversationMessageCollectionView.height = self.talkViewController.conversationMessageCollectionView.height - self.talkViewController.chatSessionInputBarControl.height;
    
    self.talkViewController.chatSessionInputBarControl.top = self.talkViewController.conversationMessageCollectionView.bottom;
}

- (NSArray *)selectionControllers
{
    if (!_selectionControllers) {
        
        TalkViewController *conversationVC = [[TalkViewController alloc] init];
        conversationVC.conversationType =ConversationType_GROUP; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"55d81cd1b217c414ea07eb9c"; // 接收者的 targetId，这里为举例。
        conversationVC.userName = @"Mr.Yang"; // 接受者的 username，这里为举例。
        conversationVC.title = @"Mr.Yang_Hello"; // 会话的 title。
        
        self.talkViewController = conversationVC;
        
        CommitListViewController *commit = [[CommitListViewController alloc]init];
        
        _selectionControllers = @[conversationVC, commit];
    }

    return _selectionControllers;
}

/**
 *  AddSubControllers
 */

- (void)layoutViews
{
    CGFloat viewHeight = self.pageScrollView.height;
    CGFloat viewWidth = self.view.width;
    
    NSArray *controllers = self.selectionControllers;
    
    if (self.selectionControllers.count == 1) {
        viewHeight = self.view.height;
    }

    for (UIViewController *controller in controllers) {
        NSInteger index = [controllers indexOfObject:controller];
        
        controller.view.frame = CGRectMake(viewWidth * index, 0, viewWidth, viewHeight);
    }
}

- (void)addContentViewController
{
    CGFloat viewHeight = self.pageScrollView.height;
    NSArray *controllers = self.selectionControllers;
    
    if (self.selectionControllers.count == 1) {
        viewHeight = self.view.height;
    }
    
    for (UIViewController *controller in controllers) {
        NSInteger index = [controllers indexOfObject:controller];
        controller.view.frame = CGRectMake(APPScreenWidth * index, 0, APPScreenWidth, viewHeight);
        controller.view.layer.borderColor = HTRedColor.CGColor;
        controller.view.layer.borderWidth = 6.0f;
        if (index == 1) {
            controller.view.layer.borderColor = HTGreenColor.CGColor;
        }
        
        [self addChildViewController:controller];
    
        [_pageScrollView addSubview:controller.view];
        
        if ([controller isKindOfClass:[HTBaseTableViewController class]]) {
            HTBaseTableViewController *tableVc = (HTBaseTableViewController *)controller;
            
            if (index == 0) {
                tableVc.tableView.scrollsToTop = YES;
            }else {
                tableVc.tableView.scrollsToTop = NO;
            }
        }
    }
    
    if (self.selectionControllers.count > 0) {
        _pageScrollView.contentSize = CGSizeMake(self.view.width * controllers.count, 0);
    }
    
}

/**
 *  SubControllers End
 */

- (UIScrollView *)pageScrollView
{
    if (!_pageScrollView) {
        _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, APPScreenHeight -  44)];
        _pageScrollView.autoresizingMask = UIViewAutoresizingNone;
        _pageScrollView.scrollsToTop = NO;
        _pageScrollView.bounces = NO;
        _pageScrollView.delegate = self;
        _pageScrollView.showsHorizontalScrollIndicator = NO;
        _pageScrollView.showsVerticalScrollIndicator = YES;
        _pageScrollView.pagingEnabled = YES;
        _pageScrollView.autoresizesSubviews = NO;
    }
    
    return _pageScrollView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    [self.toolbar selectIndex:index];
}

- (TalkListToolBar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [TalkListToolBar xibView];
        _toolbar.autoresizingMask = UIViewAutoresizingNone;
        [_toolbar.talkButton setSelected:YES];
        _toolbar.frame = CGRectMake(0, 0, APPScreenWidth, 40);
        __weakSelf;
        [_toolbar setFunctionButtonBlock:^(NSInteger index) {
            if (index == 0 || index == 1) {
                //  聊天室     //  成员列表
                [weakSelf changeViewContollerAtIndex:index];
            
            }else {
                //  退出
                
            }
            
        }];
    }

    return _toolbar;
}

- (void)changeViewContollerAtIndex:(NSInteger)index
{
    [self.pageScrollView setContentOffset:CGPointMake(APPScreenWidth * index, 0) animated:YES];
}


- (NSString *)title
{
    return @"聊天室";
}

@end
