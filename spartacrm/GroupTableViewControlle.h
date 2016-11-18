//
//  CategoryTableViewController.h
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ListTableViewController.h"
#import "AccountViewController.h"

@interface GroupTableViewController : ListTableViewController
  @property (weak, nonatomic)  id <AccountControllerDelegate>  accountControllerDelegate;
 @property (strong, nonatomic) IBOutlet UITableView *table;
@end
