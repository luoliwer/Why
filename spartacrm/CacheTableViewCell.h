//
//  CacheTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/5/21.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CacheTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cpName;

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *totalNum;
@property (strong, nonatomic) NSArray *wlmDataArray;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) NSString *typeString; //该Cell的类型（发货，收货，调货发货，调货收货，销售，全部（默认是全部类型））
@end
