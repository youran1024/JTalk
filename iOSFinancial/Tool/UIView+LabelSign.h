//
//  UILabel+LabelSign.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/20.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LabelSign)

- (void)showRedLabelSign;
- (void)showHotLabelSign;

- (void)showLabelWithTitle:(NSString *)title;

- (void)removeLabelSign;

@end
