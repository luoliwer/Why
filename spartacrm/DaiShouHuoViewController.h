//
//  DaiShouHuoViewController.h
//  wly
//
//  Created by luolihacker on 16/1/24.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "daiShouhuoCell.h"

@interface DaiShouHuoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end
