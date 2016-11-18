//
//  BumaModel.h
//  wly
//
//  Created by luolihacker on 16/5/8.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BumaModel : NSObject<NSCoding>
@property(nonatomic, strong)NSString *cpmc; //产品名称
@property(nonatomic, strong)NSString *wlm; //物流码
@end
