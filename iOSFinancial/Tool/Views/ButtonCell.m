//
//  ButtonCell.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/23.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ButtonCell.h"

@interface ButtonCell ()

@property (nonatomic)   UILabel *submitLabel;

@end

@implementation ButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self.contentView addSubview:self.submitLabel];
        
    }

    return self;
}

- (UILabel *)submitLabel
{
    if (!_submitLabel) {
        _submitLabel = [[UILabel alloc] init];
        _submitLabel.textColor = [UIColor jd_settingDetailColor];
    }
    
    return _submitLabel;
}

- (void)setSubmitText:(NSString *)submitText
{
    if (![_submitText isEqualToString:submitText]) {
        _submitText = submitText;
        _submitLabel.text = _submitText;
        [_submitLabel sizeToFit];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.submitLabel.center = self.contentView.center;
}

@end
