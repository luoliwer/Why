//
//  HuanCunListViewController.h
//  wly
//
//  Created by luolihacker on 16/5/20.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuanCunListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *type; //显示类型（默认显示全部）
@property(nonatomic,strong)NSArray *tempdataArr; //存放过滤后的dataArray
@property (nonatomic, strong) void (^transArray)(NSArray *array);

@end
