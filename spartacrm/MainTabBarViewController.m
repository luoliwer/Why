//
//  MainTabBarViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-8.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ScanViewController.h"
#import "APPCollectionViewCell.h"
#import "TongjibaobiaoViewController.h"
#import "AppModel.h"
#import "YaohuoshenqingdanViewController.h"
#import "AccountManagerViewController.h"
#import "ScanPhoneSendViewController.h"
#import "GlobleData.h"
#import "DiaohuofahuoViewController.h"
#import "CheckUIVIViewController.h"
#import "DaiShouHuoViewController.h"
#import "DaiFahuoViewController.h"
#import "CheckUIVIViewController.h"
#import "sendScanViewControlller.h"
#import "TerminalAccountApplyViewController.h"
#import "DiaohuoshouhuoViewController.h"
#import "TuihuoViewController.h"
#import "VerifyAccountViewController.h"

@interface MainTabBarViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    UIView *nameView;
    NSMutableArray *appArray;
    AppModel *model;
    
}
@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    model = [[AppModel alloc] init];
    appArray = [GlobleData sharedInstance].appArray;
    self.tabBarController.delegate = (id)self;
    [self setDelegate:self];
    
    
    UIViewController *appController = [[UIViewController alloc] init];
    appController.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    appController.tabBarItem.title = @"应用中心";
    AccountManagerViewController *managerController = [[AccountManagerViewController alloc] init];
    managerController.tabBarItem.title = @"账户管理";
    managerController.tabBarItem.image = [UIImage imageNamed:@"bottom-me@2x"];
    self.viewControllers = @[appController,managerController];
    
    appController.tabBarItem.image = [UIImage imageNamed:@"bottom-apps2@2x"];
    UILabel *title = [[UILabel alloc]initWithFrame:appController.view.bounds];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"应用中心";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    [navBar pushNavigationItem:navItem animated:NO];
    
    [appController.view addSubview:navBar];
    
    appController.navigationController.title = @"应用中心";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
    UIImage *image = [UIImage imageNamed:@"main.jpg"];
    [imageView setImage:image];
    [appController.view addSubview:imageView];
    
    //创建登录用户显示条
    nameView = [[UIView alloc] initWithFrame:CGRectMake(0, 214, self.view.frame.size.width, 44)];
    nameView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:nameView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, nameView.frame.size.width - 12, 44)];
    nameLabel.text = [GlobleData sharedInstance].usrName;
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [nameView addSubview:nameLabel];
    
    // 创建UICollectionView
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 1.0;
    flowLayout.minimumLineSpacing = 1.0;
    self.collecView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 258, appController.view.frame.size.width, appController.view.frame.size.height - 64 - 44 - 200) collectionViewLayout:flowLayout];
    self.collecView.bounces = NO;
    self.collecView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.collecView.delegate = self;
    self.collecView.dataSource = self;
    [self.collecView registerClass:[APPCollectionViewCell class] forCellWithReuseIdentifier:@"appcell"];
    [self.view addSubview:self.collecView];
    
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    model = [appArray objectAtIndex:indexPath.row];
    if ([model.appName isEqualToString:@"收货"]) {
        [self receiveProduct];
    }else if ([model.appName isEqualToString:@"发货"]){
        [self sendProduct];
    }else if ([model.appName isEqualToString:@"调货发货"]){
        [self middleSendBtn];
    }else if ([model.appName isEqualToString:@"调货收货"]){
        [self transferReceive];
    }else if ([model.appName isEqualToString:@"代要货"]){
        [self enterYaohuoshenqing];
    }else if ([model.appName isEqualToString:@"终端账号申请"]){
        [self terminalAccountApply];
    }else if ([model.appName isEqualToString:@"溯源查询"]){
        [self check];
    }else if ([model.appName isEqualToString:@"统计报表"]){
        [self entertongjibaobiao];
    }else if([model.appName isEqualToString:@"销售"]){
        [self enterxiaoshouPage];
    }else if ([model.appName isEqualToString:@"退货"]){
        [self entertuihuo];
    }else if ([model.appName isEqualToString:@"终端账号审核"]){
        [self enterzdzhshList];
    }
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return appArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    APPCollectionViewCell *cell = (APPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"appcell" forIndexPath:indexPath];
    model = [appArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.appIcon.image = model.appIcon;
    cell.appName.text = model.appName;
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.collecView.frame.size.width - 2.0) / 3.0, (self.collecView.frame.size.width - 2.0) * 0.8 / 3.0);
}

