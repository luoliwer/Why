//
//  TuihuoChoiceListViewController.h
//  wly
//
//  Created by luolihacker on 16/6/6.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuihuoChoiceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *listArray;
@property (nonatomic, strong) void (^transValue)(NSString *typeString);

@end
