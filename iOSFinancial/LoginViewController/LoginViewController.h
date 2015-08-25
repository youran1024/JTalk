//
//  LoginViewController.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/7.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseViewController.h"

typedef NS_ENUM(NSInteger, LoginViewType) {
    LoginViewTypeLogin,
    LoginViewTypeRegedit,
    LoginViewTypeFindPass

};

@interface LoginViewController : HTBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil andViewType:(LoginViewType)loginViewType;

@end
