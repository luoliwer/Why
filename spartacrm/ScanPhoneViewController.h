//
//  ScanPhoneViewController.h
//  wly
//
//  Created by luolihacker on 15/12/16.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanViewController.h"

@interface ScanPhoneViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIViewPassValueDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property(strong,nonatomic) NSMutableArray *listData;
@property(strong,nonatomic)UITableViewCell *tableViewCell;
@property(strong,nonatomic)UIButton *scanGunBtn;
@property(strong,nonatomic)NSMutableDictionary *huowuKindDic; //货物种类
@property(strong,nonatomic)NSString *thingsType; // 事件类型
@property(strong,nonatomic)NSDate *createdate; // 当前创建单据信息的时间
@property(strong,nonatomic)NSString *describremark; // 创建当前单据的备注
@property(strong,nonatomic)NSArray *danjuArray;
@property(strong,nonatomic)NSArray *tempArray; //进入缓存列表导入的数据
@property(strong,nonatomic)NSString *shouhuoType; //判断是哪种收货
@property(strong,nonatomic)NSString *detailJson; // 收货，调货收货传过来的JSON串
@property(strong,nonatomic)NSString *tuihuoType; // 哪种退货（4终端商，5个人）
@property(strong,nonatomic)NSString *zdsId; // 终端商id

@property (nonatomic,assign) BOOL isCacheScan;
@property (assign,nonatomic) BOOL isFirstScanGunData;


@end
