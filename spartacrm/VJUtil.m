//
//  VJUtil.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-11.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "VJUtil.h"

@implementation VJUtil



//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) validateCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}





/*
 * @brief 做扫描处理
 * @param commodityCode 扫描的字符串
 * @param dicDetailList 服务端传进来的json对象
 * @param nowNumberArray 扫描过的数量
 * @return dic{
  status = 0 ; // 不通过
  status = 1 ; // 通过
  msg ; // 提示信息
  cpmc ; // 产品名称
  cpbm ; // 产品编码
 }*/

+ (NSMutableDictionary *) checkCommodityCode:(NSString *)commodityCode  dicDetailList:(NSMutableArray *)dicDetailList{
    if (commodityCode.length == 14) {
        NSString *cpmc = @"瓶码"; // 产品名称
        NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           commodityCode, @"cpbm",
                                           dicDetailList, @"dicDetailList",
                                           @"1", @"status",
                                           cpmc, @"cpmc", nil];
        return returnDic;
    }
    
    
    int successNum = 0;
    
    NSString *ppStr = [commodityCode substringWithRange:NSMakeRange(4, 3)];
    NSString *dsStr = [commodityCode substringWithRange:NSMakeRange(7, 2)];
    NSString *rlStr = [commodityCode substringWithRange:NSMakeRange(9, 2)];
    NSString *ggStr = [commodityCode substringWithRange:NSMakeRange(11, 2)];
    NSString *cpmc = @""; // 产品名称
    NSString *msg = @"扫码不通过";
    
    NSArray *ppArray = @[
                         @[@"001",@"050152",@"交杯酒 "]
                         ];
    
    NSArray *dsArray = @[
                         @[@"05",@"39",@"39度 "],
                         @[@"08",@"52",@"52度 "],
                         ];
    NSArray *rlArray = @[
                         @[@"03",@"500",@"500ml "],
                         ];
    NSArray *ggArray = @[
                         @[@"01",@"6" ,@"6瓶/件 "],
                         ];
    int i = -1;
    for (NSMutableDictionary * detail in dicDetailList) {
        //标记当前循环到第几个
        i++;
        NSString * ruleStr=[detail objectForKey:@"verifyStr"];
        NSLog(@"%@",ruleStr);
        NSArray * ruleArray=[ruleStr componentsSeparatedByString:@"dbh"];
        
        for (NSArray *pp in ppArray) {
            if ([ppStr isEqualToString:pp[0]] && [ruleArray[0] isEqualToString:pp[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:pp[2]];
                break;
            }
        }
        for (NSArray *ds in dsArray) {
            if ([dsStr isEqualToString:ds[0]] && [ruleArray[2] isEqualToString:ds[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:ds[2]];
                break;
            }
        }
        for (NSArray *rl in rlArray) {
            if ([rlStr isEqualToString:rl[0]] && [ruleArray[1] isEqualToString:rl[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:rl[2]];
                break;
            }
        }
        for (NSArray *gg in ggArray) {
            if ([ggStr isEqualToString:gg[0]] && [ruleArray[3] isEqualToString:gg[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:gg[2]];
                break;
            }
        }
        
        
        if(successNum==4){
            int sl=[[detail objectForKey:@"sl"] intValue];
            int nowNum= 0;
            if([detail objectForKey:@"nowNum"]){
                nowNum = [[detail objectForKey:@"nowNum"] intValue];
            }
            if(nowNum < sl){
                nowNum++;
                NSString *num = [NSString stringWithFormat:@"%d",nowNum];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:detail];
                [dic setObject:num forKey:@"nowNum"];
                NSMutableArray *newArr = [NSMutableArray arrayWithArray:dicDetailList];
                [newArr replaceObjectAtIndex:i withObject:dic];
                dicDetailList = newArr;
                
                NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   commodityCode, @"cpbm",
                                                   @"1", @"status",
                                                   @"", @"msg",
                                                   dicDetailList, @"dicDetailList",
                                                   cpmc, @"cpmc", nil];
                return returnDic;
            }else{
                msg = [cpmc stringByAppendingString:@" 当前扫码量已满！"];
            }
        }
            successNum = 0;
            cpmc = @"";
    }
    NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 commodityCode, @"cpbm",
                 @"0", @"status",
                 msg, @"msg",
                 dicDetailList, @"dicDetailList",
                 cpmc, @"cpmc", nil];
    
    return returnDic;
}



/*
 * @brief 做销售处理
 * @param commodityCode 扫描的字符串
 * @return dic{
 
 }*/

