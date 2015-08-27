//
//  SetNewPassViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/7.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SetNewPassViewController.h"
#import "UIBarButtonExtern.h"
#import "EditInfoViewController.h"
#import "HTBaseRequest+Requests.h"


@interface SetNewPassViewController ()

@property (nonatomic, strong)   UITextField *textField;
@property (nonatomic, assign)   SetPassType setPassType;

@end

@implementation SetNewPassViewController

- (instancetype)initWithSetPassType:(SetPassType)setPassType
{
    self = [super init];
    
    if (self) {
        _setPassType = setPassType;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    if (_setPassType == SetPassTypeNew) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"下一步" target:self andSelector:@selector(finishButtonClicked)];
    }else {
        self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"重置" target:self andSelector:@selector(resetButtonClicked)];
    }

}

//  MARK:下一步
- (void)finishButtonClicked
{
    //  密码必须大于
    NSString *pass = self.textField.text;
    pass = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (pass.length < 6) {
        [self showHudErrorView:@"密码至少6位"];
    }else {
        UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
        userInfo.userPass = [pass toMD5];
        
        //  MARK:完善用户资料
        EditInfoViewController *editor = [[EditInfoViewController alloc] init];
        editor.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editor animated:YES];
    }
}

//  MARK:重置密码
- (void)resetButtonClicked
{
    //  密码必须大于
    NSString *pass = self.textField.text;
    pass = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (pass.length < 6) {
        [self showHudErrorView:@"密码至少6位"];
    }else {
        UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
        userInfo.userPass = [pass toMD5];
        
        HTBaseRequest *request = [HTBaseRequest resetUserPass];
        [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            NSInteger code = [[request.responseJSONObject stringIntForKey:@"code"] integerValue];
            if (code == 200) {
                [self showHudSuccessView:@"修改成功"];
                [self performSelector:@selector(rebackToLoginViewController) withObject:nil afterDelay:1.0f];
            }
            
        }];
    }
    
}

- (void)rebackToLoginViewController
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *loginViewController;
    if (viewControllers.count > 1) {
        loginViewController = [viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:loginViewController animated:YES];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)initView
{
    UIView *backView         = [[UIView alloc] initWithFrame:CGRectMake(0, TransparentTopHeight, self.view.width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"设置密码";
    label.textColor = [UIColor jt_globleTextColor];
    [label sizeToFit];
    
    [backView addSubview:label];
    label.left = 18.0f;
    label.centerY = backView.centerY;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, backView.height)];
    [backView addSubview:lineView];
    lineView.backgroundColor = [UIColor jt_lineColor];
    lineView.left = label.right + 10;
    
    [backView addSubview:self.textField];
    self.textField.left = lineView.right + 10;
    self.textField.centerY = backView.centerY;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
        _textField.font = HTFont(15.0f);
        _textField.secureTextEntry =  YES;
        _textField.textColor = [UIColor jt_lightBlackTextColor];
        _textField.placeholder = @"密码不少于6位";
    }
    
    return _textField;
}

- (NSString *)title
{
    return @"请设置密码";
}

@end
