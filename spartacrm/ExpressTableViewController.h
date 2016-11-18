//
//  NewsTableViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-6.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "ListTableViewController.h"
//@protocol ExpressTableViewControllerDelegate <NSObject>
//-(void) changeState:(NSString *) expressId;
//@end

@interface ExpressTableViewController : ListTableViewController
    @property (strong, nonatomic) IBOutlet UITableView *table;
    
@end
