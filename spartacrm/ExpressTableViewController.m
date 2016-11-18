//
//  NewsTableViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-6.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "ExpressTableViewController.h"
#import "ExpressDetailTableViewController.h"
#import "HttpTask.h"


@interface ExpressTableViewController () {
    NSString * _expressId;
    
}
@end

@implementation ExpressTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [self loadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarItem.badgeValue=@"1";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void) loadData
{
    _loadding=YES;
    [HttpTask expressList:_pageIndex pageSize:_pageSize sucessBlock:^(NSString * jsonString) {
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
    NSDictionary *dicRow = (NSDictionary *)[_datasourceArray objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = [tableView  dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    //快递类型
    UIImageView * imgType=(UIImageView *)[cell viewWithTag:10];
    NSInteger type=[[dicRow objectForKey:@"type"] intValue];
    if (type==1) {
       imgType.image=[UIImage imageNamed:@"type_youjian"];
    } else {
       imgType.image=[UIImage imageNamed:@"type_baoguo"];
    }
    
    //快递标题
    UILabel * lblTitle=(UILabel *)[cell viewWithTag:1];
    lblTitle.text=[dicRow objectForKey:@"title"];
    
    //快递时间
    UILabel * lblReceiveTime=(UILabel *)[cell viewWithTag:2];
    lblReceiveTime.text=[dicRow objectForKey:@"receiveTime"];
    
    //寄件人
    UILabel * lblSender=(UILabel *)[cell viewWithTag:3];
    lblSender.text=[NSString stringWithFormat:@"%@ %@",[dicRow objectForKey:@"senderName"],[dicRow objectForKey:@"sendfrom"]];

    
    //是否已领取
    NSInteger stauts=[[dicRow objectForKey:@"stauts"] intValue];
    UIImageView * imgStautsView=(UIImageView *)[cell viewWithTag:4];
    if (stauts==0 ){ //已送
        imgStautsView.image=[UIImage imageNamed:@"btn_yishong"];
    } else if (stauts==2 ){ //已领
        imgStautsView.image=[UIImage imageNamed:@"btn_yiqu"];
    } else {
        imgStautsView.image=[UIImage imageNamed:@"btn_weiqu"];
    }
    
    
    
    //内部编号
    UILabel * lblExpressCode=(UILabel *)[cell viewWithTag:6];
    lblExpressCode.text=[dicRow objectForKey:@"innerCode"];

    
	return cell;
}

//
//-(void) changeState:(NSString *)expressId {
//    
//    [HttpTask expressDetail:[expressId intValue] sucessBlock:^(NSString * jsonString) {
//        NSError *error;
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
//        NSString * expressStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"expressStatus"]];
//        
//        for (int j=0;j<[_datasourceArray count];j++) {
//            NSDictionary * obj = [_datasourceArray objectAtIndex:j];
//            
//            if ([[obj objectForKey:@"id"] isEqualToString:expressId]) {
//                [obj setValue:expressStatus forKey:@"stauts"];
//                [_datasourceArray replaceObjectAtIndex:j withObject:obj];
//                
//                
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:0];
//                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                
//                
//                break;
//            }
//        }
//
//        
//    } failBlock:^(NSDictionary * errDic) {
//        
//    }];
//    
//    
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex=indexPath.row;
   NSDictionary * dictionary = [_datasourceArray objectAtIndex:_selectedIndex];
    _expressId=[dictionary objectForKey:@"id"];
    
    
    [self performSegueWithIdentifier:@"toExpressDetail" sender:self.view];
    //toExpressDetail
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        //_expressId
    
        id dest=[segue destinationViewController];
        if ([dest isKindOfClass:[ExpressDetailTableViewController class]]) {
            ExpressDetailTableViewController * expressDetailTableViewController=(ExpressDetailTableViewController *) dest;
            expressDetailTableViewController.expressId=_expressId;
    
        }
    
}


@end
