//
//  ExpressSignViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/28.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ExpressSignViewController.h"
#import "UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "Common.h"
#import "SAMHUDView/SAMHUDView/SAMHUDView.h"

@implementation ExpressSignViewController
-(void) viewDidLoad{
    NSString * imgStr=[NSString stringWithFormat:@"%@",_signImgUrl];
    NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
   [_signImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:imgCacheName]];
    
}
@end
