//
//  ExpressHelpTableController.m
//  aioa
//
//  Created by hunkzeng on 15/7/28.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ExpressHelpTableController.h"
#import "ExpressDetailTableViewController.h"

@implementation ExpressHelpTableController




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_expressDetailTableViewControllerDelegate modifyNeedHelp:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
