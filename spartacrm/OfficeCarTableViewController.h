//
//  OfficeCarTableViewController.h
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ListTableViewController.h"

@interface OfficeCarTableViewController : ListTableViewController
- (IBAction)btnDelCarOrder:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *table;
@end
