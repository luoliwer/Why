//
//  DiaohuofahuoViewController.m
//  wly
//
//  Created by luolihacker on 16/1/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "DiaohuofahuoViewController.h"
#import "dispatchTableViewCell.h"
#import "receiveCompanyTableViewCell.h"
#import "MainTabBarViewController.h"
#import "CompanyListViewController.h"
#import "GlobleData.h"
#import "MBProgressHUD.h"
#import "ScanPhoneSendViewController.h"
#import "HttpTask.h"
#import "FahuoListViewController.h"
#import "TerminalModel.h"
@interface DiaohuofahuoViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UITextView *textview;
    NSString *key;
}

@end

@implementation DiaohuofahuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self configUI];
}

// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"发货单";
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
    
    UIButton *daiyaohuoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 28, 70, 25)];
    daiyaohuoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    daiyaohuoBtn.layer.borderWidth = 0.5;
    [daiyaohuoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [daiyaohuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [daiyaohuoBtn setTitle:@"发货列表" forState:UIControlStateNormal];
    daiyaohuoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    daiyaohuoBtn.layer.cornerRadius = 4.0;
    daiyaohuoBtn.clipsToBounds = YES;
    [daiyaohuoBtn addTarget:self action:@selector(enterfahuoList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:daiyaohuoBtn];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 80, self.view.frame.size.height - 36, 160, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(changeToScanPhoneView) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"开始扫描" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    
    //设置备注框
    textview = [[UITextView alloc] initWithFrame:CGRectMake(8, 106, self.view.frame.size.width - 16, 50)];
    textview.text = @"请输入车牌号";
    textview.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textview.backgroundColor = [UIColor whiteColor];
    textview.layer.borderWidth = 2.0;
    textview.layer.borderColor = [UIColor orangeColor].CGColor;
    textview.delegate = self;
    textview.font = [UIFont fontWithName:@"Arial" size:16];
    textview.returnKeyType = UIReturnKeyDefault;
    textview.keyboardType = UIKeyboardTypeDefault;
    textview.textAlignment = NSTextAlignmentLeft;
    textview.textColor = [UIColor blackColor];
    [self.view addSubview:textview];
}

// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [textview resignFirstResponder];
}
#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入车牌号";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tableView reloadData];
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *receiveId = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].receiveCompanyId];
    if (receiveId == nil) {
        return;
    }
    key = [[userid stringByAppendingString:receiveId] stringByAppendingString:[GlobleData sharedInstance].dealtype];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.view.window == nil) {
        self.view = nil;
    }
}

#pragma mark -- tableView data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        
        [HttpTask verifyCangKu:[GlobleData sharedInstance].userid sucessBlock:^(NSString *responseStr) {
            @try {
                NSError *error;
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                NSString *status=[dictionary objectForKey:@"status"];
                
                if ([status isEqualToString:@"1"]) {
                    NSArray *array = [[NSArray alloc] init];
                    array = [dictionary objectForKey:@"logisticsInfos"];
                    [GlobleData sharedInstance].cangKuListArray = array;
                    NSMutableArray *cangKuList = [[NSMutableArray alloc] init];
                    for (NSDictionary *cangKuInfoDic in array) {
                        TerminalModel *model = [[TerminalModel alloc] init];
                        model.zdsName = [cangKuInfoDic objectForKey:@"logistics_name"];
                        model.zdsid = [cangKuInfoDic objectForKey:@"logistics_id"];
                        [cangKuList addObject:model];
                        
                    }
                    
                    [GlobleData sharedInstance].receivecompanyList = cangKuList;
                    CompanyListViewController *Vc = [[CompanyListViewController alloc] init];
                    [self presentViewController:Vc animated:YES completion:nil];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示！" message:@"没有收货仓库信息列表。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                    [GlobleData sharedInstance].receivecompanyList = nil;
                    CompanyListViewController *Vc = [[CompanyListViewController alloc] init];
                    [self presentViewController:Vc animated:YES completion:nil];
                    
                }
            }
            @finally {
            }
        } failBlock:^(NSDictionary *dicErr) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        switch (indexPath.row) {
            case 0:{
                cell = [[NSBundle mainBundle] loadNibNamed:@"receiveCompanyTableViewCell" owner:nil options:nil].lastObject;
                receiveCompanyTableViewCell *Scell =(receiveCompanyTableViewCell *)cell;
                Scell.receiveCompanyLabel.text = [GlobleData sharedInstance].receiveCompanyName;
                break;
            }
            case 1:{
              
            }
            default:
                break;
        }
    }
    
    return cell;
    
}
- (void)changeToScanPhoneView{
    
    if ([GlobleData sharedInstance].receiveCompanyName == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"收货仓库不能为空，请选择收货单位。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSArray *dataArray = [userdefault objectForKey:key];
        if (dataArray && dataArray.count > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本地有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
            alertView.tag = 201608;
            [alertView show];
        }else{
            ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
            if ([textview.text isEqualToString:@""] || [textview.text isEqualToString:@"请输入车牌号"]) {
                VC.chepaihao = @"";
            }else{
                VC.chepaihao = textview.text;
            }
            [self presentViewController:VC animated:YES completion:nil];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 201608) {
        switch (buttonIndex) {
            case 1:
            {
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault removeObjectForKey:key];
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
    
}
- (void)backforward{
    [GlobleData sharedInstance].receiveCompanyName = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 进入发货列表
- (void)enterfahuoList{
    FahuoListViewController *Vc = [[FahuoListViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
}

@end
