//
//  OrderTableViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-4.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "OrderTableViewController.h"
//#import "UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "OrderDetailTableViewController.h"
#import "HttpTask.h"

@interface OrderTableViewController (){
    NSString * _orderId;
//    int _updateCount;
}

@end

@implementation OrderTableViewController



- (void)viewDidLoad
{
//    _updateCount=1;
    [super viewDidLoad];
    
}


- (void) viewWillAppear:(BOOL)animated{
    [self loadData];
}
//
//-(void) viewDidAppear:(BOOL)animated{
//    if(_updateCount>1){
//        [self updateFirstPageData];
//    }
//    _updateCount++;
//    
//}

- (void) loadData
{
    _loadding=YES;
    [HttpTask officeOrders:_pageIndex
                         pageSize:_pageSize
                      sucessBlock:^(NSString * jsonString) {
                          @try {
                              NSError *error;
                              NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                              
                              //指明是否有下一页
                              int  hasNextInt = [[dictionary objectForKey:@"hasNext"] intValue];
                              _hasNext=hasNextInt==1;
                              
                              //解析数据记录
                              NSMutableArray *list = [dictionary objectForKey:@"dataList"];
                              [self updateData:list];
                              
                          }
                          @catch (NSException *e) {
                              NSLog(@"JSON解析失败，原因:%@",[e reason]);
                          }
                          @finally {
                          }
                          
                      } failBlock:nil];
}



- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellId = @"celltmp";
    NSDictionary *dic = (NSDictionary *)[_datasourceArray objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView  dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    
    //名称
    ((UILabel *)[cell viewWithTag:1]).text=[dic objectForKey:@"name"];
    
    //时间
    ((UILabel *)[cell viewWithTag:2]).text=[dic objectForKey:@"createTime"];
    
    
    //编号
    ((UILabel *)[cell viewWithTag:3]).text=[NSString stringWithFormat:@"编号:%@",[dic objectForKey:@"orderNo"]];
    
    
    //是否已领取
    NSInteger stauts=[[dic objectForKey:@"status"] intValue];
    UIImageView * imgStautsView=(UIImageView *)[cell viewWithTag:4];
    if (stauts==2 ){ //已领
        imgStautsView.image=[UIImage imageNamed:@"btn_yiqu"];
    } else {
        imgStautsView.image=[UIImage imageNamed:@"btn_weiqu"];
    }

  
    
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex=indexPath.row;
    NSDictionary * dictionary = [_datasourceArray objectAtIndex:_selectedIndex];
    _orderId=[dictionary objectForKey:@"id"];
    
    [self performSegueWithIdentifier:@"toOrderDetail" sender:self.view];
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"toOrderDetail"]) {
        OrderDetailTableViewController * orderDetailTableViewController=(OrderDetailTableViewController *)segue.destinationViewController;
        orderDetailTableViewController.orderId=_orderId;
    }
}

@end
