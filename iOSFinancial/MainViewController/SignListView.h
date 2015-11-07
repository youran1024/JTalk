//
//  SignListView.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"
#import "SignListModel.h"
#import "SignModel.h"


@interface SignListView : HTBaseView

@property (nonatomic, copy) void(^changeAnotherBlock)(UIButton *button);
@property (nonatomic, copy) void(^signClickBlock)(SignModel *model, UIButton *button);
@property (nonatomic, copy) void(^signListViewTouchBlcok)(SignListModel *model,  SignListView *signView);


//  标签
- (void)refreWithModel:(SignListModel *)model;

@end
