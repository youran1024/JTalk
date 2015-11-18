//
//  SearchBarView.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SearchBarView.h"
#import "UIView+Animation.h"

@interface SearchBarView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;


@end


@implementation SearchBarView

- (void)awakeFromNib
{
    self.titleLabel.textColor = [UIColor colorWithHEX:0xc6c6c6];
    self.titleLabel.font = HTFont(14.0f);
    _searchField.returnKeyType = UIReturnKeySearch;
    _clearButton.hidden = YES;
}

- (void)makeEditing:(BOOL)editing
{
    _titleLabel.hidden = editing;
    _imageView.hidden = editing;
    _clearButton.hidden = !editing;
    
    [_clearButton flashAnimation];
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

@end
