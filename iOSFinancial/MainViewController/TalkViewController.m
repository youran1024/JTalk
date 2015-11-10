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
#import "LongTapUserView.h"
#import "UIView+Prompting.h"
#import "HTTransparentView.h"
#import "HTWebViewController.h"
#import "FunctionButton.h"
#import "NSString+URLEncoding.h"
#import "UMSocial.h"


@interface TalkViewController () <UIActionSheetDelegate, UMSocialUIDelegate>

@property (nonatomic, strong)   LongTapUserView *tapUserView;
//  半透明的黑色背景遮盖图
@property (nonatomic, strong)   HTTransparentView *transparentView;

//  功能列表
@property (nonatomic, strong)   UIView *functionView;
//  消息提醒开关
@property (nonatomic, strong)   FunctionButton *mindButton;
//  消息提醒状态
@property (nonatomic, assign)   BOOL isMindOpen;

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
    
    /*method 2*/
    /*
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
    self.automaticallyAdjustsScrollViewInsets = NO;
     
    self.conversationMessageCollectionView.height -= 20.0f;
    self.conversationMessageCollectionView.top = 44.0f;
    */
    
    /*method 1*/

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.conversationMessageCollectionView.height = self.view.height - 44.0f;
    self.conversationMessageCollectionView.top = 64.0f;
    
    self.enableNewComingMessageIcon = YES;
    self.enableUnreadMessageIcon = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
    
    if (self.conversationType == ConversationType_GROUP) {
        UIBarButtonItem *item1 = [UIBarButtonExtern buttonWithImage:@"talkPeopleList" target:self andSelector:@selector(showGroupJoinerListView)];
        UIBarButtonItem *item2 = [UIBarButtonExtern buttonWithImage:@"talkSetting" target:self andSelector:@selector(funtionBarButtonClicked)];//showTalkSettingViewController
                                  
        self.navigationItem.rightBarButtonItems = @[item2, item1];
        
        //  没有语音
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
        
    }else {
        //  有语音
        UIBarButtonItem *item2 = [UIBarButtonExtern buttonWithImage:@"Info_personal" target:self andSelector:@selector(showPersonalInfoViewController)];
        self.navigationItem.rightBarButtonItem = item2;
        
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    
    //  圆角头像
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    //  显示用户名
    [self setDisplayUserNameInCell:YES];
    
    [self readMessageMindOpenState];
    
    __weakSelf;
    [self.transparentView setTouchBlock:^{
        [weakSelf removeFunctionView];
    }];
    
}

- (void)notifyUpdateUnreadMessageCount
{
    
}

- (void)showPersonalInfoViewController
{
    PersonalViewController *personal = [[PersonalViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    personal.userId = self.targetId;
    
    [self.navigationController pushViewController:personal animated:YES];
}

#pragma mark - ReadMessageSwitch

- (void)readMessageMindOpenState
{
    NSString *groupId = [_groupTitle toMD5];
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:groupId success:^(RCConversationNotificationStatus nStatus) {
        
        //  免打扰
        _isMindOpen = nStatus == NOTIFY;
        
        //  如果本地和服务端不匹配，则同步本地数据
        id localValue = [HTUserDefaults valueForKey:groupId];
        
        if (localValue) {
            BOOL isOnLocal = [localValue boolValue];
            if (_isMindOpen != isOnLocal) {
                self.isMindOpen = isOnLocal;
                [self messageMindStateChanged:groupId andIsBlock:!isOnLocal];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshMindButtonState];
        });
     
    } error:^(RCErrorCode status) {
        
    }];
}

- (void)messageMindStateChanged:(NSString *)groupId andIsBlock:(BOOL)isBlock
{
    __weakSelf;
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:groupId isBlocked:isBlock success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"valueChanged:%ld", (long)nStatus);
        [HTUserDefaults setValue:@(!isBlock) forKey:groupId];
        [HTUserDefaults synchronize];
        
    } error:^(RCErrorCode status) {
        weakSelf.isMindOpen = !weakSelf.isMindOpen;
        [weakSelf refreshMindButtonState];
    }];
}

- (void)refreshMindButtonState
{
    NSString *imageName = self.isMindOpen ? @"talk_mind_open" : @"talk_mind_close";
    
    NSString *title = self.isMindOpen ? @"提醒开启" : @"提醒关闭";
    
    self.mindButton.imageView.image = HTImage(imageName);
    self.mindButton.titleLabel.text = title;
}

#pragma mark -

- (void)funtionBarButtonClicked
{
    if (!self.functionView.userInteractionEnabled) {
        return;
    }
    
    UIView *superView = self.functionView.superview;
    if (superView) {
        [self removeFunctionView];
        
    }else {
        [self showFunctionView];
    }
}

- (void)showAlphaView
{
    self.transparentView.frame = self.view.bounds;
    [self.view addSubview:self.transparentView];
}

- (void)removeAlphaView
{
    [self.transparentView removeFromSuperview];
}

