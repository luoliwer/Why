//
//  ProductTableViewCell.h
//  wly
//
//  Created by luolihacker on 15/12/17.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ProName;
@property (strong, nonatomic) IBOutlet UILabel *nongDuLabel;
@property (strong, nonatomic) IBOutlet UILabel *guiGeLabel;
@property (strong, nonatomic) IBOutlet UILabel *danWeiLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@end
