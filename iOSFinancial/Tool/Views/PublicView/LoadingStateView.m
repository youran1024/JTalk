//
//  NoneDataView.m
//  JRJInvestAdviser
//
//  Created by Mr.Yang on 14-11-7.
//  Copyright (c) 2014年 jrj. All rights reserved.
//

#import "LoadingStateView.h"
#import "UIView+BorderColor.h"

@interface LoadingStateView  ()

@property (nonatomic, strong)   UIImageView *imageView;

@property (nonatomic, strong)   UILabel *promptLabel;

@property (nonatomic, strong)   UIActivityIndicatorView *activyView;

@end

@implementation LoadingStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.promptLabel];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)setLoadingState:(LoadingState)loadingState
{
    if (_loadingState != loadingState) {
        _loadingState = loadingState;
        [self reloadLoadingState:loadingState];
    }
}

- (void)reloadLoadingState:(LoadingState)loadingState
{
    if (loadingState == LoadingStateLoading) {
        [_imageView removeFromSuperview];
        [self addSubview:self.activyView];
        [_activyView startAnimating];
        
        self.promptLabel.text = @"加载中...";
        
    }else {
        
        [_activyView stopAnimating];
        [_activyView removeFromSuperview];
        [self addSubview:self.imageView];
        
        if (loadingState > LoadingStateNetworkError) {
                _promptLabel.text = @"暂无数据";
            
        }else {
                _promptLabel.text = @"网络连接异常，请点击屏幕重试";
        }
        
        UIImage *image = HTImage(@"HaveNoneData");
        
        switch (loadingState) {
            case LoadingStateNetworkError: image = HTImage(@"HaveNoNet");break;
            case LoadingStateNoneData: image = HTImage(@"HaveNoneData");break;
            case LoadingStateNoneAdviserGroup: image = HTImage(@"HaveNoneAdviseGroup");break;
            case LoadingStateNonePreWarining: image = HTImage(@"HaveNonePrewarning");break;
            case LoadingStateNoneSearch: image = HTImage(@"HaveNoneSearch");break;
            case LoadingStateNoneSystemMessage: image = HTImage(@"HaveNoneMessage");break;
            case LoadingStateNoneZhiBo: image = HTImage(@"HaveNoneZhibo");break;
            default:
                image = _image;
                _promptLabel.text = _promptStr;
                
                break;
        }
        
        [self setImage:image];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    
    return _imageView;
}

- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.numberOfLines = 2;
        _promptLabel.font = HTFont(15.0f);
        _promptLabel.textColor = HTHexColor(0x727272);
    }

    return _promptLabel;
}

- (UIActivityIndicatorView *)activyView
{
    if (!_activyView) {
        _activyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activyView startAnimating];
    }
    
    return _activyView;
}

- (void)setImage:(UIImage *)image
{
    if (_image != image) {
        _image = image;
        self.imageView.image = _image;
        CGRect rect = _imageView.frame;
        rect.size = image.size;
        _imageView.frame = rect;
    }
}

- (void)setPromptStr:(NSString *)promptStr
{
    if (![promptStr isEqualToString:_promptStr]) {
        _promptStr = promptStr;
        self.promptLabel.text = _promptStr;
        [self.promptLabel sizeToFit];
        [self layoutIfNeeded];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGPoint point = CGPointMake(self.width / 2.0f, self.height / 2.0f);
    
    CGSize size = [self.promptLabel sizeThatFits:CGSizeMake(230, 36)];
    _promptLabel.size = size;
    
    if (_loadingState == LoadingStateLoading) {
        _activyView.center = point;
        
        point.y = _activyView.bottom + size.height;
        _promptLabel.center = point;
        
        return;
    }
    
//    point.y -= self.imageView.height / 4.0f;
    self.imageView.center = point;
    
    point.y += _imageView.height / 2.0f;
    
    point.y += size.height;
    self.promptLabel.center = point;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (_loadingState == LoadingStateNetworkError || _shouldRefresh) {
        self.loadingState = LoadingStateLoading;
        if (_touchBlock) {
            _touchBlock (self, _loadingState);
        }
    }
}

@end
