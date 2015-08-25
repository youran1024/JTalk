//
//  BaseXibView.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-8.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@implementation HTBaseView

+ (id)xibView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
}

+ (CGFloat)height
{
    return .0f;
}

@end
