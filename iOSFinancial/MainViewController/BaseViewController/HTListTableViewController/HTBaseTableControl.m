//
//  HTBaseTableControl.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/3/31.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTBaseTableControl.h"
#import "LoadMoreCell.h"

@interface HTBaseTableControl ()
{
    LoadMoreCell *_loadMoreCell;
}

//  数据源的种类
@property (nonatomic, strong)   NSDictionary *sourceKinds;
//  跟Cell绑定的动作
@property (nonatomic, strong)   NSMutableDictionary *actionsDic;

@end

@implementation HTBaseTableControl
@synthesize loadMoreCell = _loadMoreCell;

- (void)dealloc{
    [self removeKVO];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.pageSize = 15;
        self.pageNum = 1;
        
        self.shouldLoadMore = YES;
        [self reigitKVO];
    }

    return self;
}

- (LoadMoreCell *)loadMoreCell
{
    if (!_loadMoreCell) {
        _loadMoreCell = [LoadMoreCell newCell];
    }
    
    return _loadMoreCell;
}

- (NSMutableDictionary *)actionsDic
{
    if (!_actionsDic) {
        _actionsDic = [NSMutableDictionary dictionary];
    }
    
    return _actionsDic;
}

- (void)setLoadMoreActionBlock:(HTActionBlock)loadMoreActionBlock
{
    if (loadMoreActionBlock != _loadMoreActionBlock) {
        _loadMoreActionBlock = [loadMoreActionBlock copy];
        
        self.loadMoreCell.loadMoreActionBlock = _loadMoreActionBlock;
    }
}

#pragma mark - KVO

- (void)reigitKVO
{
    [self addObserver:self forKeyPath:@"sourceKinds" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"sourceKinds"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"sourceKinds"]) {
        [self reigitCellClass:_tableView];
    }
}

//---------------------------------------------------------------------------------------------
#pragma mark - tableView

- (BOOL)shouldShowLoadMoreCell
{
    return YES;
    return  _tableView.contentSize.height > _tableView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_shouldLoadMore &&
        _sources.count  &&
        [self shouldShowLoadMoreCell] ) {
        
        return _sources.count + 1;
    }
    
    return _sources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shouldLoadMore && _sources.count && indexPath.row >= _sources.count) {
        return [LoadMoreCell fixedHeight];
    }
    
    HTBaseSource *source = [_sources objectAtIndex:indexPath.row];
    return source.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _sources.count) {
        
        if (self.loadMoreCell.isShouldLoading) {
            self.loadMoreCell.cellState = CellStateLoading;
            
            self.loadMoreActionBlock (self, nil, indexPath);
        }
        
        return self.loadMoreCell;
    }
    
    id source = [_sources objectAtIndex:indexPath.row];
    NSString *cellStr = NSStringFromClass([[source class] cellClass]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if ([cell isKindOfClass:[HTBaseCell class]]) {
        [(HTBaseCell *)cell configWithSource:source];
        [(HTBaseCell *)cell setActions:[self actionsAtIndexPath:indexPath]];
    }else {
        //  UITableViewCell
        cell.textLabel.text = [(HTBaseSource *)source title];
        cell.detailTextLabel.text = [(HTBaseSource *)source detail];
    }
    
    cell.selectionStyle = [(HTBaseSource *)source cellSelectionStyle];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= _sources.count) {
        return ;
    }
    
    HTActions *actions = [self actionsAtIndexPath:indexPath];
    
    if (actions && actions.detailAction) {
        actions.detailAction (nil, self, indexPath);
    }
}

#pragma mark - 
#pragma mark Config

- (HTActions *)actionsForCell:(NSString *)cellStr
{
    HTActions *actions = [self.actionsDic objectForKey:cellStr];
    
    if (!actions) {
        actions = [[HTActions alloc] init];
        [self.actionsDic setObject:actions forKey:cellStr];
    }
    
    return actions;
}

- (NSString *)cellStringAtIndexPath:(NSIndexPath *)indexPath
{
    id source = [_sources objectAtIndex:indexPath.row];
    NSString *cellStr = NSStringFromClass([[source class] cellClass]);
    
    return cellStr;
}

- (HTActions *)actionsAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr = [self cellStringAtIndexPath:indexPath];
    return [self.actionsDic objectForKey:cellStr];
}

//---------------------------------------------------------------------------------------------
#pragma mark - attachCellClass

- (void)attachNoActionForCellClass:(Class)cls
{
    [self reigitSourceKinds:cls];
}

- (void)attachHeaderAction:(HTActionBlock)action forCellClass:(Class)cls
{
    NSString *classStr = NSStringFromClass(cls);
    HTActions *actions = [self actionsForCell:classStr];
    actions.headerAction = action;
    
    [self reigitSourceKinds:cls];
}

- (void)attachDetailAction:(HTActionBlock)action forCellClass:(Class)cls
{
    NSString *classStr = NSStringFromClass(cls);
    HTActions *actions = [self actionsForCell:classStr];
    actions.detailAction = action;
    
    [self reigitSourceKinds:cls];
}

- (void)attachTailAction:(HTActionBlock)action forCellClass:(Class)cls
{
    NSString *classStr = NSStringFromClass(cls);
    HTActions *actions = [self actionsForCell:classStr];
    actions.tailAction = action;
    
    [self reigitSourceKinds:cls];
}

- (void)attachOtherAction:(HTActionBlock)action forCellClass:(Class)cls
{
    HTActions *actions = [self actionsForCell:NSStringFromClass(cls)];
    actions.otherAction = action;
    
    [self reigitSourceKinds:cls];
}

//---------------------------------------------------------------------------------------------

#pragma mark - BindCell

- (void)reigitSourceKinds:(Class)cls
{
    NSString *classStr = NSStringFromClass(cls);
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:_sourceKinds];
    
    NSInteger before = _sourceKinds.allKeys.count;
    [mutDic setObject:classStr forKey:classStr];
    NSInteger after = mutDic.allKeys.count;
    
    //  只有发生变化的时候，才去触发KVO
    if (before != after) {
        self.sourceKinds = [NSDictionary dictionaryWithDictionary:mutDic];
    }
}

- (void)reigitCellClass:(UITableView *)tableView
{
    for (NSString *cellStr in _sourceKinds) {
        Class cellClass = NSClassFromString(cellStr);
        
        if ([cellClass isSubclassOfClass:[UITableViewCell class]]) {
            BOOL isNib = [cellClass isNib];
            if (isNib) {
                UINib *nib = [UINib nibWithNibName:cellStr bundle:[NSBundle mainBundle]];
                [tableView registerNib:nib forCellReuseIdentifier:cellStr];
            }else {
                [tableView registerClass:cellClass forCellReuseIdentifier:cellStr];
            }
        }
    }
}

#pragma mark RegistTableView
- (void)registTableView:(UITableView *)tableView
{
    _tableView = tableView;
}

@end
