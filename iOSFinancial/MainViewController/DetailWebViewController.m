//
//  DetailWebViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/4.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "DetailWebViewController.h"
#import "TalkViewController.h"


@interface DetailWebViewController ()

@property (nonatomic, strong)   UIButton *talkButton;

@end

@implementation DetailWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
    self.webView.height -= 44.0f;
    
    [self.view addSubview:self.talkButton];
}

- (UIButton *)talkButton
{
    if (!_talkButton) {
        _talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _talkButton.autoresizingMask = UIViewAutoresizingNone;
        _talkButton.frame = CGRectMake(0, self.webView.bottom, APPScreenWidth, 44);
        [_talkButton setTitle:@"聊聊去" forState:UIControlStateNormal];
        [_talkButton setTitleColor:[UIColor jt_barTintColor] forState:UIControlStateNormal];
        [_talkButton setTintColor:HTHexColor(0xfaf8f8)];
        [_talkButton addTarget:self action:@selector(talkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _talkButton.width, 1)];
        line.backgroundColor = HTHexColor(0xcecccc);
        [_talkButton addSubview:line];
    }
    
    return _talkButton;
}

- (void)talkButtonClicked
{
    [self createGroupWithTitle:self.talkTopic];
}

//  MARK:创建并加入聊天室
- (void)createGroupWithTitle:(NSString *)title
{
    [self showHudWaitingView:PromptTypeWating];
    HTBaseRequest *request = [HTBaseRequest createGroupWithGroupName:title];
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        NSInteger code = [[dict stringIntForKey:@"code"] integerValue];
        
        if (code == 200) {
            [weakSelf joinGroupByGroupId:[title toMD5] andGroupName:title];
        }
        
    }];
}

//  加入群组
- (void)joinGroupByGroupId:(NSString *)groupId andGroupName:(NSString *)groupName
{
    __weakSelf;
    [[RCIMClient sharedRCIMClient] joinGroup:groupId groupName:groupName success:^{
        [weakSelf removeHudInManaual];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf showTalkListViewController:groupName];
        });
        
        /*
         //  同步群组数据
         RCGroup *group = [[RCGroup alloc] initWithGroupId:[groupName toMD5] groupName:groupName portraitUri:nil];
         [[RCIMClient sharedRCIMClient] syncGroups:@[group] success:^{
         // success
         
         } error:^(RCErrorCode status) {
         
         }];
         
         */
        
    } error:^(RCErrorCode status) {
        [weakSelf showHudErrorView:@"加入失败，请重试!"];
    }];
}

//  MARK:聊天室Controller
- (void)showTalkListViewController:(NSString *)title
{
    TalkViewController *conversationVC = [[TalkViewController alloc] init];
    conversationVC.conversationType = ConversationType_GROUP; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = [title toMD5]; // 接收者的 targetId，这里为举例。
    conversationVC.userName = title;
    conversationVC.title = title; // 会话的 title。
    conversationVC.groupTitle = title;
    
    conversationVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)viewWillLayoutSubviews
{
    self.talkButton.frame = CGRectMake(0, self.webView.bottom, APPScreenWidth, 44);
}

@end
