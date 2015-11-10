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

@property (nonatomic, weak)   SignListModel *signListModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, assign) NSInteger pageNum;

//  卧谈会的图片
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *imageTitleLabel;

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

- (void)createView
{
    NSArray *signs = _signListModel.showSignList;
    
    if ((signs.count == 0 && _signListModel.signViewType == SignViewTypeLabel) ||(
        !_signListModel.showSignDic && _signListModel.signViewType == SignViewTypeImage)) {
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
    
    if (self.signListModel.signViewType == SignViewTypeLabel) {
        [self createSignListView];
        
    }else {
        [self createSignImageView];
    }
}

- (void)createSignImageView
{
    CGFloat signTop = 15 + 20 + 10.0f;
    
    [self addSubview:self.imageView];
    self.imageView.frame = CGRectMake(15, signTop, APPScreenWidth - 60.0f, 138);
    
    [self.imageView addSubview:self.imageTitleLabel];
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.imageView.height - 26, self.imageView.width, 26)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = .7f;
    [self.imageView addSubview:maskView];
    
    self.imageTitleLabel.frame = maskView.bounds;
    self.imageTitleLabel.left = 10.0f;
//    self.imageTitleLabel.centerY = maskView.centerY;
    [maskView addSubview:self.imageTitleLabel];
    
    [self refreImageView];
}

- (void)refreImageView
{
    NSDictionary *dict = self.signListModel.showSignDic;
    
    NSString *imageUrl = [dict stringForKey:@"image_url"];
    NSString *title = [dict stringForKey:@"title"];
    [self.imageView sd_setImageWithURL:HTURL(imageUrl) placeholderImage:HTImage(@"nonedataImage")];
    
    self.imageTitleLabel.text = title;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped)];
        [_imageView addGestureRecognizer:tap];
    }

    return _imageView;
}

- (UILabel *)imageTitleLabel
{
    if (!_imageTitleLabel) {
        _imageTitleLabel = [[UILabel alloc] init];
        _imageTitleLabel.font = HTFont(15.0f);
        _imageTitleLabel.textColor = [UIColor whiteColor];
    }

    return _imageTitleLabel;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClicked)];
        [_titleLabel addGestureRecognizer:tap];
        _titleLabel.userInteractionEnabled = YES;
    }

    return _titleLabel;
}

- (void)titleLabelClicked
{
    if (_titleTouchBlock) {
        _titleTouchBlock(self.signListModel.signType, self.titleLabel.text);
    }
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
    
    if (_signListModel.signViewType == SignViewTypeImage) {
        [self refreImageView];
        
    }else {
        [self refreshView];
    }
    
    if (_changeAnotherBlock) {
        _changeAnotherBlock(button);
    }

}

- (void)imageViewTaped
{
    if (_signListViewTouchBlcok) {
        _signListViewTouchBlcok(self.signListModel, self);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        if (_signListViewTouchBlcok) {
            _signListViewTouchBlcok(self.signListModel, self);
        }
    }
}

@end
