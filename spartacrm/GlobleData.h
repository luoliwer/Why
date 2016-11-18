//
//  GlobleData.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-10.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobleData : NSObject
    + (GlobleData *) sharedInstance;

    @property(nonatomic,strong) NSDictionary *userInfo;  //!<用户信息
    @property(nonatomic,strong) NSString *BPush_ChannelId;  //!<百度云推送ChannelId
    @property(nonatomic,strong) NSString *usrName;
    @property(nonatomic,strong) NSString *userType;
    @property(nonatomic,strong) NSString *companyName; //
    @property(nonatomic,strong) NSString *receiveCompanyName; //发货单页面收货公司的名字
    @property(nonatomic,strong) NSString *receiveCompanyId; //发货单页面收货公司的Id
    @property(nonatomic,strong) NSString *psw;
    @property(nonatomic,strong) NSString *userid; //用户的userid
    @property(nonatomic,strong) NSMutableArray *receivecompanyList; //发货单页面收货单位公司列表
    @property(nonatomic,strong) NSMutableArray *receivecangKuList; //发货单位页面收货仓库列表
    @property(nonatomic,strong) NSDictionary *companyInfo;
    @property(nonatomic,strong) NSString *singleCommdity; //点击扫描进入收货单页面的验证码
    @property(nonatomic,strong) NSMutableArray *listData; //扫描得到的二维码
    @property(nonatomic,strong) NSNumber *check2DCodeIsSuccessful; //验证二维码是否成功
    @property(nonatomic,strong) NSString *whenForegetPswUsername; //当用户忘记密码做忘记密码处理时填写的用户名
    @property(nonatomic,strong) NSArray *companyListArray; //收货单位信息数组
    @property(nonatomic,strong) NSArray *cangKuListArray; //收货仓库信息数组
    @property(nonatomic,strong) NSString *num; //收货总量
    @property(nonatomic,strong) NSString *pingCount; //瓶数
    @property(nonatomic,strong) NSString *productName; //货物名称

    @property(nonatomic,strong) NSString *typeName; //终端账号申请所需的类型名
    @property(nonatomic,assign) BOOL issendBtn; //是销售终端直接发货
    @property(nonatomic,assign) BOOL isPhoneScanToScanView; //销售终端收货:从手机扫描页面跳转到ScanViewController
    @property(nonatomic,assign) BOOL isDidGet; //判断是否货物已收
    @property(nonatomic,assign)BOOL isDidSend; //判断是否货物已发
    @property(nonatomic,assign) BOOL ischeck; //判断是不是溯源查询按钮
    @property(nonatomic,assign) BOOL isMiddleSendBtn; //判断是否是由中转发货按钮进入的收货单
    @property(nonatomic,assign) BOOL isPostOrGet; // 判断是Post请求还是Get请求
    @property(nonatomic,assign) BOOL isNormalCode; // 判断是不是正常码

    @property(nonatomic,assign) BOOL clickScanGunFaHuoBtn; // 判断是不是点击扫描枪按钮进入的发货扫描页面
    @property(nonatomic,strong) NSString *daishouhuoCommodity_id;
    @property(nonatomic,assign) BOOL isdiaohuofahuocommodity; //由调货收货列表进入收货单页面
    @property(nonatomic,strong) NSMutableArray *appArray; // 要显示的app
    @property(nonatomic,strong) NSString *type; // 传递的参数类型，（已收，未收，已发，未发）
    @property(nonatomic,strong) NSString *billid; //调货发货列表要传到调货发货单详细的参数
    @property(nonatomic,assign) BOOL isDiaohuoshouhuoBtn;//判断是不是点击的调货收货按钮
    @property(nonatomic,strong) NSString *shouhuocomdities; //收货批量物流码
    @property(nonatomic,strong) NSString *chePaiHao;//发货的时候需要填写的车牌号


// 收货发货类型
 @property(nonatomic,strong) NSString *dealtype; //(发货（0），调货发货（1），收货（2），调货收货（3），销售（4），离线缓存(5) ，退货(6)

// 要存储的发货信息
    @property(nonatomic,strong) NSString *fahuoJSON; //发货JSON串
    @property(nonatomic,strong) NSString *fahuobillid; //发货billid;

// 要存储的调货发货信息
    @property(nonatomic,strong) NSString *diaohuofahuobillid; //调货发货billid

// 收货要存储的信息
    @property(nonatomic,strong) NSString *shouhuoJSON; //收货JSON串
    @property(nonatomic,strong) NSString *shouhuobillid; //收货billid

// 调货收货billid
    @property(nonatomic,strong) NSString *diaohuoshouhuoJSON; //调货收货JSON串
    @property(nonatomic,strong) NSString *diaohuoshuohuobillid; //调货收货billid
@end
