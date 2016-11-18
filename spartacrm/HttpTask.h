//
//  HttpTask.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-8.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface HttpTask : NSObject

+(void) verifyLogin:(NSString *) userName
                psw: (NSString *) psw
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 终端直接出货
 */
+ (void)teminalsale:(NSString *)commodityStr
        barcode_ids:(NSString *)barcodeStr
             userid:(NSString *)userid
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 验证收货单位
 */
+ (void)verifyrecevier:(NSString *) userid
           sucessBlock:(void (^)(NSString *))sucessCallback
             failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 验证收货仓库
 */
+ (void)verifyCangKu:(NSString *) userid
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 确认发货
 */
+ (void)verifysendPro:(NSString *) userid
            commodity:(NSString *) commodityStr
          barcode_ids:(NSString *)barcodeStr
          yaohuodanid:(NSString *) yaohuodanid
              vehicle:(NSString *) licenseNum
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 调货发货
 */
+ (void)diaohuofahuo:(NSString *)commodity_ids
         barcode_ids:(NSString *)barcodeStr
              userid:(NSString *)usrid
            cangkuid:(NSString *)cangkuid
           chepaihao:(NSString *)chepaihao
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 确认收货
 */
+ (void)receiveProcCommdity:(NSString *)commodityStr
                     billid:(NSString *)billid
                barcode_ids:(NSString *)barcodeStr
                     userid:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 确认退货
 */
+ (void)sureTuihuo:(NSString *)commodity_ids
       barcode_ids:(NSString *)barcode_ids
            userid:(NSString *)userid
              thdx:(NSString *)tuihuoduixiang
             thzds:(NSString *)tuihuozds
       sucessBlock:(void (^)(NSString *))sucessCallback
         failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 调货收货
 */
+ (void)diaohuoshouhuo:(NSString *)userid
                billid:(NSString *)billid
             commodity:(NSString *)commodity
           barcode_ids:(NSString *)pingmaStr
           sucessBlock:(void (^)(NSString *))sucessCallback
             failBlock:(void (^)(NSDictionary *))failCallback;
/*
 *@brief 补码
 */
+ (void)buma:(NSString *)userid
     wuliuma:(NSString *)wuliuma
      billid:(NSString *)billid
 sucessBlock:(void (^)(NSString *))sucessCallback
   failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 二维码验证
 */
+ (void)verify2DCode:(NSString *) commodity_id
              userid:(NSString *) userid
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 系统更新检测
 */
+ (void)systemUpdateCheck:(NSString *) type
                  version:(NSString *) currentVersion
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback;
/*
 *@brief 收货单数据接口
 */
+ (void)receiveCompanyData:(NSString *)commodity_id
                    userid:(NSString *)userid
               sucessBlock:(void (^)(NSString *))sucessCallback
                 failBlock:(void (^)(NSDictionary *))failCallback;
/*
 *@brief 终端账号审批列表
 */
+ (void)verifyAccountList:(NSString *)userid
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 终端账号审批提交
 */
+ (void)zdzhCommit:(NSString *)userid
            billid:(NSString *)billid
                op:(NSString *)op
       sucessBlock:(void (^)(NSString *))sucessCallback
         failBlock:(void (^)(NSDictionary *))failCallback;
/*
 *@brief 忘记密码
 */
+ (void)forgetPSW:(NSString *)username
        telephone:(NSString *)telnumber
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 拿取版本信息
 */
+(void) getVersion:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 终端账号申请
 */
+(void) accountApply:(NSString *)userid
                name:(NSString *)name
                Type:(NSString *)type
             linkMan:(NSString *)linkMan
               phone:(NSString *)phone
             loginId:(NSString *)loginId
          otherPhone:(NSString *)otherPhone
             address:(NSString *)address
              remark:(NSString *)remark
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 待收货列表接口
 */

+(void) waitreceive:(NSString *)userid
               type:(NSString *)type
        sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 调货收货列表(中转收货列表)
 */
+(void)diaohuoshouhuo:(NSString *)userid
                 type:(NSString *)type
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 调货收货单详细
 */
+(void)diaohuoshouhuoDetail:(NSString *)userid
                     billid:(NSString *)billid
                       type:(NSString *)type
                sucessBlock:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 待发货列表接口
 */
+(void)waitsend:(NSString *)userid
           type:(NSString *)type
    sucessBlock:(void (^)(NSString *))sucessCallback
      failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 待要货列表接口
 */
+(void)waityaohuo:(NSString *)usrid
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 收货之前获取发货单数据接口
 */
+(void) getFahuoData:(NSString *)billid
              userid:(NSString *)userid
                type:(NSString *)type
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 查询平台商的所属终端商
 */
+(void) checkterminal:(NSString *)userid
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;
/*
 *@brief 发货单详细
 */
+(void) getYahuoData:(NSString *)billid
              userid:(NSString *)userid
                type:(NSString *)type
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 调货发货列表
 */
+(void) getDiaohuofahuoList:(NSString *)userid
                       type:(NSString *)type
                sucessBlock:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 增加建议
 */
+(void) suggestionAdd:(NSString *) message
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;
    

/*
 *@brief 修改密码
 */
