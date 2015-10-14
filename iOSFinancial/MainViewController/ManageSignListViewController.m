//
//  ManageSignListViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "ManageSignListViewController.h"
#import "UIBarButtonExtern.h"
#import "AddSignViewController.h"

@interface ManageSignListViewController ()

@property (nonatomic, copy)     NSMutableString *willInsertSign;

@property (nonatomic, strong)   NSMutableArray *inCommonUseSignList;
@property (nonatomic, strong)   NSMutableArray *customSignList;

@end

@implementation ManageSignListViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isEmpty(_willInsertSign)) {
        [_customSignList addObject:_willInsertSign];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_customSignList.count inSection:1]]withRowAnimation:UITableViewRowAnimationRight];
    }
    
    _willInsertSign = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.inCommonUseSignList addObject:@"看球"];
    [_inCommonUseSignList addObject:@"看电视剧"];
    
    [self.customSignList addObject:@"压马路"];
    [_customSignList addObject:@"暴跳如雷"];
    [_customSignList addObject:@"lol"];
    
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"完成" target:self andSelector:@selector(finisButtonClicked)];
}

- (void)finisButtonClicked
{
    
    
}

- (NSMutableArray *)inCommonUseSignList
{
    if (!_inCommonUseSignList) {
        _inCommonUseSignList = [NSMutableArray array];
    }

    return _inCommonUseSignList;
}

- (NSMutableArray *)customSignList
{
    if (!_customSignList) {
        _customSignList = [NSMutableArray array];
    }
    
    return _customSignList;
}

- (NSMutableString *)willInsertSign
{
    if (!_willInsertSign) {
        _willInsertSign = [[NSMutableString alloc] init];
    }
    
    return _willInsertSign;
}

#pragma mark - 
#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_inCommonUseSignList.count == 0) {
        return 1;
    }
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 33)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 13, 230, 20)];
    titleLabel.textColor = [UIColor jt_lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [view addSubview:titleLabel];

    if (_inCommonUseSignList.count == 0) {
        titleLabel.text = @"管理你的常用的状态标签";
        
    }else {
        
        if (section == 0) {
            titleLabel.text = @"管理你的常用的状态标签";
        }else {
            titleLabel.text = @"管理自定义状态标签";
        }
    }
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_inCommonUseSignList.count == 0) {
        return _customSignList.count + 1;
        
    }else {
        
        if (section == 1) {
            return _customSignList.count + 1;
        }
        
        return _inCommonUseSignList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inCommonUseSignList.count == 0) {
        
        return [self addCustomSignCell:tableView cellForRowAtIndexPath:indexPath];
    }else {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            return [self addCustomSignCell:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    NSString *identifier = @"signListManageIdentifier";
    HTBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:HTImage(@"selection")];
        imageView.size = CGSizeMake(21, 20);
        cell.accessoryView = imageView;
        cell.accessoryView.hidden = YES;
    }
    
    if (_inCommonUseSignList.count == 0) {
        cell.textLabel.text = [_customSignList objectAtIndex:indexPath.row];
    }else {
        if (indexPath.section == 0) {
            cell.textLabel.text = [_inCommonUseSignList objectAtIndex:indexPath.row];
        }else {
            cell.textLabel.text = [_customSignList objectAtIndex:indexPath.row - 1];
        }
    }
    
    return cell;
}

- (UITableViewCell *)addCustomSignCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTBaseCell *cell = [[HTBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = HTFont(13.0f);
    cell.textLabel.textColor = [UIColor jt_lightGrayColor];
    cell.imageView.image = HTImage(@"customSign");
    cell.textLabel.text = @"添加自定义状态标签";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HTBaseCell *cell = (HTBaseCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!isEmpty(cell.imageView)) {
        
        AddSignViewController *signView = [[AddSignViewController alloc] init];
        signView.willInsertString = self.willInsertSign;
        [self.navigationController pushViewController:signView animated:YES];
        
    }else  {
        cell.accessoryView.hidden = !cell.accessoryView.hidden;
    }
    
}

- (NSString *)title
{
    return @"状态标签库";
}


@end
