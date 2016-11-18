//
//  DiaohuoshouhuoViewController.h
//  wly
//
//  Created by luolihacker on 16/4/23.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaohuoshouhuoTableViewCell.h"

@interface DiaohuoshouhuoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end
