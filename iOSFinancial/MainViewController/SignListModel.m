//
//  SignListModel.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/17.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "SignListModel.h"
#import "SignModel.h"

static NSString *kSignListPageNum = @"kSignListPageNum";
static NSString *kSignArray = @"kSignArray";
static NSString *kSignType = @"kSignType";
static NSString *kSignTitle = @"kSignTitle";
static NSString *kSignListShowSign = @"kSignListShowSign";

@interface SignListModel ()

@property (nonatomic, assign)   NSInteger pageNum;

@property (nonatomic, assign)   NSInteger pageSize;

@property (nonatomic, strong) NSArray *signArray;

@end

@implementation SignListModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self config];
        self.pageSize = 6;
        self.pageNum = 1;
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.title = [aDecoder decodeObjectForKey:kSignTitle];
        self.signType = [[aDecoder decodeObjectForKey:kSignType] integerValue];
        self.signArray = [aDecoder decodeObjectForKey:kSignArray];
        _showSignList = [aDecoder decodeObjectForKey:kSignListShowSign];
        self.pageNum = [[aDecoder decodeObjectForKey:kSignListPageNum] integerValue];
        
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kSignTitle];
    [aCoder encodeObject:@(self.signType) forKey:kSignType];
    [aCoder encodeObject:self.signArray forKey:kSignArray];
    [aCoder encodeObject:self.showSignList forKey:kSignListShowSign];
    [aCoder encodeObject:@(self.pageNum) forKey:kSignListPageNum];
}

- (void)config
{
    self.title = @"时事热点";
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        SignModel *model = [[SignModel alloc] init];
        [array addObject:model];
    }
    
    _signArray = array;
}

- (void)parseWithDictionary:(NSDictionary *)dic
{
    self.title = [dic stringForKey:@"type_name"];
    self.signType = [[dic stringIntForKey:@"type"] integerValue];

    NSArray *array = [dic arrayForKey:@"words"];
    
    if (array.count == 0) {
        return;
    }
    
    NSMutableArray *mutArray = [NSMutableArray array];
    for (id obj in array) {
        SignModel *model = [[SignModel alloc] init];
        [model parseWithDictionary:obj];
        [mutArray addObject:model];
    }
    
    self.signArray = [NSArray arrayWithArray:mutArray];
    
    [self changeNextPage];
}

- (void)parseWithPersonalArray:(NSArray *)array
{
    self.title = @"历史标签";
    self.signType = SignTagTypeNormal;
    
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSString *title in array) {
        SignModel *model = [[SignModel alloc] init];
        model.title = title;
        [mutArray addObject:model];
    }
    
    self.signArray = [NSArray arrayWithArray:mutArray];
    
    [self changeNextPage];

}

- (NSInteger)changeNextPage
{
    
//    NSAssert(_signArray.count > self.pageSize, @"数组最小不能小过分页大小");
    
    NSMutableArray *array = [NSMutableArray array];

    //  这次分页的起始位置
    NSInteger index = (_pageNum - 1) * 6 % _signArray.count;
    
    for (NSInteger i = 0; i < 6; i++) {
        [array addObject:[_signArray objectAtIndex:index]];
        index++;
        if (index == _signArray.count) {
            index = 0;
        }
    }
    
    _showSignList = array;
    
    _pageNum++;
    
    return _showSignList.count;
}

@end
