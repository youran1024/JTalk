//
//  PeopleCountView.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/12.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "PeopleCountView.h"

@interface PeopleCountView ()

@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIView *backView;

@end

@implementation PeopleCountView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backView.backgroundColor = HTHexColor(0x289756);
    self.backView.alpha = .8;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = HTWhiteColor;
    self.contentLabel.textColor = HTWhiteColor;

}

@end
