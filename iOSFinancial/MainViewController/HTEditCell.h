//
//  HTEditCell.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"

@interface HTEditCell : HTBaseCell

@property (nonatomic, strong) IBOutlet  UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet  UITextField *textField;

@end
