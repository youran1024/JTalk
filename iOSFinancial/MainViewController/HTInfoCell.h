//
//  HTInfoCell.h
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseCell.h"
#import "PlaceHolderTextView.h"

@interface HTInfoCell : HTBaseCell

@property (nonatomic, strong)   IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)   IBOutlet HTPlaceHolderTextView *placeHolderView;

@end
