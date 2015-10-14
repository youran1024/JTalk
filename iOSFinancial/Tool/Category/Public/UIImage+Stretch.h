//
//  UIImage+Stretch.h
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-24.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HTStretchImage(image, left, topv)  [[UIImage imageNamed:image] imageStretch:left top:topv]

@interface UIImage (Stretch)

- (UIImage *)autoStretchImage;

- (UIImage *)imageStretch:(NSInteger)left top:(NSInteger)topv;

@end
