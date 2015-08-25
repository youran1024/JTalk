//
//  PersonalInfoView.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/18.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface PersonalInfoView : HTBaseView

@property (nonatomic, strong)   IBOutlet UIImageView *imageView;
@property (nonatomic, strong)   IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)   IBOutlet UILabel *locationLabel;
@property (nonatomic, strong)   IBOutlet UILabel *promptLabel;


@end
