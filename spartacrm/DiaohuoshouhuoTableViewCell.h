//
//  DiaohuoshouhuoTableViewCell.h
//  wly
//
//  Created by luolihacker on 16/4/23.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaohuoshouhuoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *diaohuodanhao;
@property (strong, nonatomic) IBOutlet UILabel *diaohuopingtaishang;
@property (strong, nonatomic) IBOutlet UILabel *diaohuodate;
@property (strong, nonatomic) IBOutlet UIImageView *diaohuostate;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *shouquLabel;

@property (strong, nonatomic) NSString *billid;



@end
