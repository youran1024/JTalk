//
//  FunctionButton.h
//  JTalk
//
//  Created by Mr.Yang on 15/11/2.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface FunctionButton : HTBaseView

@property (nonatomic, strong)  IBOutlet UIImageView *imageView;
@property (nonatomic, strong)  IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void(^touchBlock)(FunctionButton *button);

@end
