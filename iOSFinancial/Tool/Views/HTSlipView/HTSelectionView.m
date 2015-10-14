//
//  HTSelectionView.m
//  JRJNews
//
//  Created by Mr.Yang on 14-8-4.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "HTSelectionView.h"
#import "HTSectionView.h"


@interface HTSelectionView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)   HTSectionView *sectionView;
@property (nonatomic, strong)   UIView *maskView;
@property (nonatomic, strong)   UITableView *tableView;
@end

@implementation HTSelectionView

- (id)init
{
    self = [super init];
    
    if (self) {
        [self createView];
    }
    
    return self;
}

- (CGFloat)sectionHeight
{
    return _sectionView.height;
}

- (void)setRowArray:(NSArray *)rowArray
{
    if (rowArray != _rowArray) {
        _rowArray = rowArray;
        [self.tableView reloadData];
        [self adjustHeight];
    }
}

- (HTSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [HTSectionView xibView];
        _sectionView.height = 36.0f;
        _sectionView.autoresizingMask = UIViewAutoresizingNone;
        
        _sectionView.enableSelected = YES;
        __weakSelf;
        [_sectionView setTouchBlock:^(BOOL isSelect) {
            [weakSelf slipSelectionView:isSelect];
        }];

    }
    
    return _sectionView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _maskView.clipsToBounds = YES;
        _maskView.userInteractionEnabled = YES;
    }
    
    return _maskView;
}

- (void)createView
{
    self.userInteractionEnabled = YES;
    self.autoresizesSubviews = NO;
    [self addSubview:self.sectionView];
    
    self.frame = self.sectionView.frame;
    [self addSubview:self.maskView];
}

- (void)adjustHeight
{
    [self.maskView addSubview:self.tableView];
    self.maskView.top = self.sectionView.bottom;
    self.tableView.height = self.tableView.contentSize.height;
    self.tableView.top = - _tableView.height;
    
    self.maskView.height = CGRectGetHeight(self.tableView.frame);
    
}

- (void)closeSplipView
{
    self.sectionView.selected = NO;
    
    [self slipSelectionView:NO];
}

//显示选择视图
- (void)slipSelectionView:(BOOL)show
{
    if (_touchedBlock) {
        _touchedBlock(show);
    }
    
    CGFloat tableViewTop;
    CGFloat tableViewHeight;
    if (show) {
        tableViewTop = 0;
        tableViewHeight = _tableView.height;
    }else {
        tableViewTop = -_tableView.height;
        tableViewHeight = -_tableView.height;
    }
    
    [UIView animateWithDuration:.25 animations:^{
        self.tableView.top = tableViewTop;
    } completion:^(BOOL finished) {
        self.height += tableViewHeight;
    }];
    
}

//要显示的控制器
- (void)presentViewControllerAtIndex:(NSInteger)index
{
    if (index < self.rowArray.count && index >= 0) {
        
        [self selectRowAtIndex:index];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
    }
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.text = self.rowArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shouldChangeVCBlock && !_shouldChangeVCBlock(indexPath.row)) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        return;
    }

    [self selectRowAtIndex:indexPath.row];
    
    [self slipSelectionView:NO];
}

- (void)selectRowAtIndex:(NSInteger)index
{
    if (_selectionBlock) {
        _selectionBlock(index);
    }
    
    self.sectionView.titleLabel.text = self.rowArray[index];
    self.sectionView.selected = NO;
}

@end


