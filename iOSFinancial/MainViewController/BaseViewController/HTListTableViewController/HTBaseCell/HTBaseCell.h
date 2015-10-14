//
//  HTBaseCell.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTActions.h"
#import "UIColor+Colors.h"

@interface HTBaseCell : UITableViewCell

@property (nonatomic, strong)   HTActions *actions;
@property (nonatomic, strong)   UIColor *selectedBackgroundColor;

+ (BOOL)isNib;

+ (UITableViewCellStyle)tableViewCellStyle;

+ (CGFloat)fixedHeight;

+ (HTBaseCell *)newCell;

+ (NSString *)identifier;

- (void)configWithSource:(id)source;

@end
