//
//  SearchDisplayView.h
//  JTalk
//
//  Created by Mr.Yang on 15/11/17.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@interface CustomerSearchBarView : HTBaseView

@property (nonatomic, weak) id<UITextFieldDelegate>searchDelegate;
@property (nonatomic, weak) IBOutlet UITextField *searchField;
@property (nonatomic, copy) void(^touchBlock)(void);

@end
