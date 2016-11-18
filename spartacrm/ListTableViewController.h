//
//  ListTableViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-6.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate ,UISearchBarDelegate,UIScrollViewDelegate>{
    int _pageSize;
    int _pageIndex;
    SearchType _searchType;
    NSString * _searchContent;
    bool _loadding;//!<是否正在加载中。
    bool _hasNext;//!<是否具有下一页。
    ListUpdatePolicy _listUpdatePolicy;  //设置当前列表的操作类型，是下拉还是上推
    
    int _selectedIndex;
    UIView * _viewForFooter;
    
    UILabel * _lblShowMore;
    UIButton * _btnSubmit;
    NSMutableArray * _datasourceArray; //!<保存原始表格数据的NSArray对象。
}

    // @property (weak, nonatomic)  UISearchBar *searchBar;
    @property (strong, nonatomic)  UITableView *table;

    -(void) initParam;
    -(void) loadData;
    -(void) updateFirstPageData;
    -(void) updateData:(NSMutableArray *) contents ;

@end