- (void)pressNew{
    DaiShouHuoViewController *Vc = [[DaiShouHuoViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [GlobleData sharedInstance].isDiaohuoshouhuoBtn = NO;
    [self.navigationItem setHidesBackButton:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 收货
- (void)receiveProduct{
    DaiShouHuoViewController *VC = [[DaiShouHuoViewController alloc] init];
    [GlobleData sharedInstance].dealtype = @"2";
    [self presentViewController:VC animated:YES completion:nil];
    
}

// 进入调货收货页面
- (void)transferReceive{
    [GlobleData sharedInstance].isDiaohuoshouhuoBtn = YES;
    [GlobleData sharedInstance].dealtype = @"3";
    DiaohuoshouhuoViewController *VC = [[DiaohuoshouhuoViewController alloc] init];
    [self presentViewController:VC animated:YES completion:nil];
}

// 进入发货页面
- (void)sendProduct{
    [GlobleData sharedInstance].dealtype = @"0";
    DaiFahuoViewController *sendVc = [[DaiFahuoViewController alloc] init];
    [self presentViewController:sendVc animated:NO completion:nil];
}

// 进入代要货页面
- (void)enterYaohuoshenqing{
    
    YaohuoshenqingdanViewController *Vc = [[YaohuoshenqingdanViewController alloc] init];
    [self presentViewController:Vc animated:NO completion:nil];
}
// 进入销售扫描页面
- (void)enterxiaoshouPage{
    [GlobleData sharedInstance].dealtype = @"4";
    NSString *xiaoshouKey = [[GlobleData sharedInstance].userid stringByAppendingString:[GlobleData sharedInstance].dealtype];
    NSUserDefaults *userfalut = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userfalut objectForKey:xiaoshouKey];
    if (array && array.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本地有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
        [alertView show];
    }else{
        ScanPhoneSendViewController *scanViewVc = [[ScanPhoneSendViewController alloc] init];
        [self presentViewController:scanViewVc animated:YES completion:nil];
    }
}

// 进入退货页面
- (void)entertuihuo{
    [GlobleData sharedInstance].dealtype = @"6";
    TuihuoViewController *vc = [[TuihuoViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

// 进入溯源查询页面
- (void)check{
    [GlobleData sharedInstance].ischeck = NO;
    CheckUIVIViewController *checkVc = [[CheckUIVIViewController alloc] init];
    [self presentViewController:checkVc animated:NO completion:nil];
}

// 进入调货发货页面
- (void)middleSendBtn{
    [GlobleData sharedInstance].isMiddleSendBtn = YES;
    [GlobleData sharedInstance].dealtype = @"1";
    DiaohuofahuoViewController *Vc = [[DiaohuofahuoViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}

// 进入终端账号申请页面
- (void)terminalAccountApply{
    TerminalAccountApplyViewController *Vc = [[TerminalAccountApplyViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}

// 进入统计报表页面
- (void)entertongjibaobiao{
    TongjibaobiaoViewController *Vc = [[TongjibaobiaoViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}

// 进入终端账号审核列表
- (void)enterzdzhshList{
    VerifyAccountViewController *vc = [[VerifyAccountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int index = self.selectedIndex;
    switch (index) {
        case 0:
            nameView.hidden = NO;
            self.collecView.hidden = NO;
            break;
            
        default:
            nameView.hidden = YES;
            self.collecView.hidden = YES;
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            NSString *xiaoshouKey = [[GlobleData sharedInstance].userid stringByAppendingString:[GlobleData sharedInstance].dealtype];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:xiaoshouKey];
            [userdefault synchronize];
            ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
        default:
        {
            ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
    }

}
@end
