//
//  HttpTask.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-8.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "HttpTask.h"
#import "ASIHTTPRequest.h"
#import "Common.h"
#import "ASIFormDataRequest.h"

@implementation HttpTask

+(void) doGetToServer:(NSString *) remoteStr
            needToken:(BOOL) needToken
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaultes stringForKey:@"usr.token"];
    NSString *jsessionid = [userDefaultes stringForKey:@"usr.jsessionid"];
    
    
    if (needToken) {
            
        if ([remoteStr rangeOfString:@"?"].length == 0) {
            remoteStr=[NSString stringWithFormat:@"%@?token=%@&jsessionid=%@",remoteStr,token,jsessionid];
        } else  {
            remoteStr=[NSString stringWithFormat:@"%@&token=%@&jsessionid=%@",remoteStr,token,jsessionid];
        }
    }
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    NSLog(@"请求远程地址为:%@",[remoteUrl absoluteString]);
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"GET"];
    [request setShouldAttemptPersistentConnection:NO];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        
        
        if (failCallback) {
            failCallback([error userInfo]);
        }
        [[[UIAlertView alloc]initWithTitle:@"提示"
                                   message:[[error userInfo]  objectForKey:@"NSLocalizedDescription"]
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
    }];
    
    [request startAsynchronous];
}


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
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/register",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:userName forKey:@"username"];
    [request addPostValue:sex forKey:@"sex"];
    [request addPostValue:cardType forKey:@"cardType"];
    [request addPostValue:cardNo forKey:@"cardNo"];
    [request addPostValue:mobile forKey:@"mobile"];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:email forKey:@"email"];
    [request addPostValue:password forKey:@"password"];
    [request addPostValue:password forKey:@"password"];
    [request addPostValue:captchaCode forKey:@"captchaCode"];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
    
    }];
    [request startAsynchronous];
}

/*
 *@brief 终端账号申请
 */
+ (void)accountApply:(NSString *)userid name:(NSString *)name Type:(NSString *)type linkMan:(NSString *)linkMan phone:(NSString *)phone loginId:(NSString *)loginId otherPhone:(NSString *)otherPhone address:(NSString *)address remark:(NSString *)remark sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/applyAccount",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:userid forKey:@"userid"];
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:type forKey:@"type"];
    [request addPostValue:linkMan forKey:@"linkMan"];
    [request addPostValue:phone forKey:@"phone"];
    [request addPostValue:loginId forKey:@"loginid"];
    [request addPostValue:otherPhone forKey:@"qtdh"];
    [request addPostValue:address forKey:@"address"];
    [request addPostValue:remark forKey:@"remark"];
    
    [request setShouldAttemptPersistentConnection:NO];
    
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];
}

/*
 *@brief 确认发货
 */
+(void)verifysendPro:(NSString *)userid commodity:(NSString *)commodityStr barcode_ids:(NSString *)barcodeStr yaohuodanid:(NSString *)yaohuodanid vehicle:(NSString *)licenseNum sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/faHuo",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    [request addPostValue:userid forKey:@"userid"];
    [request addPostValue:yaohuodanid forKey:@"yaohuodanid"];
    [request addPostValue:commodityStr forKey:@"commodity_ids"];
    [request addPostValue:barcodeStr forKey:@"barcode_ids"];
    [request addPostValue:licenseNum forKey:@"vehicle_id"];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];
}

/*
 *@brief 调货发货
 */
+(void)diaohuofahuo:(NSString *)commodity_ids barcode_ids:(NSString *)barcodeStr userid:(NSString *)usrid cangkuid:(NSString *)cangkuid chepaihao:(NSString *)chepaihao sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/diaoHuoFaHuo",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    
    [request setRequestMethod:@"POST"];
    [request addPostValue:barcodeStr forKey:@"barcode_ids"];
    [request addPostValue:commodity_ids forKey:@"commodity_ids"];
    [request addPostValue:usrid forKey:@"userid"];
    [request addPostValue:cangkuid forKey:@"franchiser_id"];
    [request addPostValue:chepaihao forKey:@"vehicle_id"];
    
    [request setShouldAttemptPersistentConnection:NO];
    
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];
}
/*
 *@brief 确认收货
 */
