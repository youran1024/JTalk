//
//  HTSlipView.h
//  htlabel
//
//  Created by Mr.Yang on 14-4-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTSeparateViewDelegate <NSObject>

- (BOOL)separateViewShouldChangeMenuAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, SlideViewType) {
    //滑动样式，线
    SlideViewTypeLine,
    //色块
    SlideViewTypePiece
    
};

@interface HTSeparateView : UIScrollView

@property (nonatomic, weak) id <HTSeparateViewDelegate> htdelegate;
@property (nonatomic, strong)   NSArray *titles;
@property (nonatomic, assign)   CGFloat viewHeight;
@property (nonatomic, assign)   SlideViewType slideType;
@property (nonatomic, strong)   UIImageView *backGroundView;
@property (nonatomic, strong)   UIColor *slideViewColor;
@property (nonatomic, strong)   UIFont *buttonFont;
@property (nonatomic, copy)     void(^buttonClicked)(NSInteger index);


- (id)initWithFrame:(CGRect)frame andMargin:(CGFloat)margin;
//  选择第几个功能
- (void)selectButtonAtIndex:(NSInteger)index animated:(BOOL)animated;

//  在Button上边打点
- (void)isHaveMessage:(BOOL)isHaveMessage;
- (void)isHaveMessage:(BOOL)isHaveMessage atIndex:(NSInteger)index;

- (NSInteger)indexSelectedButton;

@end
