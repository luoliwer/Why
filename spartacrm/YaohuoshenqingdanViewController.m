//
//  YaohuoshenqingdanViewController.m
//  wly
//
//  Created by luolihacker on 16/5/2.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "YaohuoshenqingdanViewController.h"
#import "DaiyaohuoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface YaohuoshenqingdanViewController ()<UIWebViewDelegate>
@end

@implementation YaohuoshenqingdanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    [self.view addSubview:self.webView];
    NSString *uslStr = [NSString stringWithFormat:@"%@/remote/goods/getgood?userid=%@",REMOTE_URL,[GlobleData sharedInstance].userid];
    [self loadpage:uslStr];
    [self configUI];

}
// 加载页面
- (void)loadpage:(NSString *)urlStr{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scalesPageToFit = YES;
    
    [self.webView loadRequest:request];
    
    // JS同步调用OC方法
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"showMessage"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        NSString *message = [args[0] toString];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];

    };
    context[@"isSuccess"] = ^() {
        NSArray *args = [JSContext currentArguments];
        NSString *message = [args[0] toString];
        [self showMessage:message];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   
}

// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"要货申请单";
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
    [daiyaohuoBtn setTitle:@"代要货列表" forState:UIControlStateNormal];
    daiyaohuoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    daiyaohuoBtn.layer.cornerRadius = 4.0;
    daiyaohuoBtn.clipsToBounds = YES;
    [daiyaohuoBtn addTarget:self action:@selector(enterdaiyaohuoList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:daiyaohuoBtn];
    
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)enterdaiyaohuoList{
    DaiyaohuoViewController *vc = [[DaiyaohuoViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
//自定义提示框
- (void)showMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 30;
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
