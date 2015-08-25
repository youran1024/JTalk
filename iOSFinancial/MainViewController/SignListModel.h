//
//  SignListModel.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseModel.h"

@interface SignListModel : HTBaseModel <NSCoding>

@property (nonatomic, assign)   NSInteger signType;

@property (nonatomic, copy) NSString *title;

//  正在显示的标签数组
@property (nonatomic, strong, readonly) NSArray *showSignList;


//  换一批
- (NSInteger)changeNextPage;

@end

