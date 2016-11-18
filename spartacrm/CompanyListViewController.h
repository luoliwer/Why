//
//  CompanyListViewController.h
//  wly
//
//  Created by luolihacker on 15/12/25.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *listData;
@property(strong,nonatomic)UITableViewCell *tableViewCell;

@end
