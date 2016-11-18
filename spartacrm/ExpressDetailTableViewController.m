//
//  ExpressDetailTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ExpressDetailTableViewController.h"
#import "HttpTask.h"
#import "ExpressHelpTableController.h"
#import "ExpressSignViewController.h"
#import "MemberSearchTableViewController.h"
#import "SAMHUDView.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "SAMHUDView/SAMHUDView/SAMHUDView.h"
#import "ExpressTableViewController.h"


@interface ExpressDetailTableViewController (){
    NSString * _expressType;
    NSString * _expressStatus;
    NSString * _toTime;
    NSString * _curTime;
    
    int  _intervalCount;
    int  _timerCount;
    
}

@end


@implementation ExpressDetailTableViewController





- (void)viewDidLoad
{
    _timerCount=0;
    [_segNeedHelp setHidden:YES];
    [_lblTimeDaojishi setHidden:YES];
    [HttpTask expressDetail:[_expressId intValue] sucessBlock:^(NSString * jsonString) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        _labelSender.text=[NSString stringWithFormat:@"%@%@",@"发件人:",[dic objectForKey:@"sender"]];
        _labelSenderAddr.text=[NSString stringWithFormat:@"%@%@",@"发件城市:",[dic objectForKey:@"senderFrom"]];
        _labelRevicer.text=[NSString stringWithFormat:@"%@%@",@"收件人:",[dic objectForKey:@"revicer"]];
        _labelExpressNo.text=[NSString stringWithFormat:@"%@%@",@"运单号:",[dic objectForKey:@"expressCode"]];
        _labelExpressCompany.text=[NSString stringWithFormat:@"%@%@",@"快递公司:",[dic objectForKey:@"companyName"]];
        _labelExpressTypeName.text=[NSString stringWithFormat:@"%@%@",@"快递类型:",[dic objectForKey:@"expressTypeName"]];
        
        
        
        _labelExpressSignTime.text=[NSString stringWithFormat:@"%@%@",@"通知时间:",[dic objectForKey:@"receiveTime"]];
        _labelExpressNoteTime.text=[NSString stringWithFormat:@"%@%@",@"签收时间:",[dic objectForKey:@"drawTime"]];
        _labelExpressSignStatus.text=[NSString stringWithFormat:@"%@%@",@"领取状态:",[dic objectForKey:@"statusName"]];
        _labelExpressDailing.text=[NSString stringWithFormat:@"%@%@",@"代领人:",[dic objectForKey:@"drawProxyPerson"]];
        
        _lblInnerCode.text=[NSString stringWithFormat:@"%@%@",@"内部编号:",[dic objectForKey:@"innerCode"]];
        _labelExpressHelp.text=[NSString stringWithFormat:@"%@%@",@"领取方式:",[dic objectForKey:@"needHelpName"]];
        
        //        _labelExpressSignMan.text=[NSString stringWithFormat:@"%@%@",@"签收人:",[dic objectForKey:@"drawPerson"]];
        
        _signImgUrl=[dic objectForKey:@"signature"];  //签字意见
        
        _expressType=[dic objectForKey:@"expressType"];
        _expressStatus=[dic objectForKey:@"expressStatus"];
        
        NSString * status=[dic objectForKey:@"expressStatus"];
        
        
        
        
        
        if([status isEqualToString:@"2"]){ //已签收
            [_btnSetProxy setHidden:YES];
            UIView * _viewForFooter= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
            self.tableView.tableFooterView=_viewForFooter;
            
            UIView * _lineView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
            _lineView.backgroundColor=UIColorFromRGB(0xeeeeee);
            [_viewForFooter addSubview:_lineView];
            
            UIImageView * _imageSign=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140)];
            NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,[dic objectForKey:@"signature"]];
            NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
            [_imageSign sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:imgCacheName] options:SDWebImageDelayPlaceholder];
            [_viewForFooter addSubview:_imageSign];
            self.tableView.tableFooterView=_viewForFooter;
            
            
            
        } else {
            UIView * _viewForFooter= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
            self.tableView.tableFooterView=_viewForFooter;
            
            self.tableView.tableFooterView=_viewForFooter;
            
        }
        
        
        NSString * expressType=[dic objectForKey:@"expressType"];
        if([expressType isEqualToString:@"2"]){ //包裹
            [_lblNeedHelp setHidden:YES];
            [_segNeedHelp setHidden:NO];
            NSString * needHelp=[dic objectForKey:@"needHelp"];
            if([needHelp isEqualToString:@"1"]){ //需要帮助
                [_lblTimeDaojishi setHidden:NO];
                _segNeedHelp.selectedSegmentIndex=1;
                _lblTimeDaojishi.text=[dic objectForKey:@"helpMsg"];
                
//                _toTime=[dic objectForKey:@"toTime"];
//                _curTime=[dic objectForKey:@"curTime"];
//                _intervalCount=[[dic objectForKey:@"intervalTime"] intValue];
//                
//                [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                
            } else {
                _segNeedHelp.selectedSegmentIndex=0;
                [_lblTimeDaojishi setHidden:YES];
            }
            
        } else {
            [_lblNeedHelp setHidden:NO];
            [_segNeedHelp setHidden:YES];
        }
        
        
        
    } failBlock:^(NSDictionary * errDic) {
        
    }];
    
    [_segNeedHelp addTarget:self
                     action:@selector(segmentAction:)
           forControlEvents:UIControlEventValueChanged];
}


