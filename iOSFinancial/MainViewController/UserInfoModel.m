//
//  UserInfoModel.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

static NSString *userInfoId = @"userInfoId";
static NSString *userInfoToken = @"userInfoToken";
static NSString *userInfoName = @"userInfoName";
static NSString *userInfoPhoto = @"userInfoPhoto";
static NSString *userInfoSex = @"userInfoSex";
static NSString *userInfoPhone = @"userInfoPhone";
static NSString *userInfoLocation = @"userInfoLocation";
static NSString *userInfoPrompt = @"userInfoPrompt";

#import "UserInfoModel.h"

@implementation UserInfoModel

- (id)copyWithZone:(NSZone *)zone
{
    UserInfoModel *model = [[UserInfoModel allocWithZone:zone] init];
    model.userName = self.userName;
    model.userSex = self.userSex;
    model.userLocation = self.userLocation;
    model.userLoginType = self.userLoginType;
    model.userID = self.userID;
    model.userToken = self.userToken;
    model.userPhoto = self.userPhoto;
    model.userPhotoImage = self.userPhotoImage;
    model.userPhone = self.userPhone;
    model.userPrompt = self.userPrompt;
    
    return model;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        if (self.userID.length == 0) {
            //  未登录，默认值
            self.userLoginType = UserLoginTypePhone;
            self.userSex = @"男";
            self.userPhoto = @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=d406487d0108283868588f54dea49d33/fd039245d688d43f74ed72907b1ed21b0ef43b08.jpg";
        }
    }

    return self;
}

- (void)parseWithDictionary:(NSDictionary *)dic withSynce:(BOOL)sync
{
    self.userID = [dic stringForKey:@"user_id"];
    self.userToken = [dic stringForKey:@"token"];
    self.userName = [dic stringForKey:@"name"];
    NSInteger sex = [[dic stringForKey:@"sex"] integerValue];
    self.userSex = sex == 1 ? @"男" : @"女";
    self.userPhone = [dic stringForKey:@"phone"];
    self.userLocation = [dic stringForKey:@"region"];
    self.userPrompt = [dic stringForKey:@"signature"];
    self.userPhoto = [dic stringForKey:@"photo"];
    
    if (sync) {
        [self synchronize];
    }
}

- (void)parseWithDictionary:(NSDictionary *)dic
{
    [self parseWithDictionary:dic withSynce:YES];
}

- (void)parseWithDictionaryWithOutSync:(NSDictionary *)dic
{
    [self parseWithDictionary:dic withSynce:NO];
}

- (void)readSynchronizeData
{
    self.userID = [HTUserDefaults valueForKey:userInfoId];
    self.userToken = [HTUserDefaults valueForKey:userInfoToken];
    self.userName = [HTUserDefaults valueForKey:userInfoName];
    self.userPhoto = [HTUserDefaults valueForKey:userInfoPhoto];
    self.userSex = [HTUserDefaults valueForKey:userInfoSex];
    self.userPhone = [HTUserDefaults valueForKey:userInfoPhone];
    self.userLocation = [HTUserDefaults valueForKey:userInfoLocation];
    self.userPrompt = [HTUserDefaults valueForKey:userInfoPrompt];
}

- (void)synchronize
{
    [HTUserDefaults setValue:self.userID forKey:userInfoId];
    [HTUserDefaults setValue:self.userToken forKey:userInfoToken];
    [HTUserDefaults setValue:self.userName forKey:userInfoName];
    [HTUserDefaults setValue:self.userPhoto forKey:userInfoPhoto];
    [HTUserDefaults setValue:self.userSex forKey:userInfoSex];
    [HTUserDefaults setValue:self.userPhone forKey:userInfoPhone];
    [HTUserDefaults setValue:self.userLocation forKey:userInfoLocation];
    [HTUserDefaults setValue:self.userPrompt forKey:userInfoPrompt];
    
    [HTUserDefaults synchronize];
}

- (void)exchangeUserInfoWithTmp:(UserInfoModel *)infoModel
{
    self.userPhoto = infoModel.userPhoto;
    self.userPhotoImage = infoModel.userPhotoImage;
    self.userName = infoModel.userName;
    self.userSex = infoModel.userSex;
    self.userLocation = infoModel.userLocation;
    self.userPrompt = infoModel.userPrompt;
    
    [self synchronize];
}

- (void)clearUserInfoData
{
    self.userID = @"";
    self.userToken = @"";
    self.userName = @"";
    self.userPhoto = @"";
    self.userPhone = @"";
    self.userSex = @"";
    self.userLocation = @"";
    
    [self synchronize];
}

@end
