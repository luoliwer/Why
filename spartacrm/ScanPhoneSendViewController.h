//
//  ScanPhoneSendViewController.h
//  wly
//
//  Created by luolihacker on 15/12/16.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sendScanViewControlller.h"

@interface ScanPhoneSendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIViewPassSendValueDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *listData;
@property(strong,nonatomic)UITableViewCell *tableViewCell;
@property(strong,nonatomic)UIButton *scanGunBtn;
@property (assign,nonatomic) BOOL isFirstScanGunData;
@property(strong,nonatomic)NSArray *tempArray;
@property(strong,nonatomic)NSString *fahuoType; // 判断是哪种发货类型（“0”发货，"1"调货发货）
@property(nonatomic,strong)NSString *chepaihao; //从调货发货单里传过来的车牌号

@end
