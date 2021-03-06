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
    UserLoginTypePhone = 2,
    UserLoginTypeQQ
};


@interface UserInfoModel : HTBaseModel <NSCopying>

@property (nonatomic, copy)     NSString *userID;

//  融云的Token
@property (nonatomic, copy)     NSString *userToken;

//  三方登陆的Token
@property (nonatomic, copy)     NSString *userAccessToken;
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


//  非登陆用户的数据结构用这个
- (void)parseWithDictionaryWithOutSync:(NSDictionary *)dic;

//  读取缓存
- (void)readSynchronizeData;

//  userModel和临时的userTmpModel 交换数据信息
- (void)exchangeUserInfoWithTmp:(UserInfoModel *)infoModel;

//  会影响用户缓存
- (void)clearUserInfoData;


- (void)synchronize;

@end
