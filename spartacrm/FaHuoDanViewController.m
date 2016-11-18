//
//  FaHuoDanViewController.m
//  wly
//
//  Created by luolihacker on 16/4/19.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "FaHuoDanViewController.h"
#import "ScanPhoneSendViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface FaHuoDanViewController ()<UITextViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    UITextField *licensenumTextField;
    UITextView *textview;
    NSString *JSON;
    NSString *billid;
    NSString *key;
}

@end

@implementation FaHuoDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JSON = [[NSString alloc] init];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 164)];
    [self.view addSubview:self.webView];
    
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

- (void)diaoJS{
    
    NSString *textJS = [NSString stringWithFormat:@"initDone('%@')",JSON];
    
    [self.webView stringByEvaluatingJavaScriptFromString:textJS];
}
- (void)viewDidAppear:(BOOL)animated{
    
    NSString *billidKey = [NSString stringWithFormat:@"%@",billid];
    key = [[[GlobleData sharedInstance].userid stringByAppendingString:billidKey] stringByAppendingString:[GlobleData sharedInstance].dealtype];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userdefault objectForKey:key];
    JSON = [dic objectForKey:@"JSON"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/remote/goods/getyaohuoinfo?userid=%@&billid=%@&type=%@",REMOTE_URL,[GlobleData sharedInstance].userid,[GlobleData sharedInstance].daishouhuoCommodity_id,[GlobleData sharedInstance].type];
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
    [self diaoJS];
}
- (void)viewWillAppear:(BOOL)animated{
    // 如果是调货发货就直接return
    if ([[GlobleData sharedInstance].dealtype isEqualToString:@"1"]) {
        return;
    }
    billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
    NSString *type = [GlobleData sharedInstance].type;
    [HttpTask getYahuoData:billid userid:[GlobleData sharedInstance].userid type:type sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSRange start = [responseStr rangeOfString:@"["];
        NSRange end = [responseStr rangeOfString:@"]"];
        NSString *string = [responseStr substringWithRange:NSMakeRange(start.location , end.location - start.location + 1)];
        [GlobleData sharedInstance].fahuoJSON = string;
        [GlobleData sharedInstance].fahuobillid = billid;
        [GlobleData sharedInstance].num = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"count"]];
        [GlobleData sharedInstance].pingCount = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"countp"]];

    } failBlock:^(NSDictionary *error) {
        
    }];
}
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
    
    //设置备注框
    textview = [[UITextView alloc] initWithFrame:CGRectMake(12, self.view.bounds.size.height - 95, self.view.frame.size.width - 24, 50)];
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
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height - 36, 130, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(phoneScanSend) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"手机扫描发货" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(178 , self.view.frame.size.height - 36, 130, 30)];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(scanGunSend) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"扫描枪发货" forState: UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    if ([GlobleData sharedInstance].isDidSend) {
    }else{
        [self.view addSubview:textview];
        [self.view addSubview:button];
        [self.view addSubview:button2];
    }
}

// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [avalue CGRectValue];
    CGFloat higth = rect.size.height;
    CGFloat y = textview.frame.origin.y + 44 + higth - self.view.frame.size.height;
    self.view.frame = CGRectMake(0, - y, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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

// 手机扫描发货
-(void)phoneScanSend{
    
    [GlobleData sharedInstance].clickScanGunFaHuoBtn = NO;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic =  [userdefault objectForKey:key];
    if (dic) {
        NSArray *array = [dic objectForKey:@"listData"];
        if (array.count != 0 && array != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本单有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
            alertView.tag = 1010101;
            [alertView show];
        }else{
            ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
            [self presentViewController:VC animated:YES completion:nil];
        }
    }else{
        ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
    if (![textview.text isEqualToString:@""] && ![textview.text isEqualToString:@"请输入车牌号"]) {
        [GlobleData sharedInstance].chePaiHao = textview.text;
    }else{
        [GlobleData sharedInstance].chePaiHao = @"";
    }
}
// 扫描枪扫描发货
-(void)scanGunSend{
    
    [GlobleData sharedInstance].clickScanGunFaHuoBtn = YES;
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic =  [userdefault objectForKey:key];
    NSArray *array = [dic objectForKey:@"listData"];
    if (array.count != 0 && array != nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本单有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
        alertView.tag = 1010101;
        [alertView show];
    }else{
        ScanPhoneSendViewController *VC = [[ScanPhoneSendViewController alloc] init];
        [self presentViewController:VC animated:YES completion:nil];
    }
    if (![textview.text isEqualToString:@""] && ![textview.text isEqualToString:@"请输入车牌号"]) {
        [GlobleData sharedInstance].chePaiHao = textview.text;
    }else{
        [GlobleData sharedInstance].chePaiHao = @"";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1010101) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
