//
//  AccountVerifyViewController.m
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "AccountVerifyViewController.h"

@interface AccountVerifyViewController ()
{
    UIWebView *webView;
    NSString *op; // 是否通过
}
@end

@implementation AccountVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    [self.view addSubview:webView];
    NSString *uslStr = [NSString stringWithFormat:@"%@/remote/goods/getZhongDuanRegistBillDetails?userid=%@&billid=%@",REMOTE_URL,[GlobleData sharedInstance].userid,self.billid];
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

- (void)configUI{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"账号审核";
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
    [self.view addSubview:bottomView];
    
    UIButton *passBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 36, 130, 30)];
    passBtn.backgroundColor = [UIColor redColor];
    [passBtn addTarget:self action:@selector(pass) forControlEvents:UIControlEventTouchUpInside];
    [passBtn setTitle:@"通过" forState: UIControlStateNormal];
    passBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:passBtn];
    
    UIButton *notpassBtn = [[UIButton alloc] initWithFrame:CGRectMake(178 , self.view.frame.size.height - 36, 130, 30)];
    notpassBtn.backgroundColor = [UIColor redColor];
    [notpassBtn addTarget:self action:@selector(notpass) forControlEvents:UIControlEventTouchUpInside];
    [notpassBtn setTitle:@"不通过" forState: UIControlStateNormal];
    notpassBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:notpassBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 通过
- (void)pass{
    op = @"1";
    [self commit];
}
// 不通过
- (void)notpass{
   op = @"0";
   [self commit];
}
// 提交
- (void)commit{
   [HttpTask zdzhCommit:[GlobleData sharedInstance].userid billid:self.billid op:op sucessBlock:^(NSString *responseStr) {
       NSError *error;
       NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
       NSString *status = [dictionary objectForKey:@"is_abnormal"];
       if ([status isEqualToString:@"1"]) {
           [self showMessage:@"操作成功"];
       }else{
           [self showMessage:@"操作失败"];
       }
       [self dismissViewControllerAnimated:NO completion:nil];
   } failBlock:^(NSDictionary *errDic) {
       
   }];
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
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
