//
//  TerminalListViewController.h
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TerminalModel.h"

@interface TerminalListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSMutableArray *listArray;
@property (nonatomic, strong) void (^transValue)(TerminalModel *terminalModel);

@end
