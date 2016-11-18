//
//  CategoryTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "GroupTableViewControlle.h"
#import "OfficeSuppliesTableViewController.h"
#import "AccountViewController.h"
#import "HttpTask.h"



@interface GroupTableViewController () {
    NSString * _catId;
    NSString * _catName;
}
@end

@implementation GroupTableViewController

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
}



- (void) loadData
{
    _loadding=YES;
    [HttpTask getAllGroupList:^(NSString * jsonString) {
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
    NSDictionary *dic=[_datasourceArray objectAtIndex:(indexPath.row)];
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //名称
    ((UILabel *)[cell viewWithTag:1]).text=[dic objectForKey:@"name"];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_datasourceArray objectAtIndex:indexPath.row];
  
    [_accountControllerDelegate modifyGroup:[dic objectForKey:@"id"] groupName:[dic objectForKey:@"name"]];
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
