//
//  MemberSearchTableViewController.h
//  aioa
//
//  Created by hunkzeng on 15/7/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ListTableViewController.h"
#import "ExpressDetailTableViewController.h"

@interface MemberSearchTableViewController : ListTableViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic)  id <ExpressDetailTableViewControllerDelegate>  expressDetailTableViewControllerDelegate;

@end
