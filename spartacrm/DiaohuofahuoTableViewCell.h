//
//  DiaohuofahuoTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/5/5.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaohuofahuoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *backview;
@property (strong, nonatomic) IBOutlet UILabel *billidLabel;
@property (strong, nonatomic) IBOutlet UILabel *ptsNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *stateImgView;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;
@property (strong, nonatomic) NSString *billid;

@end
