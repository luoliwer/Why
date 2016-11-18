//
//  VJUtil.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-11.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VJUtil : NSObject

 
//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;




/*
 * @brief 做扫描处理
 * @param commodityCode 扫描的字符串
 * @param dicDetailList 服务端传进来的json对象
 * @param nowNumberArray 扫描过的数量
 * @return dic{
 
 }*/

+ (NSMutableDictionary *) checkCommodityCode:commodityCode  dicDetailList:dicDetailList;



/*
 * @brief 做销售处理
 * @param commodityCode 扫描的字符串
 * @return dic{
 
 }*/

+ (NSDictionary *) saleCommodityCode:commodityCode;




/*
 * @brief 做删除处理
 * @param commodityCode 扫描的字符串
 * @param dicDetailList 服务端传进来的json对象
 * @param nowNumberArray 扫描过的数量
 * @return dic{
 
 }*/

+ (NSDictionary *) delCommodityCode:commodityCode  dicDetailList:dicDetailList;

@end
