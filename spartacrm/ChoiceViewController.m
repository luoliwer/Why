//
//  ChoiceViewController.m
//  wly
//
//  Created by luolihacker on 16/2/2.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "ChoiceViewController.h"

@interface ChoiceViewController ()

@end

@implementation ChoiceViewController
@synthesize tableview;
@synthesize listArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    tableview.bounces = NO;
    tableview.delegate = self;
    tableview.dataSource = self;
    listArray = [NSArray arrayWithObjects:@"酒水终端商",@"大型KA卖场",@"高端餐饮店", nil];
    [self.view addSubview:tableview];
    [self configUI];
    // Do any additional setup after loading the view.
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"选择类型";
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
// 设置渐变颜色
- (CAGradientLayer *)shadowAsInverse{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(20, 300, self.view.frame.size.width - 40, 44);
    newShadow.frame = newShadowFrame;
    
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
    return newShadow;
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
    return listArray.count;
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
 
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [GlobleData sharedInstance].typeName = [tableview cellForRowAtIndexPath:indexPath].textLabel.text;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
