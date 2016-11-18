//
//  CheckUIVIViewController.m
//  wly
//
//  Created by luolihacker on 16/1/25.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "CheckUIVIViewController.h"
#import "ScanViewController.h"


@interface CheckUIVIViewController ()<UITextFieldDelegate,UIViewPassValueDelegate>
{
    UIButton *scanGunBtn;
    UITextField *textfield;
    UIButton *clickScanBtn;
    BOOL isScanPhoneBtn;
    NSString *commodity;
    UIWebView *webView;
}

@end

@implementation CheckUIVIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 104)];
    webView.backgroundColor = [UIColor redColor];
    [self.view addSubview:webView];
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self configUI];
}
-(void)viewDidAppear:(BOOL)animated{
    if (commodity) {
        NSString *uslStr = [NSString stringWithFormat:@"%@/remote/order/list?userid=%@&commodity_ids=%@",REMOTE_URL,[GlobleData sharedInstance].userid,commodity];
        [self loadpage:uslStr];
    }
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
    title.text = @"溯源查询";
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
    scanGunBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height -36, 34, 30)];
    [scanGunBtn addTarget:self action:@selector(changeToScanGun) forControlEvents:UIControlEventTouchUpInside];
    [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0028.jpg"] forState:UIControlStateNormal];
    
    textfield = [[UITextField alloc] init];
    textfield.delegate = self;
    textfield.frame = CGRectMake(58, scanGunBtn.frame.origin.y, self.view.bounds.size.width - 70, 30);
    [textfield setText:@"扫描中..."];
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.layer.borderWidth = 1.5;
    textfield.layer.borderColor = [UIColor orangeColor].CGColor;
    
    clickScanBtn = [[UIButton alloc] initWithFrame:CGRectMake(58, scanGunBtn.frame.origin.y, self.view.bounds.size.width - 70, 30)];
    clickScanBtn.backgroundColor = [UIColor redColor];
    [clickScanBtn setTitle:@"点击扫描" forState:UIControlStateNormal];
    [clickScanBtn addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    clickScanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    [self.view addSubview:scanGunBtn];
    [self.view addSubview:textfield];
    [self.view addSubview:clickScanBtn];
    
}
// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [avalue CGRectValue];
    CGFloat higth = rect.size.height;
    CGFloat y = textfield.frame.origin.y + 44 + higth - self.view.frame.size.height;
    self.view.frame = CGRectMake(0, - y, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [textfield resignFirstResponder];
    //    self.textfield.text = @"扫描中...";
}

- (void)changeToScanGun
{
    if (isScanPhoneBtn) {
        clickScanBtn.hidden = NO;
        textfield.hidden = YES;
        [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0028.jpg"] forState:UIControlStateNormal];
    }else{
        [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0029.jpg"] forState:UIControlStateNormal];
        clickScanBtn.hidden = YES;
        textfield.hidden = NO;
    }
    isScanPhoneBtn = !isScanPhoneBtn;
    
}
#pragma mark -- UITextFieldDelegate

// 响应输入框的回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textfield resignFirstResponder];
    commodity = textfield.text;
    NSString *stringUrl = [NSString stringWithFormat:@"%@/remote/order/list?userid=%@&commodity_ids=%@",REMOTE_URL,[GlobleData sharedInstance].userid,commodity];
    [self loadpage:stringUrl];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textfield.text = @"";
}

// 点击扫描按钮
- (void)clickScan{
    
    ScanViewController *viewVC = [[ScanViewController alloc] init];
    viewVC.delegate = self;
    [self presentViewController:viewVC animated:YES completion:nil];
}

- (void)passValue:(NSString *)value{
    commodity = value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backforward{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
