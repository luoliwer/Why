//
//  TerminalListViewController.m
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "TerminalListViewController.h"

@interface TerminalListViewController ()

@end

@implementation TerminalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArray = [[NSMutableArray alloc] init];
    [self initData];
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    _tableview.bounces = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
//    _listArray = [NSArray arrayWithObjects:@"个人",@"终端商", nil];
    [self.view addSubview:_tableview];
    [self configUI];
}
- (void)viewDidDisappear:(BOOL)animated{
    _listArray = nil;
}
// 初始化数据
- (void)initData{
    [HttpTask checkterminal:[GlobleData sharedInstance].userid sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *array = [dictionary objectForKey:@"list"];
            if (array && array.count > 0) {
                for (NSDictionary *dic in array) {
                    TerminalModel *model = [[TerminalModel alloc] init];
                    model.zdsid = [dic objectForKey:@"id"];
                    model.zdsName = [dic objectForKey:@"zdsmc"];
                    [_listArray addObject:model];
                }
                [self.tableview reloadData];
            }else{
                NSString *msg = [dictionary objectForKey:@"msg"];
                [self showMessage:msg];
            }
        }
        
    } failBlock:^(NSDictionary *errDic) {
        
    }];
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择终端商";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
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
    TerminalModel *model = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.zdsName;
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (_transValue) {
        _transValue([_listArray objectAtIndex:indexPath.row]);
    }
}

//自定义提示框
- (void)showMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 100;
    CGFloat h = size.height + 20;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = window.bounds.size.height - h - 50;
    showview.frame = CGRectMake(x, y, w, h);
    showview.backgroundColor = RGB(0, 0, 0, 0.7);
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, w, h);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = K_FONT_14;
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
