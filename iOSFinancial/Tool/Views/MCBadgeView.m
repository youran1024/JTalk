//
//  MCBadgeLayer.m
//  TextBubbleToturist2
//
//  Created by maomao on 12-12-5.
//  Copyright (c) 2012年 maomao. All rights reserved.
//

#import "MCBadgeView.h"
@interface MCBadgeView () {
    int fontSize;
    CGRect sizeRect;
}
@end
@implementation MCBadgeView
@synthesize badgeNum = _badgeNum;

- (id)initWithCenter:(CGPoint)center {
    self = [super initWithFrame:CGRectMake(center.x - 11, center.y - 11, 24, 24)];
    if (self) {
        _anchorPoint = center;
        fontSize = 16;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    return self;
}


- (void)setAnchorPoint:(CGPoint)anchorPoint {
    if (!CGPointEqualToPoint(_anchorPoint, anchorPoint)) {
        _anchorPoint = anchorPoint;
        [self setNeedsLayout];
    }
}

+ (id)newWithCenter:(CGPoint)center {
    return [[MCBadgeView alloc] initWithCenter:center] ;
}

- (void)setBadgeNum:(int)badgeNum {
    if (_badgeNum != badgeNum) {
        _badgeNum = badgeNum;
        if (badgeNum) {
            [self setHidden:NO];
            [self setNeedsLayout];
            [self setNeedsDisplay];
        } else {
            [self setHidden:YES];
        }
    }
}

- (void)layoutSubviews {
    NSString *str = [NSString stringWithFormat:@"%d",_badgeNum];
    /*
    CGSize size = [str sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]
                  constrainedToSize:CGSizeMake(40, 24)
                      lineBreakMode:NSLineBreakByTruncatingMiddle];
    */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(40, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float width = MAX(24,size.width + 10);
    
    CGRect frame = CGRectMake(self.anchorPoint.x - width + 12,self.anchorPoint.y - 12, width, 24);
    sizeRect = CGRectMake((frame.size.width - size.width) * .5f, (frame.size.height - size.height) * .5f, size.width, size.height);
    self.frame = frame;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12];
    CGContextAddPath(context, [path CGPath]);
    CGContextClip(context);
    CGContextFillRect(context, rect);
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 2, 2) cornerRadius:12];
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextAddPath(context, [path CGPath]);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy, NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[NSString stringWithFormat:@"%d",_badgeNum] drawInRect:sizeRect withAttributes:attributes];
    
    /*
    [[NSString stringWithFormat:@"%d",_badgeNum] drawInRect:sizeRect
                                                   withFont:[UIFont boldSystemFontOfSize:fontSize]
                                              lineBreakMode:NSLineBreakByTruncatingMiddle];
     */
    
    const CGFloat components[8] = {
        1,1,1,.7,
        1,1,1,0
    };
    const CGFloat locations[2] = {
        0,1
    };
    
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height / 2));
    CGContextClip(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height / 2 + 5), kCGGradientDrawsBeforeStartLocation);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}
@end
