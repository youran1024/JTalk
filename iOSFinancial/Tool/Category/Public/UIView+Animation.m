//
//  UIView+Animation.m
//  HTAlertView
//
//  Created by Mr.Yang on 13-12-6.
//  Copyright (c) 2013年 MoonLightCompany. All rights reserved.
//

#import "UIView+Animation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Animation)

- (void)updateAnchorPoint:(PopAnchor)position to:(UIView *)view
{
    CGRect frame = view.frame;
    CGPoint anchorPoint = CGPointZero;
    CGPoint location = CGPointZero;
    
    if (position & PopAnchorTop) {
        anchorPoint.y  = 0;
        location.y = CGRectGetMinY(frame) - CGRectGetHeight(frame) / 2.0f;
    }
    if (position & PopAnchorBottom){
        anchorPoint.y = 1;
        location.y =  CGRectGetMaxY(frame) - CGRectGetHeight(frame) / 2.0f;
    }
    if (position & PopAnchorLeft){
        anchorPoint.x = 0;
        location.x = CGRectGetMinX(frame) - CGRectGetWidth(frame) / 2.0f;
    }
    if (position & PopAnchorRight){
        anchorPoint.x = 1;
        location.x = CGRectGetMinX(frame) - CGRectGetWidth(frame) / 2.0f;
    }
    if (position & PopAnchorCenterX){
        anchorPoint.x = .5;
        location.x = CGRectGetMinX(frame);
    }
    if (position & PopAnchorCenterY){
        anchorPoint.y = .5;
        location.y = CGRectGetMinY(frame);
    }
    
    frame.origin = location;
    view.frame = frame;
    view.layer.anchorPoint = anchorPoint;
}

- (void)popupSubView:(UIView *)view atPosition:(PopAnchor)position
{
    [self updateAnchorPoint:position to:view];
    
    if (view.superview != self) {
        [self addSubview:view];
    }
    
    CATransform3D scale1 = CATransform3DMakeScale(.5, .5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.05, 1.05, 1);
    CATransform3D scale3 = CATransform3DMakeScale(.95, .95, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1, 1, 1);
    NSArray *keyValues = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:scale1],
                          [NSValue valueWithCATransform3D:scale2],
                          [NSValue valueWithCATransform3D:scale3],
                          [NSValue valueWithCATransform3D:scale4],
                          nil];
    
    NSArray *keyTimes = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:.0],
                         [NSNumber numberWithFloat:.4],
                         [NSNumber numberWithFloat:.7],
                         [NSNumber numberWithFloat:1],
                         nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [animation setValues:keyValues];
    [animation setKeyTimes:keyTimes];
    
    animation.removedOnCompletion = YES;
    animation.duration = .35;
    
    [view.layer addAnimation:animation forKey:@"viewPop"];
}


- (void)shrinkDispaerWithDelegate:(id)delegate
{
    NSValue *value = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
    NSValue *toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.0, .0, 1)];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = value;
    animation.toValue = toValue;
    animation.duration = .35;
    animation.delegate = delegate;
    
    [self.layer addAnimation:animation forKey:@"shrink"];
}

- (void)popOutWithDelegate:(id)delegate
{
    CATransform3D scale1 = CATransform3DMakeScale(.0, .0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.15, 1.15, 1);
    CATransform3D scale3 = CATransform3DMakeScale(.85, .85, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1, 1, 1);
    NSArray *keyValues = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:scale1],
                          [NSValue valueWithCATransform3D:scale2],
                          [NSValue valueWithCATransform3D:scale3],
                          [NSValue valueWithCATransform3D:scale4],
                          nil];
    
    NSArray *keyTimes = [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:.0],
                         [NSNumber numberWithFloat:.4],
                         [NSNumber numberWithFloat:.7],
                         [NSNumber numberWithFloat:1],
                         nil];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [animation setValues:keyValues];
    [animation setKeyTimes:keyTimes];
    
    animation.delegate = delegate;
    animation.removedOnCompletion = YES;
    animation.duration = .65;
    
    [self.layer addAnimation:animation forKey:@"viewPop"];
}

- (void)shrinkDispaerWithDelegate2:(void (^) (void))animationStop1
{
    NSValue *value = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
    NSValue *toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.0, .0, 1)];
    
    [UIView animateWithDuration:.1 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.layer.transform = [value CATransform3DValue];
        
    } completion:^(BOOL finished) {
        
       [UIView animateWithDuration:.25 animations:^{
           self.layer.transform = [toValue CATransform3DValue];
       } completion:^(BOOL finished) {
           animationStop1();
       }];
        
    }];
    
}

- (void)flashAnimation
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:0.4];
    
    animation.repeatCount= 1;
    animation.duration= 1.0f;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.autoreverses=YES;
    
    [self.layer addAnimation:animation forKey:@"flashAnimation"];
}

@end
