//
//  daiShouhuoCell.h
//  wly
//
//  Created by luolihacker on 16/1/24.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface daiShouhuoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dingDanLabel;

@property (strong, nonatomic) IBOutlet UILabel *pingTaiLabel;

@property (strong, nonatomic) IBOutlet UIImageView *shouQuImg;

@property (strong, nonatomic) IBOutlet UILabel *shouQuLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIView *backGroundView;

@property (strong, nonatomic) NSString *commodity_id;

@property (assign, nonatomic) BOOL isDidGet;

@end