+ (void)receiveProcCommdity:(NSString *)commodityStr
                     billid:(NSString *)billid
                barcode_ids:(NSString *)barcodeStr
                     userid:(NSString *)userid
                sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getFaHuoDanByCommodityCodes",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    [request addPostValue:commodityStr forKey:@"commodity_ids"];
    [request addPostValue:billid forKey:@"billid"];
    [request addPostValue:barcodeStr forKey:@"barcode_ids"];
    [request addPostValue:userid forKey:@"userid"];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];

}

/*
 *@brief 确认退货
 */
+ (void)sureTuihuo:(NSString *)commodity_ids barcode_ids:(NSString *)barcode_ids userid:(NSString *)userid thdx:(NSString *)tuihuoduixiang thzds:(NSString *)tuihuozds sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void(^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/tuiHuo",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    [request addPostValue:commodity_ids forKey:@"commodity_ids"];
    [request addPostValue:barcode_ids forKey:@"barcode_ids"];
    [request addPostValue:userid forKey:@"userid"];
    [request addPostValue:tuihuoduixiang forKey:@"thdx"];
    [request addPostValue:tuihuozds forKey:@"thzds"];
    
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];
}

/*
 *@brief 调货收货
 */
+ (void)diaohuoshouhuo:(NSString *)userid billid:(NSString *)billid commodity:(NSString *)commodity barcode_ids:(NSString *)pingmaStr sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback
{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/diaoHuoShouHuo",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    
    [request setRequestMethod:@"POST"];
    [request addPostValue:userid forKey:@"userid"];
    [request addPostValue:billid forKey:@"diaoHuoDanBillid"];
    [request addPostValue:commodity forKey:@"commodity_ids"];
    [request addPostValue:pingmaStr forKey:@"barcode_ids"];
    
    [request setShouldAttemptPersistentConnection:NO];
    
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];

}
/*
 *@brief 补码
 */
+(void)buma:(NSString *)userid wuliuma:(NSString *)wuliuma billid:(NSString *)billid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/yunShuBuMaAjax",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    request.timeOutSeconds = 100;
    [request setRequestMethod:@"POST"];
    [request addPostValue:userid forKey:@"userid"];
    [request addPostValue:billid forKey:@"billid"];
    [request addPostValue:wuliuma forKey:@"wlm"];
    
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
    }];
    [request startAsynchronous];

}

/*
 *@brief suggestionAdd 增加意见与反馈
 */
+(void) getVersion:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/version?type=1",REMOTE_WS_URL];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief suggestionAdd 增加意见与反馈
 */
+(void) suggestionAdd:(NSString *) message
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/suggestionAdd",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:message forKey:@"message"];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
        
        
    }];
    
    
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        
        
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
        
    }];
    
    [request startAsynchronous];

}



/*
 *@brief 获取注册协议内容
 */
+(void) getRegisterProtocol:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getRegisterProtocol",REMOTE_WS_URL];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
    
}



/*
 *@brief 用户登录
 */
+(void) verifyLogin:(NSString *) userName
                psw:(NSString *) psw
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/verify?username=%@&password=%@",REMOTE_WS_URL,userName,psw];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
    
}


/*
 *@brief 终端直接出货
 */
+ (void)teminalsale:(NSString *)commodityStr barcode_ids:(NSString *)barcodeStr userid:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/chuShou?userid=%@&commodity_ids=%@&barcode_ids=%@",REMOTE_WS_URL,userid,commodityStr,barcodeStr];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 验证收货单位
 */
+ (void)verifyrecevier:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getFaHuoDanWei?userid=%@",REMOTE_WS_URL,userid];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 验证收货仓库
 */
+ (void)verifyCangKu:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getCangKu?userid=%@",REMOTE_WS_URL,userid];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 修改密码
 */
+ (void)modifyCode:(NSString *)userid pswold:(NSString *)pswold pswnew:(NSString *)pswnew sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/passwordEdit?userid=%@&passwordold=%@&passwordnew=%@",REMOTE_WS_URL,userid,pswold,pswnew];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 收货单位数据接口
 */
