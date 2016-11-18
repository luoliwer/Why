//
//  OrderDetailTableViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-7-2.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTableViewController :  UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)  NSString *orderId;

- (IBAction)btnCancelClick:(id)sender;
@end
