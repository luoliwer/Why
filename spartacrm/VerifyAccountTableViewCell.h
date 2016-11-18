//
//  VerifyAccountTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyAccountTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *terminalNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *terminalTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkManLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *showSuccessLabel;

@end
