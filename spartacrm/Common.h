//
//  common.h
//  spartacrm
//
//  Created by hunkzeng on 14-5-8.
//  Copyright (c) 2014年 vojo. All rights reserved.
//


//定义UIColorFromRGB
#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGB(_r, _g, _b, _a) [UIColor colorWithRed:_r/255.0 green:_g/255.0 blue:_b/255.0 alpha:_a]

//字体大小
#define K_FONT_48 [UIFont systemFontOfSize:48]
#define K_FONT_20 [UIFont systemFontOfSize:20]
#define K_FONT_18 [UIFont systemFontOfSize:18]
#define K_FONT_16 [UIFont systemFontOfSize:16]
#define K_FONT_15 [UIFont systemFontOfSize:15]
#define K_FONT_14 [UIFont systemFontOfSize:14]
#define K_FONT_13 [UIFont systemFontOfSize:13]
#define K_FONT_11 [UIFont systemFontOfSize:11]


#endif


//定义屏幕高度
#ifndef HEIGHT
    #define HEIGHT [UIScreen mainScreen].bounds.size.height
#endif


//定义屏幕宽度
#ifndef WIDTH
    #define WIDTH [UIScreen mainScreen].bounds.size.width
#endif

/**
 *	@brief	定义是否是生产环境  生产环境为1 测试环境为0
 */
#define IS_PRODUCT_EVN 1

#if IS_PRODUCT_EVN == 1
 //生产环境的相关参数设置
    #define REMOTE_URL @"http://218.89.67.45:18080"
    #define REMOTE_WS_URL @"http://218.89.67.45:18080/ws/rest"
    
#else
  //测试环境的相关参数设置
  #define REMOTE_URL @"http://127.0.0.1:8080"
  #define REMOTE_WS_URL @"http://127.0.0.1:8080/ws/rest"

//  #define REMOTE_URL @"http://192.168.0.113:8080"
//  #define REMOTE_WS_URL @"http://192.168.0.113:8080/ws/rest"

#endif


/**
 *	@brief	列表更新状态
 */
typedef NS_ENUM(NSInteger, ListUpdatePolicy){
    ListUpdatePolicyRefresh = 1,  //!<下拉
    ListUpdatePolicyNextPage = 2  //!<上拉
};



/**
 *	@brief	订单查询类型
 */
typedef NS_ENUM(NSInteger, SearchType){
    SearchTypeNone = 0,  //!<无查询条件
    SearchTypeOrderNO = 1,  //!<订单编号
    SearchTypeHotelName = 2,  //!<酒店名称
    SearchTypeMettingName = 3  //!<会议名称
};




/**
 *	@brief	预订类型
 */
typedef NS_ENUM(NSInteger, OrderType){
    OrderTypeHotel = 0,  //!<无查询条件
    OrderTypeFood = 1,  //!<订单编号
};













