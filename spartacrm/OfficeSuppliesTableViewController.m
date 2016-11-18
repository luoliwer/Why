//
//  OfficeSuppliesTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "OfficeSuppliesTableViewController.h"
#import "MBProgressHUD.h"
#import "CategoryTableViewController.h"
#import "HttpTask.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SAMCategories.h"
#import "SAMHUDView/SAMHUDView/SAMHUDView.h"



@interface OfficeSuppliesTableViewController (){
    NSMutableArray * _officeSuppliesList;
    int _selectedIndex;
    SAMHUDView * _sview;
}

@end


@implementation OfficeSuppliesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    _sview =[[SAMHUDView alloc] init];
//    if(_currentCateId==nil){
//        [HttpTask getFirstOfficeCategory:^(NSString * jsonString) {
//            NSError *error;
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
//            _currentCateId=[dic objectForKey:@"id"];
//            _currentCateName=[dic objectForKey:@"name"];
//            _lblType.text=_currentCateName;
//             [super viewDidLoad];
//        } failBlock:^(NSDictionary * dic) {
//           
//        }];
//    }
//    
    
    
//    UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapEvent:)];
//     _lblType.userInteractionEnabled = YES;
//    [_lblType addGestureRecognizer:myTapGesture];
    
    
    [super viewDidLoad];
    
    self.navigationItem.title=_catName;
}



