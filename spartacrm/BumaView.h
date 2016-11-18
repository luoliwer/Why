//
//  BumaView.h
//  wly
//
//  Created by luolihacker on 16/5/8.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BumaView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *bumaTable;
@property(nonatomic,strong)NSMutableArray *dataArr;
@end