+ (void)modifyCode:(NSString *)userid
            pswold:(NSString *)pswold
            pswnew:(NSString *)pswnew
       sucessBlock:(void (^)(NSString *))sucessCallback
         failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief setgroup 设置所属用户组
 */
+(void) setgroup:(NSString *) groupId
     sucessBlock:(void (^)(NSString *))sucessCallback
       failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief得到所有用户组
 */

+(void) getAllGroupList:(void (^)(NSString *))sucessCallback
              failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 获取用户信息
 */
+(void) userInfo:(void (^)(NSString *))sucessCallback
       failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief expressList 快递列表
 */
+(void) expressList:(int) pageIndex
           pageSize: (int) pageSize
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief expressList 快递设置帮助
 */
+(void) expressHelp:(int) expressId
           needHelp:(int) needHelp
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 依据名称获取人员列表
 */
+(void) getMembersByName:(NSString *) name
               pageIndex:(int) pageIndex
                pageSize: (int) pageSize
                sucessBlock:(void (^)(NSString *))sucessCallback
               failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief expressList 快递设置代领人
 */
+(void) expressDrawProxyPerson:(int) expressId
                 proxyPersonId: (int) proxyPersonId
                   sucessBlock:(void (^)(NSString *))sucessCallback
                     failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brief expressList 获取快递的详细
 */
+(void) expressDetail:(int) expressId
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief得到所有分类
 */

+(void) getAllOfficeCategoryList:(void (^)(NSString *))sucessCallback
                     failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief得到第一个种类的ID及名称
 */

+(void) getFirstOfficeCategory:(void (^)(NSString *))sucessCallback
                     failBlock:(void (^)(NSDictionary *))failCallback;
    
/*
 *@brief得到指定种类下的办公用品
 */

+(void) getOfficeSupplyList:(int) categoryId
                  pageIndex:(int) pageIndex
           pageSize: (int) pageSize
                sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brief得到一个具体的办公用品信息
 */

+(void) getOfficeSupplyStorage:(int) officeId
                   sucessBlock:(void (^)(NSString *))sucessCallback
                     failBlock:(void (^)(NSDictionary *))failCallback;




/*
 *@brief 依据购物车来生成订单
 */
+(void) createOfficeOrderForCar:(void (^)(NSString *))sucessCallback
                      failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 办公用品订单创建
 */
+(void) createOfficeOrder: (NSString *) officeIds
             counts: (NSString *) counts
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brief 办公订单列表
 */
+(void) officeOrders:(int) pageIndex
         pageSize: (int) pageSize
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;




/*
 *@brief 获取办公订单名细
 */
+(void) officeOrderDetail:(int) orderId
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 获取办公订单名细中产品明细
 */
+(void) officeOrderDetailSupplyList:(int) orderId
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brief 列出所有的购物车里的数据
 */
+(void) listOrderForCar:(void (^)(NSString *))sucessCallback
              failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brie 新增 办公用品购物车数据
 */
+(void) insertToCar: (NSString *) officeId
             count: (NSString *) count
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brie 修改购物车数据
 */
+(void) updateCar: (NSString *) carOrderId
           counts: (NSString *) count
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;




/*
 *@brief 删除购物车数据
 */
+(void) delCar: (NSString *) carOrderId
   sucessBlock:(void (^)(NSString *))sucessCallback
     failBlock:(void (^)(NSDictionary *))failCallback;



/*
 *@brief 订单取消
 */
+(void) cancelOrder:(NSString *) orderNo
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 初始化密码
 */
+(void) initPsw:(NSString *) userName
           name: (NSString *) name
    sucessBlock:(void (^)(NSString *))sucessCallback
      failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 获取验证码
 */
+(void) modifyPsw:(NSString *) strOldPsw
        strNewPsw: (NSString *) strNewPsw
 strNewPswConfirm: (NSString *) strNewPswConfirm
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 修改密码
 */
+(void) changePsw: (NSString *)username
             code: (NSString *)code
           newpsw: (NSString *)newpsw
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 创建用户
 */
+(void) regsiter:(NSString *) userName
             sex:(NSString *) sex
        cardType:(NSString *) cardType
          cardNo:(NSString *) cardNo
          mobile:(NSString *) mobile
            name:(NSString *) name
           email:(NSString *) email
        password:(NSString *) password
     captchaCode:(NSString *) captchaCode
     sucessBlock:(void (^)(NSString *))sucessCallback
       failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 身份证上传
 */
+(void) uploadIcCard:(NSString *) data
        type: (NSString *) type
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback;

/*
 *@brief 获取注册协议内容
 */
+(void) getRegisterProtocol:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 绑定百度云
 */
+(void) bindBPush : (NSString *) deviceType
        channelid: (NSString *) channelid
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 解绑百度云
 */
+(void) unbindBPush : (NSString *) deviceType
         channelid: (NSString *) channelid
       sucessBlock:(void (^)(NSString *))sucessCallback
         failBlock:(void (^)(NSDictionary *))failCallback;


/*
 *@brief 终端开发商账号申请列表
 */
+(void) terminalList:(NSString *)userid
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback;

@end



