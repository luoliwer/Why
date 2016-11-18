//
//  MemberSearchTableViewController.m
//  aioa
//
//  Created by hunkzeng on 15/7/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "MemberSearchTableViewController.h"
#import "HttpTask.h"

@implementation MemberSearchTableViewController

- (void)viewDidLoad
{
    _searchBar.delegate=self;
    [super viewDidLoad];
    
}


- (void) loadData
{
    _loadding=YES;
    
    [HttpTask getMembersByName:_searchContent pageIndex:_pageIndex pageSize:_pageSize  sucessBlock:^(NSString * jsonString) {
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
   
    //name
    UILabel * lblTitle=(UILabel *)[cell viewWithTag:1];
    lblTitle.text=[dicRow objectForKey:@"name"];
    
    //deptName
    UILabel * lblReceiveTime=(UILabel *)[cell viewWithTag:2];
    lblReceiveTime.text=[dicRow objectForKey:@"deptName"];
    return cell;
}

#pragma - UISearchBarDelegate delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     _searchContent=@"";
    [self loadData];
}


// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _searchContent=searchBar.text;
    [self loadData];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchContent=searchBar.text;
    [self loadData];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[_datasourceArray objectAtIndex:indexPath.row];
    
    [_expressDetailTableViewControllerDelegate modifyProxyPerson:[dic objectForKey:@"id"] proxyPersonName:[dic objectForKey:@"name"]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
