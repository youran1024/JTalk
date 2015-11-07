//
//  SignListModel.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SignBase.h"

@interface SignListModel : SignBase <NSCoding>

typedef NS_ENUM(NSInteger, SignViewType) {
    //  标签列表
    SignViewTypeLabel,
    
    //  卧谈会
    SignViewTypeImage
};


@property (nonatomic, assign) SignViewType signViewType;

//  正在显示的标签数组
@property (nonatomic, strong, readonly) NSArray *showSignList;

//  正在显示的卧谈会
@property (nonatomic, strong)   NSDictionary *showSignDic;

//  个人页面的解析
- (void)parseWithPersonalArray:(NSArray *)array;

//  换一批
- (NSInteger)changeNextPage;

@end