+ (void)receiveCompanyData:(NSString *)commodity_id userid:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getFaHuoDan?commodity_id=%@&userid=%@",REMOTE_WS_URL,commodity_id,userid];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 二维码验证
 */
+ (void)verify2DCode:(NSString *)commodity_id userid:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/checkCommodityCode?commodity_id=%@&userid=%@",REMOTE_WS_URL,commodity_id,userid];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 系统更新检测
 */
+ (void)systemUpdateCheck:(NSString *)type version:(NSString *)currentVersion sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *urlString = @"http://wly.zuolema.cn/ws/rest";
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/version?type=%@&version=%@",urlString,type,currentVersion];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 忘记密码
 */
+(void)forgetPSW:(NSString *)username telephone:(NSString *)telnumber sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/forgetpsw1?telnetphone=%@&username=%@",REMOTE_WS_URL,username,telnumber];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 获取用户信息
 */
+(void) userInfo:(void (^)(NSString *))sucessCallback
failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/userInfo",REMOTE_WS_URL];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 待收货列表接口
 */
+(void) waitreceive:(NSString *)userId
               type:(NSString *)type
            sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getDaiShouHuo?userid=%@&type=%@",REMOTE_WS_URL,userId,type];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 调货收货列表(中转收货列表)
 */
+(void) diaohuoshouhuo:(NSString *)userid
                  type:(NSString *)type sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getDiaoHuoDaiShouHuoList?userid=%@&type=%@",REMOTE_WS_URL,userid,type];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}
/*
 *@brief 调货收货单详细
 */
+(void)diaohuoshouhuoDetail:(NSString *)userid billid:(NSString *)billid type:(NSString *)type sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getDiaoHuoBillDetails?userid=%@&type=%@&billid=%@",REMOTE_WS_URL,userid,type,billid];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 待发货列表接口
 */
+(void) waitsend:(NSString *)userid
            type:(NSString *)type
     sucessBlock:(void (^)(NSString *))sucessCallback
       failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getyaohuo?userid=%@&type=%@",REMOTE_WS_URL,userid,type];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 待要货列表接口
 */
+(void) waityaohuo:(NSString *)usrid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString *remoteStr = [NSString stringWithFormat:@"%@/phone/getZDYHDList?userid=%@",REMOTE_WS_URL,usrid];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 收货之前获取发货单数据接口
 */
+(void)getFahuoData:(NSString *)billid userid:(NSString *)userid type:(NSString*)type sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getFaHuoDan?billid=%@&userid=%@&type=%@",REMOTE_WS_URL,billid,userid,type];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
    
}

/*
 *@brief 调货发货列表
 */
+(void)getDiaohuofahuoList:(NSString *)userid type:(NSString *)type sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getDiaoHuoFaHuoList?type=%@&userid=%@",REMOTE_WS_URL,type,userid];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 发货单详细
 */
+(void)getYahuoData:(NSString *)billid
             userid:(NSString *)userid
               type:(NSString *)type
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getyaohuoinfo?billid=%@&userid=%@&type=%@",REMOTE_WS_URL,billid,userid,type];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief setgroup 设置所属用户组
 */
+(void) setgroup:(NSString *) groupId
     sucessBlock:(void (^)(NSString *))sucessCallback
       failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/setgroup?groupId=%@",REMOTE_WS_URL,groupId];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 终端账号审批列表
 */
+(void)verifyAccountList:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr=[NSString stringWithFormat:@"%@/phone/getZhongDuanRegistSPList?userid=%@",REMOTE_WS_URL,userid];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 查询平台商的所属终端商
 */
+(void)checkterminal:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr=[NSString stringWithFormat:@"%@/phone/getZhongDuanShangByPts?userid=%@",REMOTE_WS_URL,userid];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}
/*
 *@brief 终端账号审批提交
 */
