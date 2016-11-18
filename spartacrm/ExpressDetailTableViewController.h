//
//  ExpressDetailTableViewController.h
//  aioa
//
//  Created by hunkzeng on 15/7/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressTableViewController.h"

@protocol ExpressDetailTableViewControllerDelegate <NSObject>
-(void) modifyProxyPerson:(NSString *) proxyPersonId proxyPersonName:(NSString *) proxyPersonName;
-(void) modifyNeedHelp:(int) needHelp;
@end


@interface ExpressDetailTableViewController : UITableViewController<ExpressDetailTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelSender; //发件人
@property (weak, nonatomic) IBOutlet UILabel *labelSenderAddr; //发件城市
@property (weak, nonatomic) IBOutlet UILabel *labelRevicer; //收件人
@property (weak, nonatomic) IBOutlet UILabel *labelExpressNo;  //运单号
@property (weak, nonatomic) IBOutlet UILabel *labelExpressCompany;  //快递公司
@property (weak, nonatomic) IBOutlet UILabel *labelExpressSignTime;  //邮件室签收时间
@property (weak, nonatomic) IBOutlet UILabel *labelExpressNoteTime;  //邮件通知时间
@property (weak, nonatomic) IBOutlet UILabel *labelExpressSignStatus;  //领取状态
@property (weak, nonatomic) IBOutlet UILabel *labelExpressDailing;  //代领人
@property (weak, nonatomic) IBOutlet UILabel *labelExpressHelp;  //需要帮助
@property (weak, nonatomic) IBOutlet UILabel *labelExpressSignMan;  //签收人
@property (weak, nonatomic) IBOutlet UILabel *labelExpressTypeName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segNeedHelp;
@property (weak, nonatomic) IBOutlet UILabel *lblNeedHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnSetProxy;
- (IBAction)btnSetProxyClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeDaojishi;
@property (weak, nonatomic) IBOutlet UILabel *lblInnerCode;

@property (strong, nonatomic)  NSString * expressId;
@property (strong, nonatomic)  NSString * signImgUrl;


//@property (weak, nonatomic)  id <ExpressTableViewControllerDelegate>  expressTableViewControllerDelegate;


@end
