//
//  ApplyRecordViewController.h
//  wly
//
//  Created by luolihacker on 16/4/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRecordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *recordTable;

@end
