//
//  HTBaseCell.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"
#import "UIImage+Stretch.h"

@interface HTBaseCell ()

@property (nonatomic, strong)   UIView *highLightView;

@end

@implementation HTBaseCell

+ (BOOL)isNib
{
    return YES;
}

+ (UITableViewCellStyle)tableViewCellStyle
{
    return UITableViewCellStyleDefault;
}

+ (CGFloat)fixedHeight
{
    return 44.0f;
}

+ (HTBaseCell *)newCell
{
    BOOL isNib = [self isNib];

    NSString *cellName = NSStringFromClass([self class]);
    
    if (isNib) {
        return [[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil] lastObject];
    }
    
    return [[[self class] alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:cellName];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initCell];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    
    return self;
}

- (void)initCell
{
    self.textLabel.textColor = [UIColor jt_globleTextColor];
    self.textLabel.font = HTFont(15.0f);
    
    self.detailTextLabel.textColor = [UIColor jd_settingDetailColor];
    self.detailTextLabel.font = HTFont(15.0f);
    
    //  self.selectedBackgroundView = self.highLightView;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    
//    if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
//        self.accessoryView = [[UIImageView alloc] initWithImage:HTImage(@"cell_leftArrwo")];
//    }
    
}

- (void)configWithSource:(id)source
{
    
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    _selectedBackgroundColor = selectedBackgroundColor;
    self.highLightView.backgroundColor = selectedBackgroundColor;
}

- (UIView *)highLightView
{
    if (!_highLightView) {
        _highLightView = [[UIView alloc] initWithFrame:self.bounds];
        UIColor *color = self.selectedBackgroundColor ? _selectedBackgroundColor : [UIColor jt_backgroudColor];
        _highLightView.backgroundColor = color;
    }
    
    return _highLightView;
}

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}


@end