- (void)showFunctionView
{
    [self showAlphaView];
    
    self.functionView.bottom = self.view.top + 64;
    [self.view addSubview:self.functionView];
    [self refreshMindButtonState];
    
    [UIView animateWithDuration:.65 delay:.0 usingSpringWithDamping:.7 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.functionView.userInteractionEnabled = NO;
        self.functionView.top = self.view.top + 60;
        
    } completion:^(BOOL finished) {
        self.functionView.top = self.view.top + 60;
        self.functionView.userInteractionEnabled = YES;
    }];
}

- (void)removeFunctionView
{
    [self removeAlphaView];
    [UIView animateWithDuration:.65 delay:.0 usingSpringWithDamping:.7 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.functionView.userInteractionEnabled = NO;
        self.functionView.bottom = self.view.top + 64;
        
    } completion:^(BOOL finished) {
        
        self.functionView.userInteractionEnabled = YES;
        [self.functionView removeFromSuperview];
        
    }];
}

- (void)showTalkSettingViewController
{
    TalkSettingViewController *setting = [[TalkSettingViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    setting.groupId = [self.groupTitle toMD5];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)showGroupJoinerListView
{
    // back bar button 占空间太大~
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    CommitListViewController *commit = [[CommitListViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    commit.title = self.groupTitle;
    commit.groupTitle = self.groupTitle;
    [self.navigationController pushViewController:commit animated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    PersonalViewController *personal = [[PersonalViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    personal.userId = userId;
    
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)didLongPressCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:__userInfoId]) {
        return;
    }
    
    HTBaseRequest *request = [HTBaseRequest getUserInfo:userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            dic = [dic dictionaryForKey:@"result"];
            
            [self refreshUserTapView:dic];
            [self showTransParentView];
            [self showTapUserView];
        }
    }];
    
}

- (void)showTransParentView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.transparentView];
}

- (HTTransparentView *)transparentView
{
    if (!_transparentView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _transparentView = [[HTTransparentView alloc] initWithFrame:keyWindow.bounds];
        
        __weakSelf;
        [_transparentView setTouchBlock:^{
            //  取消编辑
            [weakSelf dismissTapView];
        }];
    }
    
    return _transparentView;
}

- (void)refreshUserTapView:(NSDictionary *)dic
{
    NSString *userName = [dic stringForKey:@"name"];
    NSString *userPhoto = [dic stringForKey:@"photo"];
    NSString *userSex = [[dic stringForKey:@"sex"] integerValue] == 1 ? @"男" : @"女";
    NSString *userLocation = [dic stringForKey:@"region"];
    
    self.tapUserView.userId = [dic stringForKey:@"user_id"];
    self.tapUserView.nameLabel.text = userName;
    self.tapUserView.promptLabel.text = HTSTR(@"%@,%@", userSex, userLocation);
    [self.tapUserView.headImageView sd_setImageWithURL:HTURL(userPhoto)];
}

- (void)showTapUserView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.tapUserView];
    self.tapUserView.top = self.view.bottom;
    [UIView animateWithDuration:.75f delay:0 usingSpringWithDamping:.7 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tapUserView.bottom = self.view.bottom;
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark view

- (LongTapUserView *)tapUserView
{
    if (!_tapUserView) {
        __weakSelf;
        _tapUserView = [LongTapUserView xibView];
        _tapUserView.width = APPScreenWidth;
        [_tapUserView setButtonClickBlock:^(UIButton *button, NSInteger index) {

            //  0 拉黑
            if (index == 1) {
                [weakSelf showPullBackList];
                
            }else if (index == 2) {
                NSString *string = weakSelf.chatSessionInputBarControl.inputTextView.text;
                weakSelf.chatSessionInputBarControl.inputTextView.text = HTSTR(@"%@@%@", string, weakSelf.tapUserView.nameLabel.text);
                [weakSelf.chatSessionInputBarControl.inputTextView becomeFirstResponder];
            }
            
            [weakSelf dismissTapView];
            
        }];
        
    }
    
    return _tapUserView;
}


#define pullBackListTag     10001
#define pullBackResionTag   10002

- (void)showPullBackList
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"屏蔽并举报", @"屏蔽", nil];
    choiceSheet.tag = pullBackListTag;
    
    [choiceSheet showInView:self.view];

}

- (void)dismissTapView
{
    [self.transparentView removeFromSuperview];
    
    __weakSelf;
    [UIView animateWithDuration:.75f delay:0 usingSpringWithDamping:.7 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.tapUserView.top = weakSelf.view.bottom;
        
    } completion:^(BOOL finished) {
        [weakSelf.tapUserView removeFromSuperview];
    }];

}

