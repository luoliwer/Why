//
//  AccountManagerViewController.m
//  wly
//
//  Created by luolihacker on 15/12/15.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "AppDelegate.h"
#import "PeopleNameTableViewCell.h"
#import "SystemUpdateTableViewCell.h"
#import "SeparatorTableViewCell.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "GlobleData.h"
#import "SystemUpdateViewController.h"
#import "ModifyCodeViewController.h"

@interface AccountManagerViewController ()

@end

@implementation AccountManagerViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self configUI];
    NSArray *viewArr = [self.view subviews];
    for (UIView *view in viewArr) {
        if (view.tag == 10086) {
            [view removeFromSuperview];
        }
    }

}

- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"账户管理";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    
    [navBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:navBar];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.center.y, self.view.frame.size.width, 40)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y, 300, 40)];
    [button setTitle:@"退出当前账户" forState:0];
    [button addTarget:self action:@selector(backCurrentAccount) forControlEvents:UIControlEventTouchUpInside];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
// 修改密码
    UIButton *modifyCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.center.y + 60, self.view.frame.size.width, 40)];
    [modifyCodeBtn setTitle:@"修改密码" forState:0];
    modifyCodeBtn.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [modifyCodeBtn addTarget:self action:@selector(enterModifyCodeVc) forControlEvents:UIControlEventTouchUpInside];
    
    [modifyCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [modifyCodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:modifyCodeBtn];

}

- (void)enterModifyCodeVc{
    ModifyCodeViewController *Vc = [[ModifyCodeViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 2) {
        SystemUpdateViewController *Vc = [[SystemUpdateViewController alloc] init];
        [self presentViewController:Vc animated:YES completion:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return 30;
    }else{
        return 60;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        switch (indexPath.row) {
            case 0:{
                cell = [[NSBundle mainBundle] loadNibNamed:@"PeopleNameTableViewCell" owner:nil options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                PeopleNameTableViewCell *Scell = (PeopleNameTableViewCell *)cell;
                Scell.nameLabel.text = [GlobleData sharedInstance].usrName;
                Scell.companyLabel.text = [GlobleData sharedInstance].companyName;
                
                break;
            }
            case 1:
            {
                cell = [[NSBundle mainBundle] loadNibNamed:@"SeparatorTableViewCell" owner:nil options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            }
            case 2:{
                cell = [[NSBundle mainBundle] loadNibNamed:@"SystemUpdateTableViewCell" owner:nil options:nil].lastObject;
                break;
            }
            default:
                break;
                
        }
    }
    return cell;
}
- (void)backCurrentAccount{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setValue:@"" forKey:@"usr.loginid"];
    [userDefaultes setValue:@"" forKey:@"usr.psw"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    
   }
@end
