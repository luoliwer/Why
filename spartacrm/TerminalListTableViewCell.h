//
//  TerminalListTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/4/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminalListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *billIdLabel;

@property (strong, nonatomic) IBOutlet UILabel *zdsNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) IBOutlet UILabel *teleLabel;

@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *stateImage;
@property (strong, nonatomic) IBOutlet UIView *backView;
@end
