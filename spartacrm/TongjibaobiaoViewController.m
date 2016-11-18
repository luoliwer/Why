//
//  TongjibaobiaoViewController.m
//  wly
//
//  Created by luolihacker on 16/5/3.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "TongjibaobiaoViewController.h"

@interface TongjibaobiaoViewController ()
{
    UIWebView *webView;
}

@end

@implementation TongjibaobiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:webView];
    NSString *uslStr = [NSString stringWithFormat:@"%@/remote/goods/report?userid=%@",REMOTE_URL,[GlobleData sharedInstance].userid];
    [self loadpage:uslStr];
    [self configUI];
    
}
// 加载页面
- (void)loadpage:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    webView.scrollView.bounces = NO;
    webView.scrollView.showsHorizontalScrollIndicator = YES;
    webView.scrollView.showsVerticalScrollIndicator = YES;
    webView.scrollView.scrollEnabled = YES;
    webView.scalesPageToFit = YES;
    
    [webView loadRequest:request];
}

// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"统计报表";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