+ (void)zdzhCommit:(NSString *)userid billid:(NSString *)billid op:(NSString *)op sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString *remoteStr=[NSString stringWithFormat:@"%@/phone/zhongDuanIDop?userid=%@&billid=%@&op=%@",REMOTE_WS_URL,userid,billid,op];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}
/*
 *@brief得到所有用户组
 */

+(void) getAllGroupList:(void (^)(NSString *))sucessCallback
              failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getAllGroupList",REMOTE_WS_URL];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
    
}


/*
 *@brief 初始化密码
 */
+(void) initPsw:(NSString *) userName
        name: (NSString *) name
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/initPsw?userName=%@&name=%@",REMOTE_WS_URL,userName,name];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief 获取验证码
 */
+(void) modifyPsw:(NSString *) strOldPsw
        strNewPsw: (NSString *) strNewPsw
 strNewPswConfirm: (NSString *) strNewPswConfirm
      sucessBlock:(void (^)(NSString *))sucessCallback
        failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/updatePassword?oldPassword=%@&newPassword=%@&newPassword2=%@",REMOTE_WS_URL,strOldPsw,strNewPsw,strNewPswConfirm];
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 修改密码
 */
+(void)changePsw:(NSString *)username code:(NSString *)code newpsw:(NSString *)newpsw sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/forgetpsw2?username=%@&code=%@&newpsw=%@",REMOTE_WS_URL,username,code,newpsw];
    [self doGetToServer:remoteStr needToken:NO sucessBlock:sucessCallback failBlock:failCallback];
}
/*
 *@brief expressList 快递列表
 */
+(void) expressList:(int) pageIndex
           pageSize: (int) pageSize
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/expressList?pageIndex=%d&pageSize=%d&moduleType=member&innerCode=",REMOTE_WS_URL,pageIndex,pageSize];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief expressHelp 快递设置帮助
 */
+(void) expressHelp:(int) expressId
           needHelp:(int) needHelp
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/expressHelp?expressId=%d&needHelp=%d",REMOTE_WS_URL,expressId,needHelp];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}



/*
 *@brief 依据名称获取人员列表
 */
+(void) getMembersByName:(NSString *) name
               pageIndex:(int) pageIndex
                pageSize: (int) pageSize
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback{
    
    
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getMembersByName",REMOTE_WS_URL];
    remoteStr = [remoteStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * remoteUrl = [NSURL URLWithString:remoteStr];
    
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:remoteUrl];
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:name forKey:@"name"];
    [request addPostValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
    [request addPostValue:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setCompletionBlock:^{
        NSString * responseStr = [request responseString];
        NSLog(@"接收到的服务器端的数据为:%@",responseStr);
        
        if (sucessCallback) {
            sucessCallback(responseStr);
        }
        
        
    }];
    
    
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"服务器读取数据失败 原因:%@", [error userInfo]);
        
        
        if (failCallback) {
            failCallback([error userInfo]);
        }
        
        
    }];
    
    [request startAsynchronous];
    
}




/*
 *@brief expressList 快递设置代领人
 */
+(void) expressDrawProxyPerson:(int) expressId
                      proxyPersonId: (int) proxyPersonId
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/expressDrawProxyPerson?expressId=%d&proxyPersonId=%d",REMOTE_WS_URL,expressId,proxyPersonId];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief expressList 获取快递的详细
 */
+(void) expressDetail:(int) expressId
          sucessBlock:(void (^)(NSString *))sucessCallback
            failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/expressDetail?expressId=%d",REMOTE_WS_URL,expressId];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}


/*
 *@brief 依据购物车来生成订单
 */
+(void) createOfficeOrderForCar:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/createOfficeOrderForCar",REMOTE_WS_URL];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}



/*
 *@brief 办公用品订单创建
 */
+(void) createOfficeOrder: (NSString *) officeIds
                   counts: (NSString *) counts
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/createOfficeOrder?officeIds=%@&counts=%@",REMOTE_WS_URL,officeIds,counts];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief得到所有办公用品分类
 */

+(void) getAllOfficeCategoryList:(void (^)(NSString *))sucessCallback
                       failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getAllOfficeCategoryList",REMOTE_WS_URL];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];

}




