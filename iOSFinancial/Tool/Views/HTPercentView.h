//
//  HTPersentView.h
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/2.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTPercentView : UIView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) CGFloat percent;

- (void)setpercent:(CGFloat)percent animated:(BOOL)animate;

@end