+ (NSDictionary *) saleCommodityCode:(NSString *)commodityCode{
    
    if (commodityCode.length == 14) {
        NSString *cpmc = @"瓶码"; // 产品名称
        NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           commodityCode, @"cpbm",
                                           @"1", @"status",
                                           cpmc, @"cpmc", nil];
        return returnDic;
    }    int successNum = 0;
    
    NSString *ppStr = [commodityCode substringWithRange:NSMakeRange(4, 3)];
    NSString *dsStr = [commodityCode substringWithRange:NSMakeRange(7, 2)];
    NSString *rlStr = [commodityCode substringWithRange:NSMakeRange(9, 2)];
    NSString *ggStr = [commodityCode substringWithRange:NSMakeRange(11, 2)];
    NSString *cpmc = @"";
    NSString *msg = @"扫码不通过";
    
    NSArray *ppArray = @[
                         @[@"001",@"050152",@"交杯酒 "]
                         ];
    
    NSArray *dsArray = @[
                         @[@"05",@"39",@"39度 "],
                         @[@"08",@"52",@"52度 "],
                         ];
    NSArray *rlArray = @[
                         @[@"03",@"500",@"500ml "],
                         ];
    NSArray *ggArray = @[
                         @[@"01",@"6" ,@"6瓶/件 "],
                         ];
    
        for (NSArray *pp in ppArray) {
            if ([ppStr isEqualToString:pp[0]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:pp[2]];
                break;
            }
        }
        for (NSArray *ds in dsArray) {
            if ([dsStr isEqualToString:ds[0]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:ds[2]];
                break;
            }
        }
        for (NSArray *rl in rlArray) {
            if ([rlStr isEqualToString:rl[0]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:rl[2]];
                break;
            }
        }
        for (NSArray *gg in ggArray) {
            if ([ggStr isEqualToString:gg[0]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:gg[2]];
                break;
            }
        }
    if(successNum == 4){
            NSDictionary * returnDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                commodityCode, @"cpbm",
                                @"1", @"status",
                                @"", @"msg",
                                cpmc, @"cpmc", nil];
        return returnDic;
    }
    NSDictionary *returnDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                commodityCode, @"cpbm",
                                @"0", @"status",
                                msg, @"msg",
                                cpmc, @"cpmc", nil];
                return returnDic;
}





/*
 * @brief 做删除处理
 * @param commodityCode 扫描的字符串
 * @param dicDetailList 服务端传进来的json对象
 * @param nowNumberArray 扫描过的数量
 * @return dic{
 
 }*/

+ (NSMutableDictionary *) delCommodityCode:(NSString *)commodityCode  dicDetailList:(NSMutableArray *)dicDetailList{
    
    int successNum = 0;
    
    NSString *ppStr = [commodityCode substringWithRange:NSMakeRange(4, 3)];
    NSString *dsStr = [commodityCode substringWithRange:NSMakeRange(7, 2)];
    NSString *rlStr = [commodityCode substringWithRange:NSMakeRange(9, 2)];
    NSString *ggStr = [commodityCode substringWithRange:NSMakeRange(11, 2)];
    NSString *cpmc = @"";
    NSString *msg = @"扫码不通过";
    
    NSArray *ppArray = @[
                         @[@"001",@"050152",@"交杯酒 "]
                         ];
    
    NSArray *dsArray = @[
                         @[@"05",@"39",@"39度 "],
                         @[@"08",@"52",@"52度 "],
                         ];
    NSArray *rlArray = @[
                         @[@"03",@"500",@"500ml "],
                         ];
    NSArray *ggArray = @[
                         @[@"01",@"6" ,@"6瓶/件 "],
                         ];
    int i = -1;
    for (NSMutableDictionary * detail in dicDetailList) {
        //标记当前循环到第几个
        i++;
        NSString * ruleStr=[detail objectForKey:@"verifyStr"];
        NSLog(@"%@",ruleStr);
        NSArray * ruleArray=[ruleStr componentsSeparatedByString:@"dbh"];
        
        for (NSArray *pp in ppArray) {
            if ([ppStr isEqualToString:pp[0]] && [ruleArray[0] isEqualToString:pp[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:pp[2]];
                break;
            }
        }
        for (NSArray *ds in dsArray) {
            if ([dsStr isEqualToString:ds[0]] && [ruleArray[2] isEqualToString:ds[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:ds[2]];
                break;
            }
        }
        for (NSArray *rl in rlArray) {
            if ([rlStr isEqualToString:rl[0]] && [ruleArray[1] isEqualToString:rl[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:rl[2]];
                break;
            }
        }
        for (NSArray *gg in ggArray) {
            if ([ggStr isEqualToString:gg[0]] && [ruleArray[3] isEqualToString:gg[1]]) {
                successNum++;
                cpmc = [cpmc stringByAppendingString:gg[2]];
                break;
            }
        }
        
        
        if(successNum==4){
            int sl=[[detail objectForKey:@"sl"] intValue];
            int nowNum= 0;
            NSString *qerr = [detail objectForKey:@"nowNum"];
            if([detail objectForKey:@"nowNum"]){
                nowNum = [[detail objectForKey:@"nowNum"] intValue];
            }
            if(nowNum > 0){
                nowNum--;
                NSString *num = [NSString stringWithFormat:@"%d",nowNum];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:detail];
                [dic setObject:num forKey:@"nowNum"];
                NSMutableArray *newArr = [NSMutableArray arrayWithArray:dicDetailList];
                [newArr replaceObjectAtIndex:i withObject:dic];
                dicDetailList = newArr;
                
                NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                   commodityCode, @"cpbm",
                                                   @"1", @"status",
                                                   @"", @"msg",
                                                   dicDetailList, @"dicDetailList",
                                                   cpmc, @"cpmc", nil];
                return returnDic;
            }else{
                msg = [cpmc stringByAppendingString:@" 当前扫码量为空，不能删除！"];
            }
        }
        successNum = 0;
        cpmc = @"";
    }
    NSMutableDictionary * returnDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                commodityCode, @"cpbm",
                                @"0", @"status",
                                msg, @"msg",
                                dicDetailList, @"dicDetailList",
                                cpmc, @"cpmc", nil];
    
    return returnDic;
}

@end