#pragma mark - 
#pragma mark Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == pullBackListTag) {
        if (buttonIndex == 0) {
            //  屏蔽并举报
            UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles: @"淫秽色情", @"垃圾广告", @"骚扰", @"诈骗", nil];
            choiceSheet.tag = pullBackResionTag;
            
            [choiceSheet showInView:self.view];
            
        }else if (buttonIndex == 1){
            //
            [self pullToBlackList];
        }
        
    }else {
        if (buttonIndex != 4) {
            
            [self pullToBlackList];
            //  举报
            [self reportUserReqeust:buttonIndex];
        }
    }
}

- (void)pullToBlackList
{
    //  屏蔽
    [self sendPullBlackRequestWithPrompt:NO];
    
    //  拉黑
    [[RCIMClient sharedRCIMClient] addToBlacklist:self.tapUserView.userId success:^{
        
    } error:^(RCErrorCode status) {
        
    }];

}

- (void)reportUserReqeust:(NSInteger)type
{
    NSString *userId = self.tapUserView.userId;
    
    [self.view showHudWaitingView:PromptTypeWating];
    
    //  举报群组里边的用户
    HTBaseRequest *request = [HTBaseRequest reportUserInGroup:[self.groupTitle toMD5] andReporterId:userId andReportType:type];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            [self.view showHudSuccessView:@"举报成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        [self.view showHudErrorView:@"举报失败"];
        
    }];
}

- (void)sendPullBlackRequestWithPrompt:(BOOL)prompt
{
    NSString *userId = self.tapUserView.userId;
    
    if (prompt) {
        [self.view showHudWaitingView:PromptTypeWating];
    }
    
    HTBaseRequest *request = [HTBaseRequest pullUserToBlackList:userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200 && prompt) {
            [self.view showHudSuccessView:@"屏蔽成功"];
        }
        
    } failure:^(YTKBaseRequest *request) {
        
        if (prompt) {
            [self.view showHudErrorView:@"屏蔽失败"];
        }
        
    }];
}

#pragma mark - Views

- (UIView *)functionView
{
    if (!_functionView) {
        _functionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 84)];
        _functionView.backgroundColor = HTHexColor(0x4bb174);
        
        CGFloat width = APPScreenWidth / 4.0f;
        
        FunctionButton *searchButton = [self functionButton:@"搜索" andImage:@"talk_search"];
        searchButton.width = width;
        searchButton.left = 0;
        [_functionView addSubview:searchButton];
        
        self.mindButton.left = searchButton.right;
        self.mindButton.width = width;
        [_functionView addSubview:self.mindButton];
        
        FunctionButton *shareButton = [self functionButton:@"分享" andImage:@"share"];
        shareButton.width = width;
        shareButton.left = self.mindButton.right;
        [_functionView addSubview:shareButton];
        
        FunctionButton *quiteButton = [self functionButton:@"退出" andImage:@"talk_quite"];
        quiteButton.width = width;
        quiteButton.left = shareButton.right;
        [_functionView addSubview:quiteButton];
        
        __weakSelf;
        //  单击了搜索
        [searchButton setTouchBlock:^(FunctionButton *button) {
            HTWebViewController *controller = [[HTWebViewController alloc] init];
            controller.titleStr = _groupTitle;
            controller.url = HTURL(HTSTR(@"http://www.baidu.com/s?wd=%@", [_groupTitle URLEncodedString]));
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        
        [self.mindButton setTouchBlock:^(FunctionButton *button) {
            weakSelf.isMindOpen = !weakSelf.isMindOpen;
            
            [weakSelf messageMindStateChanged:[weakSelf.groupTitle toMD5] andIsBlock:!weakSelf.isMindOpen];
            [weakSelf refreshMindButtonState];
        }];
        
        [shareButton setTouchBlock:^(FunctionButton *button) {
            [weakSelf inviteFriends];
        }];
        
        [quiteButton setTouchBlock:^(FunctionButton *button) {
            [weakSelf quiteGroup];
        }];
    }
    
    return _functionView;
}

- (FunctionButton *)mindButton
{
    if (!_mindButton) {
        _mindButton = [self functionButton:@"提醒关闭" andImage:@"talk_mind_close"];
    }
    
    return _mindButton;
}

- (FunctionButton *)functionButton:(NSString *)title andImage:(NSString *)imageName
{
    FunctionButton *button = [FunctionButton xibView];
    button.imageView.image = HTImage(imageName);
    button.titleLabel.text = title;
    
    return button;
}

- (void)quiteGroup
{
    [self.view showHudWaitingView:PromptTypeWating];
    
    [[RCIMClient sharedRCIMClient] quitGroup:[_groupTitle toMD5] success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view showHudSuccessView:@"退出成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view showHudErrorView:@"退出失败"];
        });
    }];
}


#pragma mark - 
#pragma mark Share Method
- (void)inviteFriends
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMengAppKey
                                      shareText:@"Hello,I am JTalk, http://xxxxTalk.com  -- test ^^"
                                     shareImage:[UIImage imageNamed:@"personal1"]
                                shareToSnsNames:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina]
                                       delegate:self];
}

//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


@end
