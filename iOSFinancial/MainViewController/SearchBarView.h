//
//  SearchBarView.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface SearchBarView : HTBaseView

@property (nonatomic, weak) id<UITextFieldDelegate>searchDelegate;
@property (nonatomic, weak) IBOutlet UITextField *searchField;

- (void)makeEditing:(BOOL)editing;


@end

