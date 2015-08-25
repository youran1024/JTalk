//
//  UserInfoModel.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseModel.h"

typedef NS_ENUM(NSInteger, UserLoginType) {
    UserLoginTypeWeChat = 0,
    UserLoginTypeWeibo = 1,
    UserLoginTypePhone = 2
};

@interface UserInfoModel : HTBaseModel <NSCopying>

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, copy)     NSString *userToken;
@property (nonatomic, copy)     NSString *userName;
//  不做保存
@property (nonatomic, copy)     NSString *userPass;
@property (nonatomic, strong)   UIImage *userPhotoImage;
@property (nonatomic, copy)     NSString *userPhoto;
@property (nonatomic, copy)     NSString *userPhone;
@property (nonatomic, copy)     NSString *userSex;
@property (nonatomic, copy)     NSString *userLocation;
@property (nonatomic, assign)   UserLoginType userLoginType;

//  用户说明
@property (nonatomic, copy)     NSString *userPrompt;
//  浏览过的标签
@property (nonatomic, strong)   NSArray *signHistoryArray;


- (void)exchangeUserInfoWithTmp:(UserInfoModel *)infoModel;

//  会影响用户缓存
- (void)clearUserInfoData;



@end
