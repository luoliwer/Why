//
//  ChoiceViewController.h
//  wly
//
//  Created by luolihacker on 16/2/2.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoiceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *listArray;
@end
