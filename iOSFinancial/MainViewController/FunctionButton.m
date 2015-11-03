//
//  FunctionButton.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/2.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "FunctionButton.h"

@interface FunctionButton ()

@property (nonatomic, strong) IBOutlet   UIView *lineView;

@end

@implementation FunctionButton

- (void)awakeFromNib
{
    self.backgroundColor = HTHexColor(0x4bb174);
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.lineView.backgroundColor = HTHexColor(0x4aa770);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = .4;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0f;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0f;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        if (_touchBlock) {
            _touchBlock (self);
        }
    }
}

@end
