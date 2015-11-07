//
//  SignModel.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseModel.h"

/*
    单个标签的属性类
 */

typedef NS_ENUM(NSInteger, SignTagType) {
    SignTagTypeNormal,
    SignTagTypeNew,
    SignTagTypeHot
};

@interface SignModel : HTBaseModel <NSCoding>

@property (nonatomic, assign) SignTagType signTagType;
@property (nonatomic, copy) NSString *signId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *signTag;

@end

