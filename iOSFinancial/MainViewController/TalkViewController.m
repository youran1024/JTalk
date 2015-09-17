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


@interface TalkViewController () <UIActionSheetDelegate>

@property (nonatomic, strong)   LongTapUserView *tapUserView;

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
    
    if (self.conversationType == ConversationType_GROUP) {
        UIBarButtonItem *item1 = [UIBarButtonExtern buttonWithImage:@"talkPeopleList" target:self andSelector:@selector(showGroupJoinerListView)];
        UIBarButtonItem *item2 = [UIBarButtonExtern buttonWithImage:@"talkSetting" target:self andSelector:@selector(showTalkSettingViewController
                                                                                                                     )];
        self.navigationItem.rightBarButtonItems = @[item2, item1];
        
        //  没有语音
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
        
    }else {
        //  有语音
        [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    
    
    //  圆角头像
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    //  显示用户名
    [self setDisplayUserNameInCell:YES];
    
}

- (void)showTalkSettingViewController
{
    TalkSettingViewController *setting = [[TalkSettingViewController alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    setting.groupId = [self.groupTitle toMD5];
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

- (void)didLongPressCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:__userInfoId]) {
        return;
    }
    
    HTBaseRequest *request = [HTBaseRequest otherUserInfo:userId];
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSDictionary *dic = request.responseJSONObject;
        NSInteger code = [[dic stringIntForKey:@"code"] integerValue];
        if (code == 200) {
            dic = [dic dictionaryForKey:@"result"];
            
            [self refreshUserTapView:dic];
            [self showTapUserView];
        }
    }];
    
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
    [self.view addSubview:self.tapUserView];
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
    __weakSelf;
    [UIView animateWithDuration:.75f delay:0 usingSpringWithDamping:.7 initialSpringVelocity:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.tapUserView.top = weakSelf.view.bottom;
        
    } completion:^(BOOL finished) {
        
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
    
    HTBaseRequest *request = [HTBaseRequest reportUserInGroup:userId andReportType:type];
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
    
    HTBaseRequest *request = [HTBaseRequest pullBlackUser:userId];
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

@end
