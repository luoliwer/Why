//
//  Daishouhuo.h
//  wly
//
//  Created by luolihacker on 16/4/19.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Daishouhuo : NSObject
@property(nonatomic,copy) NSString *status; //已收未收
@property(nonatomic,copy) NSString *describe; //机构名称
@property(nonatomic,copy) NSString *ordername; //订单号
@property(nonatomic,copy) NSString *commodity_id; //收货单id
@property(nonatomic,copy) NSString *createDate; //创建时间
@end