- (void) loadData
{
    _loadding=YES;
    [HttpTask getOfficeSupplyList:[_catId intValue]
                        pageIndex:_pageIndex
                         pageSize:_pageSize
                        sucessBlock:^(NSString * jsonString) {
                            @try {
                                NSError *error;
                                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                                
                                //指明是否有下一页
                                int  hasNextInt = [[dictionary objectForKey:@"hasNext"] intValue];
                                _hasNext=hasNextInt==1;
                                
                                //解析数据记录
                                _officeSuppliesList = (NSMutableArray *)[dictionary objectForKey:@"dataList"];
                                [self updateData:_officeSuppliesList];
                                
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
  
    
    NSDictionary *dic=[_datasourceArray objectAtIndex:(indexPath.row)];
    cell = [tableView dequeueReusableCellWithIdentifier:@"supplyCell" forIndexPath:indexPath];
    
    //图片
    UIImageView * imageView=(UIImageView *)[cell viewWithTag:1];
    NSString * imgStr=[NSString stringWithFormat:@"%@%@",REMOTE_URL,[dic objectForKey:@"img"]];
    NSLog(@"%@",imgStr);
    NSString * imgCacheName=[NSString stringWithFormat:@"%@.png",[imgStr sam_MD5Digest]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
     
    
    //名称
    ((UILabel *)[cell viewWithTag:2]).text=[dic objectForKey:@"name"];
    
    //库存
    //((UIButton *)[cell viewWithTag:3]).titleLabel.text=[dic objectForKey:@"storage"];
    [((UIButton *)[cell viewWithTag:3]) setTitle:[dic objectForKey:@"storage"] forState:UIControlStateNormal];
    
    //单位
    ((UILabel *)[cell viewWithTag:4]).text=[dic objectForKey:@"unit"];
    
    
    
    //steper
    UIStepper * stepper=(UIStepper *)[cell viewWithTag:6];
    [stepper addTarget:self action:@selector(updateValue:)  forControlEvents:UIControlEventValueChanged];
    
    int maxSize=[[dic objectForKey:@"storage"] intValue];
    int minSize=1;
    if (maxSize==0) {
        minSize=0;
    }
    [stepper setMinimumValue:minSize];
    [stepper setMaximumValue:maxSize];
    [stepper setValue:minSize];
    
    
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    lblNumber.text=[NSString  stringWithFormat:@"%d",minSize];
    
    
    //btn car
    UIButton * btnCar=((UIButton *)[cell viewWithTag:7]);
    [btnCar addTarget:self action:@selector(btnCarClick:) forControlEvents:UIControlEventTouchDown];

    //btn get
    UIButton * btnGet=((UIButton *)[cell viewWithTag:8]);
    [btnGet addTarget:self action:@selector(btnGetClick:) forControlEvents:UIControlEventTouchDown];


    return cell;
}




-(void) btnGetClick:(id) sender{
    
    UIButton *btnGet=(UIButton *)sender;
    UITableViewCell * cell = (UITableViewCell *)btnGet.superview.superview;
    NSInteger rowIndex=[self.table indexPathForCell:cell].row;
    
    //购买的产品
    NSDictionary *dic=[_datasourceArray objectAtIndex:rowIndex];
    
    //购买数量
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    NSString * strBuyCount=lblNumber.text;
    
    
    //判断领取的数量不能少于0个
    if ([strBuyCount intValue]==0) {
        [_sview failQuicklyWithTitle:@"不能添加0个商品进领取车"];
        return;
    }
    
    
    
    
    //保存领用的情况到服务器
    [HttpTask createOfficeOrder:[dic objectForKey:@"id"]   counts:strBuyCount  sucessBlock:^(NSString * jsonStr) {
        [_sview completeQuicklyWithTitle:@"已添加到领用清单"];
        [self refreshOffice:[dic objectForKey:@"id"] rowIndex:rowIndex];
    } failBlock:^(NSDictionary * errDic) {
        
    }];
}



-(void) refreshOffice:(NSString *) officeId   rowIndex:(NSInteger) rowIndex{

    [HttpTask getOfficeSupplyStorage:[officeId intValue] sucessBlock:^(NSString * jsonStr) {
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        
       // _datasourceArray=[_datasourceArray mutableCopy];
        [_datasourceArray replaceObjectAtIndex:rowIndex withObject:dic];
        
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:rowIndex inSection:0];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    } failBlock:^(NSDictionary * dicErr) {
        
    }];
   
}



-(void) updateValue:(id) sender{
    UIStepper *stepper=(UIStepper *)sender;
    UITableViewCell * cell = (UITableViewCell *)[[stepper superview] superview];

    
    //领用值
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    lblNumber.text=[NSString  stringWithFormat:@"%d",(int)stepper.value];
    
}


-(void) btnCarClick:(id) sender{
    
    UIButton *btnCar=(UIButton *)sender;
    UITableViewCell * cell = (UITableViewCell *)btnCar.superview.superview;
    NSInteger rowIndex=[self.table indexPathForCell:cell].row;
    
    //购买的产品
    NSDictionary *dic=[_datasourceArray objectAtIndex:rowIndex];
    
    //购买数量
    UILabel * lblNumber=(UILabel *)[cell viewWithTag:5];
    NSString * strBuyCount=lblNumber.text;
    
    
    //判断领取的数量不能少于0个
    if ([strBuyCount intValue]==0) {
        [_sview failQuicklyWithTitle:@"不能添加0个商品进领取车"];
        return;
    }
    //保存领用的情况到服务器
    [HttpTask insertToCar:[dic objectForKey:@"id"] count:strBuyCount sucessBlock:^(NSString * jsonStr) {
        [_sview completeQuicklyWithTitle:@"已添加到最终订单"];
        [self refreshOffice:[dic objectForKey:@"id"] rowIndex:rowIndex];
    } failBlock:^(NSDictionary * errDic) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}


-(void)gestureTapEvent:(UITapGestureRecognizer *)gesture {
    //UILabel * lab = (UILabel *)gesture.view ;
    
    [self performSegueWithIdentifier:@"tocate" sender:self.view];

}



//OfficeSuppliesTableViewControllerDelegate
//-(void) modifyCate:(NSString *) strCateId cateName:(NSString *) strCateName{
//    _currentCateId=strCateId;
//    _currentCateName=strCateName;
//    _lblType.text=strCateName;
//}

//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    id dest=[segue destinationViewController];
//    if ([dest isKindOfClass:[CategoryTableViewController class]]) {
//        CategoryTableViewController * categoryTableViewController=(CategoryTableViewController *) dest;
//        categoryTableViewController.officeSuppliesTableViewControllerDelegate=self;
//        
//    }
//}


@end
