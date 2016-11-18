//
//  UnlineLoadingViewController.m
//  wly
//
//  Created by luolihacker on 16/5/20.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "UnlineLoadingViewController.h"
#import "ChoiceListViewController.h"
#import "ScanPhoneViewController.h"
#import "HuanCunListViewController.h"

@interface UnlineLoadingViewController ()<UITextViewDelegate>
{
    UILabel *typeLabel;
    UITextView *describeTextView;
    NSString *remarkText; //暂存备注
}
@end

@implementation UnlineLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    remarkText = [[NSString alloc] init];
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self configUI];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 80, self.view.frame.size.height - 36, 160, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(enterSaomiao) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"开始扫描" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    [self.view addSubview:button];

   
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"离线缓存";
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
    
    UIButton *huanCunBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 28, 70, 25)];
    huanCunBtn.layer.borderColor = [UIColor blackColor].CGColor;
    huanCunBtn.layer.borderWidth = 0.5;
    [huanCunBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [huanCunBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [huanCunBtn setTitle:@"缓存列表" forState:UIControlStateNormal];
    huanCunBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    huanCunBtn.layer.cornerRadius = 4.0;
    huanCunBtn.clipsToBounds = YES;
    [huanCunBtn addTarget:self action:@selector(enterHuanCunList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:huanCunBtn];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12, 80, self.view.frame.size.width - 24, 30)];
    [self.view addSubview:backView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"buttonBackground.png"];
    [backView addSubview:imageView];

    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 30)];
    typeLabel.text = @"请选择缓存类型";
    typeLabel.textColor = [UIColor blackColor];
    typeLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:typeLabel];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width - 40, 2, 26, 26)];
    image.image = [UIImage imageNamed:@"xiangyou.png"];
    [backView addSubview:image];
    
    UIButton *choiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
    [choiceBtn addTarget:self action:@selector(enterChoiceList) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:choiceBtn];
    
    describeTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 135, self.view.frame.size.width - 24, 120)];
    describeTextView.delegate = self;
    describeTextView.layer.borderWidth = 1.5;
    describeTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    describeTextView.text = @"请填写单据描述(20字以内)";
    describeTextView.textColor = UIColorFromRGB(0xA6A7B1);
    [self.view addSubview:describeTextView];

    
}
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (![remarkText isEqualToString:@""]) {
        textView.text = remarkText;
    }else{
        textView.text = @"";
    }
    textView.textColor = UIColorFromRGB(0x24344e);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        describeTextView.textColor = UIColorFromRGB(0xa6a7b1);
        describeTextView.text = @"请填写单据描述(20字以内)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 20 && text.length > range.length) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.markedTextRange == nil && 20 > 0 && textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
    }
    remarkText = textView.text;
}

// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [describeTextView resignFirstResponder];
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 进入缓存列表
- (void)enterHuanCunList{
    HuanCunListViewController *Vc = [[HuanCunListViewController alloc] init];
    Vc.type = [GlobleData sharedInstance].dealtype;
    [self presentViewController:Vc animated:YES completion:nil];
}

// 进入选择列表
- (void)enterChoiceList{
    ChoiceListViewController *Vc = [[ChoiceListViewController alloc] init];
    Vc.transValue = ^(NSString *typeString){
        typeLabel.text = typeString;
    };
    [self presentViewController:Vc animated:YES completion:nil];
}

// 点击开始扫描进入扫描页面
- (void)enterSaomiao{
    
    ScanPhoneViewController *Vc = [[ScanPhoneViewController alloc] init];
    Vc.isCacheScan = YES;
    if ([typeLabel.text isEqualToString:@"请选择缓存类型"]) {
        Vc.thingsType = @"5";
    }else if ([typeLabel.text isEqualToString:@"发货"]){
        Vc.thingsType = @"0";
    }else if ([typeLabel.text isEqualToString:@"调货发货"]){
        Vc.thingsType = @"1";
    }else if ([typeLabel.text isEqualToString:@"收货"]){
        Vc.thingsType = @"2";
    }else if ([typeLabel.text isEqualToString:@"调货收货"]){
        Vc.thingsType = @"3";
    }else if ([typeLabel.text isEqualToString:@"销售"]){
        Vc.thingsType = @"4";
    }
    if ([[describeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] || [describeTextView.text isEqualToString:@"请填写单据描述(20字以内)"]){
        Vc.describremark = @"";
    }else{
        Vc.describremark = describeTextView.text;
    }
    [self presentViewController:Vc animated:YES completion:nil];
}
@end
