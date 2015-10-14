//
//  TalkedFriendsTopView.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/8/3.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "TalkedFriendsTopView.h"

@interface TalkedFriendsTopView ()

@property (nonatomic, weak) IBOutlet UIView *lineView;

@end

@implementation TalkedFriendsTopView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
    
    self.titleLabel.textColor = [UIColor jt_globleTextColor];
    self.promptLabel.textColor = [UIColor jt_lightBlackTextColor];
    self.lineView.backgroundColor = [UIColor jt_lineColor];
}

- (IBAction)tailButtonClicked:(id)sender
{
    
    
}

@end
