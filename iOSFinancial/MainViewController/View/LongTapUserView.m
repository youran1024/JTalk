//
//  LongTapUserView.m
//  JTalk
//
//  Created by Mr.Yang on 15/9/14.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "LongTapUserView.h"


@interface LongTapUserView()

@property (nonatomic, strong)   IBOutlet UIButton *pullBackButton;
@property (nonatomic, strong)   IBOutlet UIButton *cancelButton;
@property (nonatomic, strong)   IBOutlet UIButton *atSomeButton;

@end


@implementation LongTapUserView

- (void)awakeFromNib
{
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
    self.headImageView.image = HTImage(@"app_icon");
    
    self.nameLabel.font = HTFont(16.0f);
    self.promptLabel.font = HTFont(15.0f);
    self.nameLabel.textColor = [UIColor jt_globleTextColor];
    self.promptLabel.textColor = [UIColor jt_darkBlackTextColor];
    
    [self.atSomeButton setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
    [self.pullBackButton setTitleColor:[UIColor jt_lightGrayColor] forState:UIControlStateNormal];
    
    self.pullBackButton.right = self.width - 80.0f;
    
}

- (IBAction)pullBackButton:(id)sender
{
    if (_buttonClickBlock) {
        _buttonClickBlock(sender, 1);
    }
}

- (IBAction)atSomeOneButton:(id)sender
{
    if (_buttonClickBlock) {
        _buttonClickBlock(sender, 2);
    }
}

- (IBAction)cancelButton:(id)sender
{
    if (_buttonClickBlock) {
        _buttonClickBlock(sender, 3);
    }
}

@end
