//
//  HTActions.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/1.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HTActionBlock)(id object, id target, NSIndexPath *indexPath);

@interface HTActions : NSObject

//  一般头像
@property (nonatomic, copy) HTActionBlock headerAction;
//  一般都是didSelect操作
@property (nonatomic, copy) HTActionBlock detailAction;
//  一般都是尾部的一些按钮操作
@property (nonatomic, copy) HTActionBlock tailAction;

@property (nonatomic, copy) HTActionBlock otherAction;


@end