/*
 *@brief得到第一个种类的ID及名称
 */

+(void) getFirstOfficeCategory:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getFirstOfficeCategory",REMOTE_WS_URL];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}


/*
 *@brief得到指定种类下的办公用品
 */

+(void) getOfficeSupplyList:(int) cateId
                  pageIndex:(int) pageIndex
                   pageSize: (int) pageSize
                sucessBlock:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getOfficeSupplyList?cateId=%d&pageIndex=%d&pageSize=%d",REMOTE_WS_URL,cateId,pageIndex,pageSize];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}



/*
 *@brief得到一个具体的办公用品信息
 */

+(void) getOfficeSupplyStorage:(int) officeId
                   sucessBlock:(void (^)(NSString *))sucessCallback
                  failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getOfficeSupplyStorage?officeId=%d",REMOTE_WS_URL,officeId];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief 列出所有的购物车里的数据
 */
+(void) listOrderForCar:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/listOrderForCar",REMOTE_WS_URL];
    
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}



/*
 *@brie 新增 办公用品购物车数据
 */
+(void) insertToCar: (NSString *) officeId
             count: (NSString *) count
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/insertToCar?officeId=%@&count=%@",REMOTE_WS_URL,officeId,count];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}


/*
 *@brie 修改购物车数据
 */
+(void) updateCar: (NSString *) carOrderId
             counts: (NSString *) count
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/updateCar?carOrderId=%@&count=%@",REMOTE_WS_URL,carOrderId,count];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}






/*
 *@brief 删除购物车数据
 */
+(void) delCar: (NSString *) carOrderId
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/delCar?carOrderId=%@",REMOTE_WS_URL,carOrderId];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief 办公订单列表
 */
+(void) officeOrders:(int) pageIndex
            pageSize: (int) pageSize
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback{
    
      NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/officeOrders?pageIndex=%d&pageSize=%d&moduleType=member&orderNo=",REMOTE_WS_URL,pageIndex,pageSize];
  
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}




/*
 *@brief 获取办公订单名细
 */
+(void) officeOrderDetail:(int) orderId
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/officeOrderDetail?orderId=%d",REMOTE_WS_URL,orderId];
    
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}



/*
 *@brief 获取办公订单名细中的办公用品明细
 */
+(void) officeOrderDetailSupplyList:(int) orderId
              sucessBlock:(void (^)(NSString *))sucessCallback
                failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/officeOrderDetailSupplyList?orderId=%d",REMOTE_WS_URL,orderId];
    
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}


/*
 *@brief 订单取消
 */
+(void) cancelOrder:(NSString *) orderNo
        sucessBlock:(void (^)(NSString *))sucessCallback
          failBlock:(void (^)(NSDictionary *))failCallback{
    
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/cancelOrder?orderNo=%@",REMOTE_WS_URL,orderNo];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}





/*
 *@brief 绑定百度云
 */
+(void) bindBPush : (NSString *) deviceType
         channelid: (NSString *) channelid
       sucessBlock:(void (^)(NSString *))sucessCallback
         failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/bindBPush?deviceType=%@&channelid=%@",REMOTE_WS_URL,deviceType,channelid];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}


/*
 *@brief 解绑百度云
 */
+(void) unbindBPush : (NSString *) deviceType
           channelid: (NSString *) channelid
         sucessBlock:(void (^)(NSString *))sucessCallback
           failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/unbindBPush?deviceType=%@&channelid=%@",REMOTE_WS_URL,deviceType,channelid];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}

/*
 *@brief 终端开发商账号申请列表
 */
+(void)terminalList:(NSString *)userid sucessBlock:(void (^)(NSString *))sucessCallback failBlock:(void (^)(NSDictionary *))failCallback{
    NSString * remoteStr=[NSString stringWithFormat:@"%@/phone/getZhongDuanRegisterList?userid=%@",REMOTE_WS_URL,userid];
    
    [self doGetToServer:remoteStr needToken:YES sucessBlock:sucessCallback failBlock:failCallback];
}
@end
