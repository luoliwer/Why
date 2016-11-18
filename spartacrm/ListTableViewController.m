//
//  OrderTableViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-4.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "ListTableViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HttpTask.h"

@interface ListTableViewController (){
}

@end

@implementation ListTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UIView * _lineView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    _lineView.backgroundColor=UIColorFromRGB(0xeeeeee);
    
    
    _lblShowMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, WIDTH, 40)];
    _lblShowMore.text=@"当前无数据";
    _lblShowMore.textAlignment=NSTextAlignmentCenter;
    _lblShowMore.font = [UIFont systemFontOfSize:12];
    _lblShowMore.textColor =  UIColorFromRGB(0x333333);
    
    
    
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSubmit.frame = CGRectMake(30, 10, WIDTH-60, 35);
  
    [_btnSubmit setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],@"btn-bgblue.png"]] forState:UIControlStateNormal];
    _btnSubmit.showsTouchWhenHighlighted = YES;
    
    [_btnSubmit addTarget:self action:@selector(btnSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
    
  


    
    
   
     _viewForFooter= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    
    [_viewForFooter addSubview:_lineView];
    [_viewForFooter addSubview:_lblShowMore];
    [_viewForFooter addSubview:_btnSubmit];
    
    [_btnSubmit setHidden:true];
    _table.tableFooterView=_viewForFooter;
    //初始化table的部分设置
//    _table.tableHeaderView=_searchBar;
    
    
//    _table.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
//    _table.contentOffset=CGPointMake(_table.contentOffset.x, 90);
    
    
    //设置UITableView控件的delegate、dataSource都是该控制器本身
	_table.delegate = self;
	_table.dataSource = self;
//	_searchBar.delegate	= self;
    
    
    // 设置refreshControl属性，该属性值应该是UIRefreshControl控件
	self.refreshControl = [[UIRefreshControl alloc]init];
	self.refreshControl.tintColor = [UIColor grayColor];
	self.refreshControl.attributedTitle = [[NSAttributedString alloc]  initWithString:@"下拉刷新"];
	[self.refreshControl addTarget:self action:@selector(updateFirstPageData)  forControlEvents:UIControlEventValueChanged];
    
    
    //初始化部分参数
    _datasourceArray=[[NSMutableArray alloc] init];
    _loadding=NO;
    _hasNext=YES;
    _listUpdatePolicy=ListUpdatePolicyRefresh;
    [self initParam];
    
    [self updateFirstPageData];
}


- (void)btnSubmitClick:(id)sender {
    NSLog(@"a");
}

-(void) initParam{
    _selectedIndex=0;
    
    _pageIndex=1;
    _pageSize=15;
    _searchType=SearchTypeNone;
    _searchContent=@"";
}



#pragma - actions

/*
 * @brief 加载服务器端数据至_datasourceArray
 *
 */

- (void)  updateFirstPageData{
    _pageIndex=1;
    _listUpdatePolicy=ListUpdatePolicyRefresh;
    [self.refreshControl beginRefreshing];
    [self loadData];
}

- (void) loadData
{
    _loadding=YES;
    
    [HttpTask officeOrders:_pageIndex pageSize:_pageSize  sucessBlock:^(NSString * jsonString) {
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


-(void) updateData:(NSMutableArray *) contents {
    if (_listUpdatePolicy==ListUpdatePolicyRefresh) {
        [_datasourceArray removeAllObjects];
    }
    
    for (int i=0;i<[contents count];i++) {
        BOOL found = NO;
        NSDictionary *c1 = [contents objectAtIndex:i];
        
        NSDictionary *c2;
        for (int j=0;j<[_datasourceArray count];j++) {
            c2 = [_datasourceArray objectAtIndex:j];
            
            if ([[c1 objectForKey:@"id"] isEqualToString:[c2 objectForKey:@"id"]]) {
                [_datasourceArray replaceObjectAtIndex:j withObject:c1];
                found = YES;
                break;
            }
        }
        
        if (!found) {
            [_datasourceArray addObject:c1];
        }
    }
    
//    _datasourceArray = [[_datasourceArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//        NSDate *first = [(NSDictionary*)a objectForKey:@"id"];
//        NSDate *second = [(NSDictionary*)b objectForKey:@"id"];
//        return [first compare:second];
//    }] mutableCopy];
    
    [_table reloadData];
    _loadding=NO;
    [self changeRefreshOrMoreStatus];
    
}

- (void) changeRefreshOrMoreStatus
{
    if (_listUpdatePolicy==ListUpdatePolicyRefresh) {  //!<下拉
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新..."];
        [self.refreshControl endRefreshing];
        
        
        if (_hasNext) {
            _lblShowMore.text=@"继续下拉加载下一页";
        } else {
            _lblShowMore.text=@"已加载全部数据";
        }

    } else {
        // 控制表格重新加载数据
        [self.tableView reloadData];
        [self.tableView  endUpdates];
        
        if (_hasNext) {
            _lblShowMore.text=@"继续下拉加载下一页";
        } else {
            _lblShowMore.text=@"已加载全部数据";
        }
    }
    
}

#pragma - TableViewContorll delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedIndex=indexPath.row;
    
}




#pragma - UIScrollView delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(scrollView.contentOffset.y>0 && (scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height+10))){
        
        if (!_loadding  && _hasNext) {
            _listUpdatePolicy=ListUpdatePolicyNextPage;
            _lblShowMore.text=@"数据加载中";
            _pageIndex++;
            [self loadData];
        }
        
        
    }
}


#pragma - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _datasourceArray.count;
}





#pragma - UISearchBarDelegate delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.table reloadData];
}


// UISearchBarDelegate定义的方法，用户单击虚拟键盘上Search按键时激发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	
	[searchBar resignFirstResponder];
}





@end
