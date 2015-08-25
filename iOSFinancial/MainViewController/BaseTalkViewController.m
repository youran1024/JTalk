//
//  BaseTalkViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/8.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "BaseTalkViewController.h"

@interface BaseTalkViewController ()

@end

@implementation BaseTalkViewController

//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    //KEFU1439036374810
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


@end
