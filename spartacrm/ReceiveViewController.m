//
//  ReceiveViewController.m
//  wly
//
//  Created by luolihacker on 15/12/15.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "ReceiveViewController.h"
#import "DingdanTableViewCell.h"
#import "FahuoDanweiTableViewCell.h"
#import "ServiceNumberTableViewCell.h"
#import "ShouhuoDanweiTableViewCell.h"
#import "FenLeiTableViewCell.h"
#import "ProductTableViewCell.h"
#import "LastCellTableViewCell.h"
#import "ScanPhoneViewController.h"
#import "ScanViewController.h"
#import "MainTabBarViewController.h"
#import "GlobleData.h"
#import "CompanyListViewController.h"
#import "GlobleData.h"
#import "MBProgressHUD.h"
#import "HttpTask.h"

@interface ReceiveViewController ()<UIAlertViewDelegate,UIWebViewDelegate>
{
    NSString *JSON;
}
@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    [self.view addSubview:self.webView];
    
    [self configUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *usrid = [GlobleData sharedInstance].userid;
    NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
    billid = [NSString stringWithFormat:@"%@",billid];
    NSString *userkey = [[usrid stringByAppendingString:billid] stringByAppendingString:[GlobleData sharedInstance].dealtype];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefault objectForKey:userkey];
    JSON = [dic objectForKey:@"JSON"];
    if ([GlobleData sharedInstance].isdiaohuofahuocommodity) {
        // 进入调货收货列表里的收货单
        NSString *uslStr = [NSString stringWithFormat:@"%@/remote/goods/getDiaoHuoBillDetails?userid=%@&billid=%@&type=%@",REMOTE_URL,[GlobleData sharedInstance].userid,[GlobleData sharedInstance].daishouhuoCommodity_id,[GlobleData sharedInstance].type];
        [self loadpage:uslStr];
        
    }else{
        // 进入收货列表里的收货单
        NSString *urlStr =[NSString stringWithFormat:@"%@/remote/goods/info?userid=%@&billid=%@&type=%@",REMOTE_URL,[GlobleData sharedInstance].userid,[GlobleData sharedInstance].daishouhuoCommodity_id,[GlobleData sharedInstance].type];
        [self loadpage:urlStr];
    }

}

// 加载页面
- (void)loadpage:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *textJS = [NSString stringWithFormat:@"initDone('%@')",JSON];
    
    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
}

- (void)viewWillAppear:(BOOL)animated{
    if ([[GlobleData sharedInstance].type isEqualToString:@"1"]) {
        return;
    }
    NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
    if ([GlobleData sharedInstance].isdiaohuofahuocommodity){
        [HttpTask diaohuoshouhuoDetail:[GlobleData sharedInstance].userid billid:billid type:[GlobleData sharedInstance].type sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSRange start = [responseStr rangeOfString:@"["];
            NSRange end = [responseStr rangeOfString:@"]"];
            NSString *string = [responseStr substringWithRange:NSMakeRange(start.location , end.location - start.location + 1)];
            [GlobleData sharedInstance].diaohuoshouhuoJSON = string;
            [GlobleData sharedInstance].num = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"num"]];
            [GlobleData sharedInstance].pingCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"nump"]];
        } failBlock:^(NSDictionary *errDic) {
            
        }];
    }else{
        [HttpTask getFahuoData:billid userid:[GlobleData sharedInstance].userid type:[GlobleData sharedInstance].type sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSRange start = [responseStr rangeOfString:@"["];
            NSRange end = [responseStr rangeOfString:@"]"];
            NSString *string = [responseStr substringWithRange:NSMakeRange(start.location , end.location - start.location + 1)];
            [GlobleData sharedInstance].shouhuoJSON = string;
            [GlobleData sharedInstance].num = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sl"]];
            [GlobleData sharedInstance].pingCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"slp"]];
            
            NSLog(@"%@",[GlobleData sharedInstance].num);
        } failBlock:^(NSDictionary *errDic) {
            NSLog(@"出错了！");
        }];
    }
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    if ([GlobleData sharedInstance].isDiaohuoshouhuoBtn) {
        title.text = @"调货单";
    }else{
        title.text = @"收货单";
    }
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
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 36, 130, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(changeToPhone) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"手机扫描收货" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(178 , self.view.frame.size.height - 36, 130, 30)];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(changeToScanGunReceive) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"扫描枪收货" forState: UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    if ([GlobleData sharedInstance].isDidGet) {
    }else{
        [self.view addSubview:button];
        [self.view addSubview:button2];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 手机扫描收货
- (void)changeToPhone{
    [GlobleData sharedInstance].clickScanGunFaHuoBtn = NO;
    NSString *usrid = [GlobleData sharedInstance].userid;
    NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
    billid = [NSString stringWithFormat:@"%@",billid];
    NSString *usrkey = [[usrid stringByAppendingString:billid] stringByAppendingString:[GlobleData sharedInstance].dealtype];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userdefault objectForKey:usrkey];
    if (dic) {
        NSArray *array = [dic objectForKey:@"listData"];
        if (array.count != 0 && array != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本单有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
            alertView.tag = 201609;
            [alertView show];
        }else{
            ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
            [self presentViewController:VC animated:YES completion:nil];
        }
    }else{
        
        ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
    
}

// 扫描枪收货
- (void)changeToScanGunReceive{
    
    [GlobleData sharedInstance].clickScanGunFaHuoBtn = YES;
    NSString *usrid = [GlobleData sharedInstance].userid;
    NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
    billid = [NSString stringWithFormat:@"%@",billid];
    NSString *usrkey = [[usrid stringByAppendingString:billid] stringByAppendingString:[GlobleData sharedInstance].dealtype];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userdefault objectForKey:usrkey];
    if (dic) {
        NSArray *array = [dic objectForKey:@"listData"];
        if (array.count != 0 && array != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本单有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
            alertView.tag = 201609;
            [alertView show];
        }else{
            ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
            [self presentViewController:VC animated:YES completion:nil];
        }
    }else{
        
        ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 201609) {
        switch (buttonIndex) {
            case 1:
            {
                NSString *usrid = [GlobleData sharedInstance].userid;
                NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
                billid = [NSString stringWithFormat:@"%@",billid];
                NSString *usrkey = [[usrid stringByAppendingString:billid] stringByAppendingString:[GlobleData sharedInstance].dealtype];
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault removeObjectForKey:usrkey];
                [userdefault synchronize];
                
                ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
                [self presentViewController:VC animated:YES completion:nil];
            }
                break;
            default:
            {
                ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
                [self presentViewController:VC animated:YES completion:nil];
            }
                break;
        }
    }
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
