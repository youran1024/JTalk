//
//  UIImage+Stretch.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)

- (UIImage *)autoStretchImage
{
    CGSize size = self.size;
    return [self stretchableImageWithLeftCapWidth:size.width / 2.0f topCapHeight:size.height / 2.0f];
}

- (UIImage *)imageStretch:(NSInteger)left top:(NSInteger)top
{
    return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

@end