- (void)timerFireMethod:(NSTimer *)theTimer
{
    
    _timerCount++;
    int disCount=_intervalCount-_timerCount;
    if (disCount<=0) {
        [theTimer invalidate];
    } else {
        
        int h=(disCount % 86400) / 3600;
        int fen=(disCount % 3600) / 60;
        int miao=disCount % 60;
        
        
        [_lblTimeDaojishi setText:[NSString stringWithFormat:@"%d:%d:%d",h,fen,miao]];
    }
}

-(void)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger index = Seg.selectedSegmentIndex;
    int needHelp=0;
    switch (index) {
        case 0:
            needHelp=0;
            break;
        case 1:
            needHelp=1;
            break;
        default:
            needHelp=1;
            break;
    }
    
    
    [HttpTask expressHelp:[_expressId intValue] needHelp:needHelp sucessBlock:^(NSString * jsonStr) {
        if(needHelp==1) {
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            
            [[[UIAlertView alloc]initWithTitle:@"提示"
                                       message:[dic objectForKey:@"msg"]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil] show];
        }
        [self viewDidLoad];
    } failBlock:^(NSDictionary * dicErr) {
        
    }];
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)  indexPath{
    //    NSInteger seciton=indexPath.section;
    //    NSInteger row=indexPath.row;
    //
    //    if ([_expressStatus intValue]==2) {//邮件已被签收
    //        return;
    //    } else {
    //
    //
    //        if (seciton==1 && row==1) { //设置代领人
    //            [self performSegueWithIdentifier:@"toProxy" sender:self.view];
    //        }
    //        if (seciton==1 && row==2) { //设置help
    //            if ([_expressType intValue]==1) { //邮件
    //                [[[UIAlertView alloc]initWithTitle:@"提示"
    //                                           message:@"邮件不能设置领用方式！"
    //                                          delegate:nil
    //                                 cancelButtonTitle:@"确定"
    //                                 otherButtonTitles:nil] show];
    //            } else {
    //                [self performSegueWithIdentifier:@"toSetHelp" sender:self.view];
    //            }
    //        }
    //        if (seciton==1 && row==3) { //查看签收人
    //            [[[UIAlertView alloc]initWithTitle:@"提示"
    //                                       message:@"当前邮件还未被领取不能查看签收人！"
    //                                      delegate:nil
    //                             cancelButtonTitle:@"确定"
    //                             otherButtonTitles:nil] show];
    //        }
    //    }
    
    
}

//
//
//-(void) presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
//    if ([viewControllerToPresent isKindOfClass:[ExpressTableViewController class]]) {
//        [_expressTableViewControllerDelegate changeState:_expressId];
//        
//        
//    }
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id dest=[segue destinationViewController];
    if ([dest isKindOfClass:[MemberSearchTableViewController class]]) {
        MemberSearchTableViewController * memberSearchTableViewController=(MemberSearchTableViewController *) dest;
        memberSearchTableViewController.expressDetailTableViewControllerDelegate=self;
        
    } else if ([dest isKindOfClass:[ExpressHelpTableController class]]) {
        ExpressHelpTableController * expressHelpTableController=(ExpressHelpTableController *) dest;
        expressHelpTableController.expressDetailTableViewControllerDelegate=self;
    }  else if ([dest isKindOfClass:[ExpressSignViewController class]]) {
        ExpressSignViewController * expressSignViewController=(ExpressSignViewController *) dest;
        
        NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,_signImgUrl];
        expressSignViewController.signImgUrl=imgStr;
    }
    
    
    
}


//ExpressDetailTableViewControllerDelegate
-(void) modifyProxyPerson:(NSString *) proxyPersonId proxyPersonName:(NSString *) proxyPersonName{
    _labelExpressDailing.text=[NSString stringWithFormat:@"%@%@",@"代领人:",proxyPersonName];
    [HttpTask expressDrawProxyPerson:[_expressId intValue] proxyPersonId:[proxyPersonId intValue] sucessBlock:^(NSString * jsonStr) {
        
    } failBlock:^(NSDictionary * dicErr) {
        
    }];
}





- (IBAction)btnSetProxyClick:(id)sender {
    [self performSegueWithIdentifier:@"toProxy" sender:self.view];
}
@end
