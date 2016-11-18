//
//  OfficeCarTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "OfficeCarTableViewController.h"
#import "MBProgressHUD.h"
#import "CategoryTableViewController.h"
#import "HttpTask.h"
#import "UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "SAMHUDView/SAMHUDView/SAMHUDView.h"



@interface OfficeCarTableViewController (){
    NSString * _officeIds ;
    NSString * _counts ;
    SAMHUDView * _sview;
    int _updateCount;
    
}

@end

@implementation OfficeCarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    _updateCount=1;
    [super viewDidLoad];
    _sview =[[SAMHUDView alloc] init];
    [_btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    
}

-(void) viewDidAppear:(BOOL)animated{
    if(_updateCount>1){
        [self updateFirstPageData];
    }
    _updateCount++;
    
}



- (void) loadData
{
    _loadding=YES;
    [HttpTask listOrderForCar:^(NSString * jsonString) {
        @try {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            
            //指明是否有下一页
            int  hasNextInt = [[dictionary objectForKey:@"hasNext"] intValue];
            _hasNext=hasNextInt==1;
            
            //解析数据记录
            NSMutableArray *list = [dictionary objectForKey:@"dataList"];
            [self updateData:list];
            
            
            if (list.count>0) {
                [_btnSubmit setHidden:false];
            } else {
                [_btnSubmit setHidden:true];
            }
            

            
        }
        @catch (NSException *e) {
            NSLog(@"JSON解析失败，原因:%@",[e reason]);
        }
        @finally {
        }
        
    } failBlock:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
    NSDictionary *dic = (NSDictionary *)[_datasourceArray objectAtIndex:indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"supplyCell" forIndexPath:indexPath];
    
    //图片
    UIImageView * imageView=(UIImageView *)[cell viewWithTag:1];
    NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,[dic objectForKey:@"img"]];
    NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:imgCacheName]];
    
    
    //名称
    ((UILabel *)[cell viewWithTag:2]).text=[dic objectForKey:@"name"];
    
    //库存
    [((UIButton *)[cell viewWithTag:3]) setTitle:[dic objectForKey:@"storage"] forState:UIControlStateNormal];
    
    //单位
    ((UILabel *)[cell viewWithTag:4]).text=[dic objectForKey:@"unit"];
    
    
    //steper
    UIStepper * stepper=(UIStepper *)[cell viewWithTag:6];
    [stepper addTarget:self action:@selector(updateValue:)  forControlEvents:UIControlEventValueChanged];
    
    int maxSize=[[dic objectForKey:@"storage"] intValue];
    [stepper setMinimumValue:0];
    [stepper setMaximumValue:maxSize];
    [stepper setValue:[[dic objectForKey:@"count"] intValue]];
    
    //领用值
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    lblNumber.text=[dic objectForKey:@"count"];
    
    
    return cell;
}



-(void) updateValue:(id) sender{
    UIStepper *stepper=(UIStepper *)sender;
    UITableViewCell * cell = (UITableViewCell *)stepper.superview;
    
    //领用值
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    lblNumber.text=[NSString  stringWithFormat:@"%d",(int)stepper.value];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}




- (void)btnSubmitClick:(id)sender {
    
//    _officeIds=@"";
//    _counts=@"";
//    for (int i=0; i<_datasourceArray.count;i++) {
//        NSMutableDictionary *dic = (NSMutableDictionary *)[_datasourceArray objectAtIndex:i];
//        
//        
//        _officeIds=[NSString stringWithFormat:@"%@,%@",_officeIds,[dic objectForKey:@"officeId"]];
//        _counts=[NSString stringWithFormat:@"%@,%@",_counts,[dic objectForKey:@"count"]];
//    }
//    
//    if (![_officeIds isEqualToString:@""]) {
//        _officeIds=[_officeIds substringFromIndex:1];
//    }
//    
//    if (![_counts isEqualToString:@""]) {
//        _counts=[_counts substringFromIndex:1];
//    }
//    

    
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTask createOfficeOrderForCar:^(NSString * jsonString) {
                       //[MBProgressHUD hideHUDForView:self.view animated:YES];
                       NSError *error;
                       NSDictionary *reslutDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                       int status=[[reslutDic objectForKey:@"status"] intValue];
                       
                       
                       if (status==0) {
                           [_sview failQuicklyWithTitle:[reslutDic objectForKey:@"msg"]];

                       } else {
                           [_sview completeQuicklyWithTitle:[reslutDic objectForKey:@"订单提交成功!"]];
                           [self viewDidLoad];
                       }
                       
                   } failBlock:^(NSDictionary * dicErr){
                       //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   }];
    
    

}

- (IBAction)btnDelCarOrder:(id)sender {
    UIButton *btnDel=(UIButton *)sender;
    UITableViewCell * cell = (UITableViewCell *)[[btnDel superview] superview];  

    
    NSIndexPath * indexPath=[self.table indexPathForCell:cell];
    NSInteger rowIndex=indexPath.row;
    NSDictionary *dic= [_datasourceArray objectAtIndex:rowIndex];
    NSString * delCarOrderId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];

    [HttpTask delCar:delCarOrderId sucessBlock:^(NSString * jsonStr) {
        
    } failBlock:^(NSDictionary * errDic) {
    }];
    
    
    [self.table beginUpdates];
    [_datasourceArray removeObjectAtIndex:indexPath.row];
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.table endUpdates];
    
    if(_datasourceArray.count<=0){
        [_btnSubmit setHidden:true];
    }
    
}
@end
