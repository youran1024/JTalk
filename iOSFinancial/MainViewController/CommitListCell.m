//
//  CommitListCell.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "CommitListCell.h"
#import "NSDate+BFExtension.h"


@implementation CommitListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizesSubviews = NO;
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2.0f;
    
    self.nameLabel.textColor = [UIColor jt_globleTextColor];
    self.promptLabel.textColor = [UIColor jt_lightBlackTextColor];
}

- (void)parseWithDic:(NSDictionary *)dic
{
    NSString *userName = [dic stringForKey:@"name"];
    NSString *imageUrl = [dic stringForKey:@"photo"];
    NSInteger sex = [[dic stringForKey:@"sex"] integerValue];
    NSString *dateString = [dic stringForKey:@"created"];

    [self parseWithUserName:userName
                    userSex:sex
                  userImage:imageUrl
                       date:dateString];
}

- (void)parseWithDic_pullBlack:(NSDictionary *)dic
{
    NSString *userName = [dic stringForKey:@"user_name"];
    NSString *imageUrl = [dic stringForKey:@"user_photo"];
    NSInteger sex = [[dic stringForKey:@"sex"] integerValue];
    NSString *dateString = [dic stringForKey:@"created"];
    
    [self parseWithUserName:userName
                    userSex:sex
                  userImage:imageUrl
                       date:dateString];
}

- (void)parseWithUserName:(NSString *)userName
                  userSex:(NSInteger)sex
                userImage:(NSString *)userImage
                     date:(NSString *)dateStr
{
    self.nameLabel.text = userName;
    [self.nameLabel sizeToFit];

    // 1 男  2 女
    if (sex == 1) {
        //  男
        self.sexImageView.image = HTImage(@"male");
    }else {
        //  女
        self.sexImageView.image = HTImage(@"female");
    }
    
    [self.headImageView sd_setImageWithURL:HTURL(userImage) placeholderImage:HTImage(@"app_icon")];

    NSDate *date = [NSDate dateWithString:dateStr format:nil];
    self.promptLabel.text = [date labelString];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel sizeToFit];
    
    self.sexImageView.left = self.nameLabel.right + 3;
    self.sexImageView.bottom = self.nameLabel.bottom;
}

@end
