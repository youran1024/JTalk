//
//  HTSectionView.h
//  JRJNews
//
//  Created by Mr.Yang on 14-4-29.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTBaseView.h"

@protocol HTSectionViewDelegate <NSObject>

- (void)htSectionViewDidTouched:(BOOL)isSelected section:(NSInteger)section;

@end

@interface HTSectionView : HTBaseView

@property (nonatomic, weak) id <HTSectionViewDelegate>delegate;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign)   BOOL enableSelected;
@property (nonatomic, assign)   BOOL selected;
@property (nonatomic, copy) void(^touchBlock)(BOOL selected);

@end
