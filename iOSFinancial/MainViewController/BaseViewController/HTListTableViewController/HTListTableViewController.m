//
//  HTListTableViewController.m
//  iOSFinancial
//
//  Created by Mr.Yang on 15/4/1.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "HTListTableViewController.h"

@implementation HTListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self attachTableView];
    
    
}

- (void)attachTableView
{
    self.tableView.delegate = self.tableControl;
    self.tableView.dataSource = self.tableControl;
    
    [self.tableControl registTableView:self.tableView];
}

- (HTBaseTableControl *)tableControl
{
    if (!_tableControl) {
        _tableControl = [[[self tableControlClass] alloc] init];
    }
    
    return _tableControl;
}

- (Class)tableControlClass
{
    return [HTBaseTableControl class];
}

@end
