//
//  PersonalInfoView.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "PersonalInfoView.h"

@implementation PersonalInfoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = _imageView.width / 2.0f;
    
    self.backgroundColor = [UIColor clearColor];

    _nameLabel.textColor = [UIColor whiteColor];
    _promptLabel.textColor = [UIColor whiteColor];
    _locationLabel.textColor = [UIColor whiteColor];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_nameLabel sizeToFit];
    [_promptLabel sizeToFit];
    [_locationLabel sizeToFit];
 
//    _promptLabel.centerX = self.centerX;
}

@end
