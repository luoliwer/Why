//
//  AccountManagerViewController.h
//  wly
//
//  Created by luolihacker on 15/12/15.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManagerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) UITableView *tableView;
@end
