//
//  DaiyaohuoTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/5/3.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaiyaohuoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *idlabel;

@property (strong, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) IBOutlet UILabel *cangkuNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *sendStatusLabel;
@end
