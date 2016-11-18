//
//  ChoiceListViewController.h
//  wly
//
//  Created by luolihacker on 16/5/21.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *listArray;
@property (nonatomic, strong) void (^transValue)(NSString *typeString);
@end
