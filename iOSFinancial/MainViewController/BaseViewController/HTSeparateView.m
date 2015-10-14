//
//  HTSlipView.m
//  htlabel
//
//  Created by Mr.Yang on 14-4-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//


#define HTPointViewTag  100011
//以字数计算，不考虑字号
#define SeparateMargin  2
//button距顶部的距离
#define ButtonMarginTop  0
#define SlideLineHeight  2
#define ButtonHeight    44

#import "HTSeparateView.h"
#import "RedPointLabel.h"

@interface HTSeparateView () <UIScrollViewDelegate>

@property (nonatomic, strong)   UIImageView *leftIndicateView;
@property (nonatomic, strong)   UIImageView *rightIndicateView;

@property (nonatomic, strong)   NSArray *buttons;
//  垂直的小竖线
@property (nonatomic, strong)   NSArray *labels;

@property (nonatomic, weak)     UIButton *selectButton;
@property (nonatomic, assign)   CGFloat globalMargin;

@property (nonatomic, strong)   UIImageView *pointView;
@property (nonatomic, strong)   UIView *bottomLineView;

@end

@implementation HTSeparateView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andMargin:0.0f];
}

- (id)initWithFrame:(CGRect)frame andMargin:(CGFloat)margin
{
    CGRect rect = frame;
    rect.size.height = CGRectGetHeight(rect) > ButtonHeight ?  CGRectGetHeight(rect) : ButtonHeight;
    
    self = [super initWithFrame:rect];
    
    if (self) {
        
        _globalMargin = margin > SeparateMargin ? margin : SeparateMargin;
        self.scrollsToTop = NO;
        [self initilization];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {

        [self initilization];
    }
    
    return self;
}

- (void)initilization
{
    self.delegate = self;
    self.slideType = SlideViewTypeLine;
    self.bounces = NO;
    
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self addSubview:self.backGroundView];
    [self addSubview:self.leftIndicateView];
    [self addSubview:self.rightIndicateView];
    [self addSubview:self.bottomLineView];
    
    self.bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - .3, CGRectGetWidth(self.frame), .3);
    
}

- (UIImageView *)pointView
{
    _pointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redPoint"]];
    _pointView.backgroundColor = [UIColor clearColor];
    _pointView.tag = HTPointViewTag;
    
    return _pointView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, .3)];
        _bottomLineView.backgroundColor = [UIColor jt_lineColor];
    }
    
    return _bottomLineView;
}

- (void)isHaveMessage:(BOOL)isHaveMessage
{
    [self isHaveMessage:isHaveMessage atIndex:1];
}

- (void)isHaveMessage:(BOOL)isHaveMessage atIndex:(NSInteger)index
{
    if (index >= _buttons.count) {
        NSAssert(index >= _buttons.count, @"数组越界了");
        return;
    }
    
    UIButton *button = [_buttons objectAtIndex:index];
    
    UIView *pointView = [button viewWithTag:HTPointViewTag];
    if (!pointView) {
        pointView = [self pointView];
        [button addSubview:pointView];
        CGPoint center;
        CGSize size = [button sizeThatFits:CGSizeMake(NSIntegerMax, CGRectGetHeight(self.frame))];
        center.x = (button.width + size.width) / 2.0f + 1;
        center.y = 10;
        pointView.center = center;
    }
    
    pointView.hidden = !isHaveMessage;
    
}

- (NSInteger)indexSelectedButton
{
    NSInteger index = [self.buttons indexOfObject:self.selectButton];
    
    return index;
}

- (UIImageView *)leftIndicateView
{
    if (!_leftIndicateView) {
        _leftIndicateView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"leftNormal"];
        [_leftIndicateView setImage:image];
        [_leftIndicateView setHighlightedImage:[UIImage imageNamed:@"leftHigh"]];
    
        CGRect rect = CGRectZero;
        rect.size = image.size;
        _leftIndicateView.frame = rect;
    }
    
    return _leftIndicateView;
}

