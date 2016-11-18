//
//  CompanyListViewController.m
//  wly
//
//  Created by luolihacker on 15/12/25.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "CompanyListViewController.h"
#import "GlobleData.h"
#import "TerminalModel.h"
@interface CompanyListViewController ()

@end

@implementation CompanyListViewController
@synthesize listData=_listData;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.listData = [GlobleData sharedInstance].receivecompanyList;
    NSLog(@"sharedInstance].receivecompanyList.count = %d",[GlobleData sharedInstance].receivecompanyList.count);
    NSLog(@"listData = %@",self.listData);
    [self configUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"公司列表";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    navItem.titleView.frame = CGRectMake(self.view.center.x - 100, navBar.center.y - 10, 60, 20);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
    
}

#pragma mark -- tableView data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TerminalModel *model = [self.listData objectAtIndex:indexPath.row];
    [GlobleData sharedInstance].receiveCompanyName = model.zdsName;
    [GlobleData sharedInstance].receiveCompanyId = model.zdsid;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }else{
        // 删除cell中的子对象,刷新覆盖问题
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TerminalModel *model = [self.listData objectAtIndex:indexPath.row];
    cell.textLabel.text = model.zdsName;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
