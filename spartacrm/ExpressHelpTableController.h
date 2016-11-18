//
//  ExpressHelpTableController.h
//  aioa
//
//  Created by hunkzeng on 15/7/28.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressDetailTableViewController.h"

@interface ExpressHelpTableController : UITableViewController
@property (weak, nonatomic)  id <ExpressDetailTableViewControllerDelegate>  expressDetailTableViewControllerDelegate;
@end
