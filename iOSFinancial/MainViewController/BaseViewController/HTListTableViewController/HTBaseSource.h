//
//  HTBaseSource.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/31.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTBaseCell.h"

@interface HTBaseSource : NSObject

@property (nonatomic, assign)   CGFloat height;
@property (nonatomic, assign)   UITableViewCellSelectionStyle cellSelectionStyle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;

+ (Class)cellClass;

@end