- (UIImageView *)rightIndicateView
{
    if (!_rightIndicateView) {
        _rightIndicateView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"rightNormal"];
        [_rightIndicateView setImage:image];
        [_rightIndicateView setHighlightedImage:[UIImage imageNamed:@"rightHigh"]];
        
        CGRect rect = CGRectZero;
        rect.size = image.size;
        _rightIndicateView.frame = rect;
    }
    
    return _rightIndicateView;
}

- (UIImageView *)backGroundView
{
    if (!_backGroundView) {
        
        _backGroundView = [[UIImageView alloc] init];
        
        if (_slideType == SlideViewTypePiece) {
            _backGroundView.layer.cornerRadius = 3.0f;
        }
    }
    
    return _backGroundView;
}

- (void)setTitles:(NSArray *)titles
{
    if (titles != _titles) {
        _titles = titles;
        [self initilizeView];
    }

}

- (void)setButtonFont:(UIFont *)buttonFont
{
    if (_buttonFont != buttonFont) {
        _buttonFont = buttonFont;
        for (UIButton *button in _buttons) {
            button.titleLabel.font = buttonFont;
        }
        
        [self layoutSubviewsNow];
    }
}

- (void)setSlideType:(SlideViewType)slideType
{
    if (_slideType != slideType) {
        _slideType = slideType;
        [self layoutSubviewsNow];
    }
}

- (void)setViewHeight:(CGFloat)viewHeight
{
    if (_viewHeight != viewHeight) {
        [self layoutSubviewsNow];
    }
}

- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index >= _buttons.count) {
        assert(@"index run out of the Buttons");
        return;
    }
    
    
    UIButton *selectButton = [_buttons objectAtIndex:index];
    
    if (_selectButton == selectButton) {
        return;
    }
    
    BOOL shouldChange = YES;
    if (_htdelegate && [_htdelegate respondsToSelector:@selector(separateViewShouldChangeMenuAtIndex:)]) {
        shouldChange = [_htdelegate separateViewShouldChangeMenuAtIndex:index];
    }
    //不允许更改
    if (!shouldChange) {
        return;
    }
    
    //执行触发函数
    [self adjustContentOffset1:selectButton];
    
    [_selectButton setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    _selectButton = selectButton;
    [_selectButton setTitleColor:[UIColor jd_settingDetailColor] forState:UIControlStateNormal];
    
    __block CGRect rect = _backGroundView.frame;
    
    __weak HTSeparateView *weakSelf = self;
    [UIView animateWithDuration:animated ? .25 : 0 animations:^{
        if (_slideType == SlideViewTypeLine) {

            /*
            CGSize size = [selectButton sizeThatFits:CGSizeMake(NSIntegerMax, CGRectGetHeight(self.frame))];
            CGPoint center = selectButton.center;
            rect.origin.x = center.x - size.width / 2 - 4;
            //MARK:划线加宽
            rect.size.width = size.width + 6;
            weakSelf.backGroundView.frame = rect;
             */
            
            rect.origin.y = CGRectGetHeight(selectButton.frame) - SlideLineHeight;
            
            rect.origin.x = CGRectGetMinX(selectButton.frame);
            rect.size.width = CGRectGetWidth(selectButton.frame);
            weakSelf.backGroundView.frame = rect;
            
        }else {
            rect.size.width = CGRectGetWidth(selectButton.frame);
            weakSelf.backGroundView.frame = rect;
            weakSelf.backGroundView.center = selectButton.center;
        }
        
    } completion:^(BOOL finished) {
        
        if (_slideType == SlideViewTypePiece) {
            [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];
    
    
    if (_buttonClicked) {
        _buttonClicked(index);
    }
}

-(void)initilizeView
{
    NSMutableArray *buttons = [NSMutableArray array];
    
    CGRect rect;
    for (NSString *title in _titles) {
        UIButton *button = [self buttonWithTitle:title];
        [button sizeToFit];
        rect = button.frame;
        
        rect.size.width += 10;
        button.frame = rect;
        [self addSubview:button];
        [buttons addObject:button];
    }
    
    _buttons = buttons;
    
    [self layoutSubviewsNow];
    
    [self selectButtonAtIndex:0 animated:NO];
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button setTitleColor:[UIColor colorWithHEX:0x595959] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (void)buttonClicked:(UIButton *)button
{
    if (button == _selectButton) {
        return;
    }
    
    NSInteger index = [_buttons indexOfObject:button];
    
    [self selectButtonAtIndex:index animated:YES];
}

- (void)adjustContentOffset:(UIButton *)button
{
    CGFloat offsetX = self.contentSize.width - APPScreenWidth;
    CGPoint offset;
    if (button.left > 170) {
        offset = CGPointMake(offsetX, 0);
        
    }else {
       offset = CGPointMake(0, 0);
    }
    
    [self setContentOffset:offset animated:YES];
}

- (void)adjustContentOffset1:(UIButton *)button
{
    if (_leftIndicateView.hidden && _rightIndicateView.hidden) {
        return;
    }
    
    BOOL directionLeft = YES;
    //向左判断偏移，还是向右判断偏移
    if (button.origin.x > _selectButton.origin.x) {
        //向右
        directionLeft = NO;
    }
    
    CGFloat tmpOffset;
    NSInteger index = [_buttons indexOfObject:button];
    
    if (!directionLeft) {
        //向左偏移
        if (_buttons.count > (index + 2)) {
            //右边还有按钮
            UIButton *tmpButton = [_buttons objectAtIndex:index + 1];
            if ([self isCoveredbyFrame:tmpButton]) {
                tmpOffset = CGRectGetMaxX(tmpButton.frame) - self.width;
            }else {
                return;
            }
            
        }else {
            tmpOffset = self.contentSize.width - self.width;
        }
        
    }else{
        //向右偏移
        
        if (index > 1) {
            //右边还有按钮
            UIButton *tmpButton = [_buttons objectAtIndex:index - 1];
            if ([self isLeftCoveredByFrame:tmpButton]) {
                tmpOffset = CGRectGetMinX(tmpButton.frame);
            }else {
                return;
            }
            
        }else {
            tmpOffset = 0;
        }

    }
    
    if (tmpOffset < 0) {
        return;
    }
    
    [self setContentOffset:CGPointMake(tmpOffset, 0) animated:YES];
}

- (BOOL)isCoveredbyFrame:(UIButton *)button
{
    CGFloat offset = CGRectGetMaxX(button.frame) - self.contentOffset.x;
    
    return offset > self.width ? YES : NO;
}

- (BOOL)isLeftCoveredByFrame:(UIButton *)button
{
    CGFloat offset = CGRectGetMinX(button.frame) - self.contentOffset.x;
    return offset < 0 ? YES : NO;
}


- (void)layoutSubviewsNow
{
    CGRect rect = CGRectZero;
    NSInteger index;
    UIButton *lastButton;
    
    __block CGFloat buttonWidth;
    [_buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        buttonWidth += CGRectGetWidth(button.frame);
    }];
    
    CGFloat margin = (CGRectGetWidth(self.frame) - 2 * _globalMargin - buttonWidth) / (_buttons.count - 1);
    margin = margin < _globalMargin ? _globalMargin : margin;
    
    //  平均分布
    BOOL average = NO;
    CGFloat averageWith = 0.0;
    if (margin > 0) {
        average = YES;
        averageWith = APPScreenWidth / _buttons.count;
    }
    
    
    for (UIButton *button in _buttons) {
        
        index = [_buttons indexOfObject:button];
        rect = button.frame;
        rect.origin.y =  ButtonMarginTop;
        rect.size.height = CGRectGetHeight(self.frame) + ButtonMarginTop * 2;
        if (average) {
            
            if (lastButton) {
                rect.origin.x = CGRectGetMaxX(lastButton.frame);
            }else {
                rect.origin.x = 0;
            }
            
            rect.size.width = averageWith;
            
        }else {
            if (index == 0) {
                rect.origin.x = _globalMargin;
                rect.size.width += _globalMargin + margin / 2.0f;
            }else if (index == (_buttons.count - 1)){
                
                rect.origin.x = CGRectGetMaxX(lastButton.frame);
                rect.size.width += _globalMargin + margin / 2.0f;
                
            }else {
                rect.origin.x = CGRectGetMaxX(lastButton.frame);
                rect.size.width += margin;
            }
        }
    
        if (index != (_buttons.count - 1)) {
            //  MARK:竖线的宽度 和 竖线
            CGFloat x = CGRectGetMaxX(rect);
            CGFloat y = (CGRectGetHeight(rect) - 30) / 2.0f;
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(x, y, .3, 30);
            [self addSubview:label];
            label.backgroundColor = [UIColor jt_lineColor];
        }
        
        button.frame = rect;
        lastButton = button;
    }
    
    if (_slideType == SlideViewTypeLine) {
        rect.size.height = SlideLineHeight;
    }else {
        rect.size.height = CGRectGetHeight(lastButton.frame);
    }
    
    _backGroundView.backgroundColor = self.slideViewColor;
    _backGroundView.frame = rect;
    
    rect = self.frame;
    rect.size.height = CGRectGetHeight(lastButton.frame) ;
    
//    CGFloat minWidth = CGRectGetMaxX(lastButton.frame) + _globalMargin / 2.0f;
    /*
    if (minWidth < CGRectGetWidth(self.frame)) {
        minWidth = CGRectGetWidth(self.frame) + 1;
    }
     */
    
//    self.contentSize = CGSizeMake(minWidth, 0);
    
    self.frame = rect;
    
    if (self.contentSize.width > self.width + margin) {
        [self adjustIndicateView:self];
        
    }else {
        self.leftIndicateView.hidden = YES;
        self.rightIndicateView.hidden = YES;
    }

    [self bringSubviewToFront:self.bottomLineView];
}

#pragma mark - 
#pragma mark Delegate Scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustIndicateView:scrollView];
}

//类别里边有个可以影响全局的函数，在此需要重写
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //  nop
}

- (void)adjustIndicateView:(UIScrollView *)scrollView
{
    if (_leftIndicateView.hidden && _rightIndicateView.hidden) {
        return;
    }
    
    _leftIndicateView.hidden = NO;
    _rightIndicateView.hidden = NO;

    _leftIndicateView.top = (scrollView.height - _leftIndicateView.height) / 2.0f;
    _rightIndicateView.top = _leftIndicateView.top;

    _leftIndicateView.left = scrollView.contentOffset.x;
    _rightIndicateView.left = scrollView.contentOffset.x + self.width - _rightIndicateView.width;
    CGFloat maxContentOffset = scrollView.contentSize.width - CGRectGetWidth(scrollView.frame);
    
    if (scrollView.contentOffset.x <= 0) {
        
        _leftIndicateView.hidden = YES;
        _rightIndicateView.highlighted = YES;
        
    }else if (scrollView.contentOffset.x >= floor(maxContentOffset)){
        
        _leftIndicateView.highlighted = YES;
        _rightIndicateView.hidden = YES;
    }else {
        
        _leftIndicateView.highlighted = YES;
        _rightIndicateView.highlighted = YES;
    }
}

- (UIColor *)slideViewColor
{
    if (!_slideViewColor) {
        //_slideViewColor = [UIColor colorWithHEX:0xde3031];
        _slideViewColor = [UIColor jd_settingDetailColor];
    }
    
    return _slideViewColor;
}


@end
