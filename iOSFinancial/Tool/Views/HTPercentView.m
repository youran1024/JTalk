//
//  HTPercentView.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/2.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTPercentView.h"

#define __PreProgressValue  .01f
#define __IndicateViewSize  5.0f

@interface HTPercentView ()

@property (nonatomic, strong)   CAShapeLayer *progressLayer;
@property (nonatomic, strong)   CAShapeLayer *backLayer;
@property (nonatomic, strong)   UILabel *textLabel;

@property (nonatomic, assign)   CGFloat lastPercent;
@property (nonatomic, assign)   BOOL isAnimating;

@end

@implementation HTPercentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _tintColor = [UIColor redColor];
        _percent = .0f;
        
        [self.layer addSublayer:self.backLayer];
        self.backLayer.path = [self drawPathWithArcCenter:1.0f];
        
        [self.layer addSublayer:self.progressLayer];
        
        [self addSubview:self.textLabel];
        
//        [self setpercent:0.0f animated:NO];
    }
    
    return self;
}

- (void)setTextLabelString:(CGFloat)percent
{
    NSString *percentStr = HTSTR(@"%.0f", percent * 100);
    NSString *percentFormat = HTSTR(@"%@%%", percentStr);

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:percentFormat];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:44.0f] range:NSMakeRange(0, percentStr.length)];
    //
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(percentStr.length, 1)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor jd_settingDetailColor] range:NSMakeRange(0, percentFormat.length)];
    
    _textLabel.attributedText = string;
}

- (void)setPercent:(CGFloat)percent
{
    [self setpercent:percent animated:NO];
}

- (void)setpercent:(CGFloat)percent animated:(BOOL)animate
{
    _percent = percent;
    
    if (percent < 0) {
        percent = .0f;
    }
    
    if (percent > 1) {
        percent = 1.0f;
    }
    
    self.progressLayer.path = [self drawPathWithArcCenter:_percent];
    
    if (animate && !_isAnimating) {
        _isAnimating = YES;
        [self removeAnimation];
        [self startAnimation];
    }
    
    [self setTextLabelString:percent];
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        _progressLayer.strokeColor = tintColor.CGColor;
    }
}

- (CGPathRef)drawPathWithArcCenter:(CGFloat)percent
{
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2;
    
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:(-M_PI/2)
                                        endAngle:(-M_PI / 2.0f) + percent * M_PI * 2
                                       clockwise:YES].CGPath;
}

- (void)startAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.25;
    pathAnimation.fromValue = @(_lastPercent / _percent);
    pathAnimation.toValue = @(1);
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.delegate = self;
    
    [self.progressLayer addAnimation:pathAnimation forKey:@"strokeAnimation"];
}

- (void)removeAnimation
{
    [self.progressLayer removeAnimationForKey:@"strokeAnimation"];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    _isAnimating = YES;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _isAnimating = NO;
    _lastPercent = _percent;
//    self.progressLayer.path = [self drawPathWithArcCenter:_percent];
}

- (CAShapeLayer *)backLayer
{
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.fillColor = [UIColor clearColor].CGColor;
        _backLayer.strokeColor = [UIColor colorWithRed:246/255.0f green:180/255.0f blue:153/255.0f alpha:0.4f].CGColor;
        _backLayer.lineWidth = 3.0f;
    }
    
    return _backLayer;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = _tintColor.CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineJoin = kCALineJoinRound;
        _progressLayer.lineWidth = 3.0f;
    }
    
    return _progressLayer;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _textLabel;
}

@end
