//
//  HTSectionView.m
//  JRJNews
//
//  Created by Mr.Yang on 14-4-29.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTSectionView.h"

@interface HTSectionView ()
@property (nonatomic, strong) IBOutlet UIImageView *arrowView;

@end

@implementation HTSectionView

- (void)layoutSubviews
{
    
}

- (void)awakeFromNib
{
    self.autoresizesSubviews = NO;
    self.userInteractionEnabled = YES;
    [self setSelected:NO animated:NO];
    self.arrowView.highlighted = YES;
}

- (void)setEnableSelected:(BOOL)enableSelected
{
    _enableSelected = enableSelected;
    
    if (!enableSelected) {
        _arrowView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        [self setSelected:selected animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _selected = selected;
    if (selected) {
        
        [UIView animateWithDuration:animated ? .35 : 0 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
//            self.backgroundColor = [UIColor sectionViewHighlightBackGroudColor];
        }];
        
//        self.titleLabel.textColor = [UIColor sectionTitleBlue];

    }else {
        
        [UIView animateWithDuration:animated ? .35 : 0 animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.backgroundColor = [UIColor whiteColor];
        }];
        
//        self.titleLabel.textColor = [UIColor sectionViewTitleColor];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_enableSelected) {
        return;
    }
    
    self.selected = !self.selected;
    if (_touchBlock) {
        _touchBlock(self.selected);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(htSectionViewDidTouched: section:)]) {
        [_delegate htSectionViewDidTouched:_selected section:self.tag];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1);
//    CGColorRef colorRef = self.selected ?
//        [UIColor sectionViewBottomLineBlueColor].CGColor :
//        [UIColor sectionViewBottomLineGrayColor].CGColor;
    
//    CGContextSetStrokeColorWithColor(contextRef, colorRef);
    CGContextMoveToPoint(contextRef, 0, CGRectGetHeight(rect));
    CGContextAddLineToPoint(contextRef, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(contextRef);
}

@end
