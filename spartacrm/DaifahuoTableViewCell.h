//
//  DaifahuoTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/5/4.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaifahuoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *stateImgView;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) NSString *billid;
@end
