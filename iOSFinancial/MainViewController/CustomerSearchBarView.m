//
//  SearchDisplayView.m
//  JTalk
//
//  Created by Mr.Yang on 15/11/17.
//  Copyright © 2015年 Mr.Yang. All rights reserved.
//

#import "CustomerSearchBarView.h"
#import "UIView+Animation.h"

@interface CustomerSearchBarView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIView *lineView;

@end

@implementation CustomerSearchBarView

- (void)awakeFromNib
{
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.placeholder = @"搜索此刻你想到的词";
    
    _lineView.backgroundColor = [UIColor jt_lineColor];
}

- (void)setSearchDelegate:(id<UITextFieldDelegate>)searchDelegate
{
    _searchDelegate = searchDelegate;
    _searchField.delegate = _searchDelegate;
    
}

- (IBAction)clearButtonClicked:(id)sender
{
    _searchField.text = @"";
}

- (IBAction)cancleButtonClicked:(id)sender
{
    if (_touchBlock) {
        _touchBlock();
    }
}

@end
