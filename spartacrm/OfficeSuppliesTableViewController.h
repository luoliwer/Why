//
//  OfficeSuppliesTableViewController.h
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ListTableViewController.h"


@protocol OfficeSuppliesTableViewControllerDelegate <NSObject>
    -(void) modifyCate:(NSString *) strCateId cateName:(NSString *) strCateName;
    -(void)loadData;
@end



@interface OfficeSuppliesTableViewController: ListTableViewController<OfficeSuppliesTableViewControllerDelegate>
    @property (strong, nonatomic) IBOutlet UILabel *lblType;
    @property (strong, nonatomic) IBOutlet UITableView *table;

    @property (weak, nonatomic)  NSString *catId;
    @property (weak, nonatomic)  NSString *catName;

@end
