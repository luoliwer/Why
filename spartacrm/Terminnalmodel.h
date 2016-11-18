//
//  Terminnalmodel.h
//  wly
//
//  Created by luolihacker on 16/4/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Terminnalmodel : NSObject

@property(nonatomic, strong) NSString *billid; //单据id
@property(nonatomic, strong) NSString *createDate; //创建时间
@property(nonatomic, strong) NSString *terminalName; //终端商名称
@property(nonatomic, strong) NSString *teleNum; //电话号码
@property(nonatomic, strong) NSString *address; //地址
@property(nonatomic, strong) NSString *terminalType; //终端商类型
@property(nonatomic, strong) NSString *status; //通过状态
@property(nonatomic, strong) NSString *pingtaiName; //所属平台商名称
@property(nonatomic, strong) NSString *linkMan; // 联系人
@end
