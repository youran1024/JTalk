//
//  UILabel+LabelSign.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/20.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "UIView+LabelSign.h"

static NSInteger labelSignTag =77777;


@implementation UIView (LabelSign)

- (void)showRedLabelSign
{
    [self labelWithHot:NO];
}

- (void)showHotLabelSign
{
    [self labelWithHot:YES];
}

- (void)removeLabelSign
{
    UILabel *signLagel = (UILabel *)[self viewWithTag:labelSignTag];
    if (signLagel) {
        [signLagel removeFromSuperview];
    }
}

- (void)labelWithHot:(BOOL)hot
{
    NSString *text = hot ? @"热" : @"新";
    [self showLabelWithTitle:text];
}

- (void)showLabelWithTitle:(NSString *)title
{
    UILabel *signLagel = (UILabel *)[self viewWithTag:labelSignTag];
    if (!signLagel) {
        signLagel = [self signLabel];
    }

    [self adjustSignLabel:signLagel];
    
    [self addSubview:signLagel];
}

- (void)adjustSignLabel:(UILabel *)label
{
    [label sizeToFit];
    label.bottom = self.top + 8;
    label.left = self.right;
}

- (UILabel *)signLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.textColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.tag = labelSignTag;
    
    return label;
}

@end
