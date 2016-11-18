//
//  CategoryTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/25.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "OfficeSuppliesTableViewController.h"
#import "HttpTask.h"



@interface CategoryTableViewController () {
    NSString * _catId;
    NSString * _catName;
}
@end

@implementation CategoryTableViewController

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
    [HttpTask getAllOfficeCategoryList:^(NSString * jsonString) {
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
    _catId=[dic objectForKey:@"id"];
    _catName=[dic objectForKey:@"name"];
    [self performSegueWithIdentifier:@"toOfficeList" sender:self.view];
    //[_officeSuppliesTableViewControllerDelegate modifyCate:[dic objectForKey:@"id"] cateName:[dic objectForKey:@"name"]];
    //[_officeSuppliesTableViewControllerDelegate loadData];
    
    
    
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //_expressId
    
    id dest=[segue destinationViewController];
    if ([dest isKindOfClass:[OfficeSuppliesTableViewController class]]) {
        OfficeSuppliesTableViewController * officeSuppliesTableViewController=(OfficeSuppliesTableViewController *) dest;
        officeSuppliesTableViewController.catId=_catId;
        officeSuppliesTableViewController.catName=_catName;
        
    }
    
}



@end
