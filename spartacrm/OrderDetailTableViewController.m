//
//  OrderDetailTableViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-7-2.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "OrderDetailTableViewController.h"
#import "HttpTask.h"
#import "UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SAMHUDView/SAMHUDView/SAMHUDView.h"

@interface OrderDetailTableViewController (){
    NSMutableArray * _supplyList;
    int _selectedIndex;
    UIView * _viewMain;
}

@end

@implementation OrderDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _supplyList=[[NSMutableArray alloc] init];
    
    [HttpTask officeOrderDetail:[_orderId intValue] sucessBlock:^(NSString * jsonString) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        
       
        
        
        if([@"2" isEqualToString:[dic objectForKey:@"status"]]){
            _viewMain= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 220)];
            
            UIImageView * _imageSign=[[UIImageView alloc] initWithFrame:CGRectMake(27, 75, WIDTH-54, 140)];
            NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,[dic objectForKey:@"signature"]];
            NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
            [_imageSign sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:imgCacheName] options:SDWebImageDelayPlaceholder];
            
            [_viewMain addSubview:_imageSign];
        } else {
            _viewMain= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 75)];
            [_viewMain setFrame:CGRectMake(0, 0, WIDTH, 70)];
        }
        
        UIFont * font=[UIFont systemFontOfSize:12];
        UILabel * _orderNo = [[UILabel alloc] initWithFrame:CGRectMake(27, 1, WIDTH-27, 20)];
        _orderNo.text=[NSString stringWithFormat:@"%@%@",@"订单编号:",[dic objectForKey:@"orderNo"]];
        _orderNo.font= font;
        [_viewMain addSubview:_orderNo];
        
        UILabel * _createTime = [[UILabel alloc] initWithFrame:CGRectMake(27, 25, WIDTH-27, 20)];
        _createTime.text=[NSString stringWithFormat:@"%@%@",@"创建时间:",[dic objectForKey:@"createTime"]];
        _createTime.font= font;
        [_viewMain addSubview:_createTime];
        
        UILabel * _statusName = [[UILabel alloc] initWithFrame:CGRectMake(27, 50, WIDTH-27, 20)];
        _statusName.text=[NSString stringWithFormat:@"%@%@",@"订单状态:",[dic objectForKey:@"statusName"]];
        _statusName.font= font;
        [_viewMain addSubview:_statusName];
        
        
        UIView * _lineView= [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 1)];
        _lineView.backgroundColor=UIColorFromRGB(0xeeeeee);
        [_viewMain addSubview:_lineView];
        
        
        
        UIView * _viewForFooter= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
        self.tableView.tableFooterView=_viewForFooter;
        
        
        
        self.tableView.tableHeaderView=_viewMain;
        _supplyList=[dic objectForKey:@"supplies"];
        
        
    } failBlock:^(NSDictionary * dicError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
    [HttpTask officeOrderDetailSupplyList:[_orderId intValue] sucessBlock:^(NSString * jsonString) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        _supplyList=[dic objectForKey:@"dataList"];
        [self.tableView reloadData];
    } failBlock:^(NSDictionary * dicError) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_supplyList count];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex=indexPath.row;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSDictionary *dic=[_supplyList objectAtIndex:(indexPath.row)];
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //图片
    UIImageView * imageView=(UIImageView *)[cell viewWithTag:1];
    NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,[dic objectForKey:@"img"]];
    NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:imgCacheName]];
    
    
    //名称
    ((UILabel *)[cell viewWithTag:2]).text=[dic objectForKey:@"name"];
    
    //个数
    ((UILabel *)[cell viewWithTag:3]).text=[dic objectForKey:@"count"];
    
    
    //单位
    ((UILabel *)[cell viewWithTag:4]).text=[dic objectForKey:@"unit"];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (IBAction)btnCancelClick:(id)sender {
//    [HttpTask cancelOrder:_orderNo.text sucessBlock:^(NSString * jsonString) {
//        NSError *error;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
//        int status=[[dic objectForKey:@"status"] intValue];
//        if (status==1) { //取消成功
//            [_btnCancel setHidden:YES];
//            [_btnSubmit setHidden:YES];
//        } else {
//           UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消订单失败" delegate:nil
//                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//            
//    } failBlock:^(NSDictionary * dicErr){
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }];
    
}
@end
