
//
//  HTCircleView.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/5/2.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTCircleView.h"

#define __PreProgressValue  .01f
#define __IndicateViewSize  4.6f

typedef NS_ENUM(NSInteger, CircleViewStyle) {
    CircleViewStyleProgress,
    CircleViewStyleFinish,
    CircleViewStyleBegin
};

@interface HTCircleView ()

@property (nonatomic, strong)   CAShapeLayer *progressLayer;
@property (nonatomic, strong)   CAShapeLayer *backLayer;
@property (nonatomic, strong)   UIView *indicateView;
@property (nonatomic, strong)   NSTimer *timer;

@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, strong)   UILabel *percentLabel;
@property (nonatomic, strong)   UIImageView *line;

@end

@implementation HTCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _tintColor = [UIColor redColor];
        
        [self.layer addSublayer:self.backLayer];
        self.backLayer.path = [self drawPathWithArcCenter:1.0f];
        
        [self.layer addSublayer:self.progressLayer];
        [self addSubview:self.indicateView];
        
        [self setPersent:__PreProgressValue];
        
        //  添加标题
        CGPoint center = self.center;
        center.y -= self.titleLabel.height - 3;
        [self addSubview:self.titleLabel];
        self.titleLabel.center = center;
        
        //  添加线
        center = self.center;
        [self addSubview:self.line];
        self.line.center = center;
        
        center.y += self.percentLabel.height - 3;
        center.x += 3.0f;
        [self addSubview:self.percentLabel];
        self.percentLabel.center = center;
    }

    return self;
}

- (void)layoutSubviews
{
    
}

- (void)changeCircleViewStyle:(CircleViewStyle)style
{
    if (style == CircleViewStyleBegin ||
        style == CircleViewStyleProgress) {
    
        _titleLabel.textColor = [UIColor jt_globleTextColor];
        _titleLabel.text = @"立即投资";
        
        _percentLabel.textColor = [UIColor jd_settingDetailColor];
        
    }else {
        _titleLabel.text = @"已完成";
        
        _titleLabel.textColor = [UIColor jt_lineColor];
        _percentLabel.textColor = [UIColor jt_lineColor];
        
        _backLayer.strokeColor = [UIColor jt_backgroudColor].CGColor;
    }
    
    if (style == CircleViewStyleBegin ||
        style == CircleViewStyleFinish) {
        
        _indicateView.hidden = YES;
        _progressLayer.hidden = YES;
        
    }else {
        _indicateView.hidden = NO;
        _progressLayer.hidden = NO;
        
    }
}

- (void)setPersent:(CGFloat)persent
{
    _persent = persent;
    
    if (_persent == 1) {
        [self changeCircleViewStyle:CircleViewStyleFinish];
    }else if (_persent == 0) {
        [self changeCircleViewStyle:CircleViewStyleBegin];
    }else {
        [self changeCircleViewStyle:CircleViewStyleProgress];
    }
    
    if (persent < 0) {
        persent = .1f;
    }
    
    if (persent > 1) {
        persent = 1.0f;
    }
    
    self.progressLayer.path = [self drawPathWithArcCenter:_persent];
    _indicateView.transform = CGAffineTransformMakeRotation((M_PI/2) +  _persent * M_PI * 2);
    
    self.percentLabel.text = HTSTR(@"%.0f%%", persent * 100);
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        _progressLayer.strokeColor = tintColor.CGColor;
    }
}

- (CGPathRef)drawPathWithArcCenter:(CGFloat)persent
{
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2;
    
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:(-M_PI/2)
                                        endAngle:(-M_PI / 2.0f) + persent * M_PI * 2
                                       clockwise:YES].CGPath;
}

- (CAShapeLayer *)backLayer
{
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.fillColor = [UIColor clearColor].CGColor;
        _backLayer.strokeColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:0.4f].CGColor;
        _backLayer.lineWidth = __IndicateViewSize - 2;
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
        _progressLayer.lineWidth = __IndicateViewSize - 2;
    }

    return _progressLayer;
}

- (UIView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width / 2.0f + __IndicateViewSize / 2.0f, __IndicateViewSize)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __IndicateViewSize, __IndicateViewSize)];
        imageView.backgroundColor = [UIColor jd_settingDetailColor];
        imageView.layer.cornerRadius = CGRectGetWidth(imageView.frame) / 2.0f;
        
        
        [_indicateView addSubview:imageView];

        CGPoint anchorPoint = CGPointMake(1, .5);
        _indicateView.layer.anchorPoint = anchorPoint;
        
        CGPoint position = self.center;
        _indicateView.layer.position = position;
        _indicateView.transform = CGAffineTransformMakeRotation((M_PI/2) +  __PreProgressValue * M_PI * 2);
    }

    return _indicateView;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 14)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor jt_globleTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.text = @"立即投资";
    }

    return _titleLabel;
}

- (UIImageView *)line
{
    if (!_line) {
        _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width - 20, 1)];
        UIImage *image = HTImage(@"investLine");
        _line.image  = image;
    }
    
    return _line;
}

- (UILabel *)percentLabel
{
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 14)];
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.textColor = [UIColor jd_settingDetailColor];
        _percentLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _percentLabel;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self toucheUpEvent:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self toucheUpEvent:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backLayer.fillColor = [UIColor whiteColor].CGColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isTouchUpIn:touches] && _touchBlock) {
        _touchBlock (self);
    }
    
    self.backLayer.fillColor = [UIColor whiteColor].CGColor;
}

- (void)toucheUpEvent:(NSSet *)touches
{
    if ([self isTouchUpIn:touches]) {
        self.backLayer.fillColor = [UIColor jt_backgroudColor].CGColor;
    }else {
        self.backLayer.fillColor = [UIColor whiteColor].CGColor;
    }
}

- (BOOL)isTouchUpIn:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, location)) {
        return YES;
    }
    
    return NO;
}

@end
