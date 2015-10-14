//
//  MineViewController.m
//  XianLife
//
//  Created by Mr.Yan on 15/10/13.
//  Copyright © 2015年 Mr.Yan. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()


@end

@implementation MineViewController


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell.imageView.image = [UIImage imageNamed:@"my_Recharge@2x"];
                    cell.textLabel.text = @"余额";
                }
                    break;
                case 1:
                {
                    cell.imageView.image = [UIImage imageNamed:@"yzh@2x"];
                    cell.textLabel.text = @"云账户理财";
                }
                    break;
                case 2:
                {
                    cell.imageView.image = [UIImage imageNamed:@"my_address2@2x.png"];
                    cell.textLabel.text = @"地址管理";
                    
                }
                    break;
                case 3:
                {
                    cell.imageView.image = [UIImage imageNamed:@"my_coupon@2x"];
                    cell.textLabel.text = @"优惠券";
                    
                }
                    break;
                case 4:
                {
                    cell.imageView.image = [UIImage imageNamed:@"my_message@2x"];
                    cell.textLabel.text = @"我的消息";
                    
                }
                    break;
                default:
                    
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.textLabel.text = @"4000-121-777";
            cell.textLabel.textColor = [UIColor orangeColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
}


@end
