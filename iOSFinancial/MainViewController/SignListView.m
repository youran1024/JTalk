//
//  SignListView.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SignListView.h"
#import "SignModel.h"
#import "UIView+LabelSign.h"
#import "UIView+NoneDataView.h"

#define __SignListViewPageCount__ 6

@interface SignListView ()

@property (nonatomic, weak) SignListModel *signListModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *changeButton;

@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation SignListView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor jt_lineColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 3.0f;
    }

    return self;
}

- (void)refreWithModel:(SignListModel *)model
{
    _signListModel = model;
    
    [self refreshView];
}

- (void)refreshView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createView];
}

- (void)createSignListView
{
    NSArray *signs = _signListModel.showSignList;

    int i = 0;
    CGFloat largeWith = (APPScreenWidth - 60.0f) / 2.0f;
    CGFloat signTop = 15 + 20 + 10.0f;
    for (SignModel *model in signs) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:model.title forState:UIControlStateNormal];
        button.titleLabel.font = HTFont(14.0f);
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitleColor:[UIColor jt_globleTextColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor jt_lightGrayColor] forState:UIControlStateHighlighted];
        
        if (!isEmpty(model.signTag)) {
            [button showLabelWithTitle:model.signTag];
        }else {
            [button removeLabelSign];
        }
        
        [button sizeToFit];
        
        if (button.width > largeWith) {
            button.width = largeWith;
        }
        
        CGFloat locationX = (i % 2) * largeWith + 15;
        CGFloat locationY = signTop + i / 2 * (20 + 23) + 10 ;
        
        button.frame = CGRectMake(locationX, locationY, button.width, 23);
        
        if (i % 2 == 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15.0f, button.bottom + 10, APPScreenWidth - 60.0f, .5)];
            
            line.backgroundColor = [UIColor jt_lineColor];
            [self addSubview:line];
        }
        
        NSInteger index = [signs indexOfObject:model];
        
        button.tag = index;
        
        [button addTarget:self action:@selector(signButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        if (i++ == __SignListViewPageCount__) {
            break;
        }
    }
}

- (void)createView
{
    NSArray *signs = _signListModel.showSignList;
    
    if (signs.count == 0) {
        LoadingStateView *view = [self showNoneDataView];
        view.promptStr = @"";
        
        return;
    }
    
    [self addSubview:self.titleLabel];
    
    _titleLabel.text = _signListModel.title;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15.0f));
        make.top.equalTo(@(15));
        
    }];
    
    [self addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15.0f));
        make.top.equalTo(@(12.0f));
    }];
    
    [self createSignListView];
}

- (void)signButtonClicked:(UIButton *)button
{
    if (_signClickBlock) {
        SignModel *model = [_signListModel.showSignList objectAtIndex:button.tag];
        _signClickBlock(model, button);
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HTHexColor(0xc0c0c0);
        _titleLabel.font = HTFont(15);
        
    }

    return _titleLabel;
}

- (UIButton *)changeButton
{
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitleColor:[UIColor colorWithHEX:0x4dba79] forState:UIControlStateNormal];
        [_changeButton setTitle:@"再来一批" forState:UIControlStateNormal];
        _changeButton.titleLabel.font = HTFont(15.0f);
        [_changeButton setImage:HTImage(@"changeAnother") forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(changeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _changeButton;
}

- (void)changeButtonClicked:(UIButton *)button
{
    [_signListModel changeNextPage];
    [self refreshView];
    
    if (_changeAnotherBlock) {
        _changeAnotherBlock(button);
    }

}

@end
