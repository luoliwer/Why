//
//  TerminalAccountApplyViewController.m
//  wly
//
//  Created by luolihacker on 16/1/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "TerminalAccountApplyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageAlertView.h"
#import "ChoiceViewController.h"
#import "ApplyRecordViewController.h"
#import "GlobleData.h"
#import "HttpTask.h"

@interface TerminalAccountApplyViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    UITextField *otherTelTextField;
    UITextField *linkmanTextField;
    UITextField *textfield;
    UITextView *remark;
    NSString *remarkText;
    UIScrollView *backScrollView;
    BOOL isTextField;
}
@end

@implementation TerminalAccountApplyViewController
@synthesize terminalNameTextField;
@synthesize teleTextField;
@synthesize addressTextField;
@synthesize selectBtn;
@synthesize textLabel;
@synthesize imageView;
@synthesize commitBtn;
@synthesize tableview;
@synthesize listArray;
@synthesize imgView;
@synthesize backgroundView;
@synthesize whichIsSelected;

- (void)viewDidLoad {
    [super viewDidLoad];
    isTextField = NO;
    remarkText = [[NSString alloc] init];
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 164)];
    backScrollView.bounces = NO;
    backScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, backScrollView.frame.size.height + 30);
    [self.view addSubview:backScrollView];

    terminalNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 15,self.view.frame.size.width - 40 , 35)];
    terminalNameTextField.placeholder = @"终端商名称";
    terminalNameTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    terminalNameTextField.delegate = self;
    terminalNameTextField.font = [UIFont systemFontOfSize:16];
    terminalNameTextField.borderStyle = UITextBorderStyleLine;
    terminalNameTextField.backgroundColor = [UIColor whiteColor];
    terminalNameTextField.textAlignment = NSTextAlignmentLeft;
    terminalNameTextField.clearsOnBeginEditing = YES;
    terminalNameTextField.returnKeyType = UIReturnKeyNext;
    terminalNameTextField.delegate = self;
    [backScrollView addSubview:terminalNameTextField];
    
    teleTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 35)];
    teleTextField.placeholder = @"电话（将作为账号）";
    teleTextField.keyboardType = UIKeyboardTypeNumberPad;
    teleTextField.delegate = self;
    teleTextField.font = [UIFont systemFontOfSize:16];
    teleTextField.borderStyle = UITextBorderStyleLine;
    teleTextField.backgroundColor = [UIColor whiteColor];
    teleTextField.textAlignment = NSTextAlignmentLeft;
    teleTextField.clearsOnBeginEditing = YES;
    teleTextField.delegate = self;
    [backScrollView addSubview:teleTextField];
    
    otherTelTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 105, self.view.frame.size.width - 40, 35)];
    otherTelTextField.placeholder = @"其他电话";
    otherTelTextField.keyboardType = UIKeyboardTypeNumberPad;
    otherTelTextField.delegate = self;
    otherTelTextField.borderStyle = UITextBorderStyleLine;
    otherTelTextField.font = [UIFont systemFontOfSize:16];
    otherTelTextField.backgroundColor = [UIColor whiteColor];
    otherTelTextField.clearsOnBeginEditing = YES;
    otherTelTextField.delegate = self;
    [backScrollView addSubview:otherTelTextField];
    
    linkmanTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 35)];
    linkmanTextField.placeholder = @"联系人";
    linkmanTextField.delegate = self;
    linkmanTextField.borderStyle = UITextBorderStyleLine;
    linkmanTextField.font = [UIFont systemFontOfSize:16];
    linkmanTextField.clearsOnBeginEditing = YES;
    [backScrollView addSubview:linkmanTextField];
    
    addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 195, self.view.frame.size.width - 40, 35)];
    addressTextField.placeholder = @"地址";
    addressTextField.delegate = self;
    addressTextField.borderStyle = UITextBorderStyleLine;
    addressTextField.font = [UIFont systemFontOfSize:16];
    addressTextField.clearsOnBeginEditing = YES;
    [backScrollView addSubview:addressTextField];
    
    remark = [[UITextView alloc] initWithFrame:CGRectMake(20, 240, self.view.frame.size.width - 40, 100)];
    remark.delegate = self;
    remark.layer.borderWidth = 1.0;
    remark.textColor = UIColorFromRGB(0xa6a7b1);
    remark.layer.borderColor = [UIColor blackColor].CGColor;
    remark.text = @"备注(100字以内)";
    remark.font = [UIFont systemFontOfSize:16];
    [backScrollView addSubview:remark];
    
    selectBtn = [[UIControl alloc] initWithFrame:CGRectMake(20, 360, self.view.frame.size.width - 40, 44)];
    [selectBtn addTarget:self action:@selector(tanchuoptions) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, selectBtn.frame.size.width, selectBtn.frame.size.height)];
    [backView setImage:[UIImage imageNamed:@"buttonBackground.png"]];
    [selectBtn addSubview:backView];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 200, 44)];
    textLabel.text = @"请选择终端类型";
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:16];
    [selectBtn addSubview:textLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(245, 9, 26, 26)];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setImage:[UIImage imageNamed:@"xiangyou"]];
    [selectBtn addSubview:imageView];
    [backScrollView addSubview:selectBtn];
    
    commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 70, self.view.frame.size.width - 40, 44)];
    commitBtn.layer.cornerRadius = 5.0;
    commitBtn.clipsToBounds = YES;
    [commitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [commitBtn setBackgroundColor:[UIColor blueColor]];
    [commitBtn setBackgroundColor:UIColorFromRGB(0x62BAF7)];
    [commitBtn addTarget:self action:@selector(commitApply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [self configUI];
}
// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    if (isTextField) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        isTextField = NO;
        return;
    }
    NSDictionary *userInfo = [noti userInfo];
    NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [avalue CGRectValue];
    CGFloat higth = rect.size.height;

    CGFloat y = self.view.bounds.size.height - 60 + 44 + higth - self.view.frame.size.height;
    self.view.frame = CGRectMake(0, - y, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    isTextField = NO;
}

// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [textfield resignFirstResponder];
    [remark resignFirstResponder];
    isTextField = NO;
}

#pragma mark -- UITextViewDelegate
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
        remark.textColor = UIColorFromRGB(0xa6a7b1);
        remark.text = @"备注(100字以内)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 100 && text.length > range.length) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.markedTextRange == nil && 100 > 0 && textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    remarkText = textView.text;
}

#pragma mark -- UITextFieldDelegate

// 响应输入框的回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textfield resignFirstResponder];
    [remark resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    isTextField = YES;
    textfield = textField;
    textfield.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)viewWillAppear:(BOOL)animated{
    if ([GlobleData sharedInstance].typeName == nil) {
        textLabel.text = @"请选择终端类型";
    }else{
        textLabel.text = [GlobleData sharedInstance].typeName;
    }
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"账号终端申请";
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
    [daiyaohuoBtn setTitle:@"申请列表" forState:UIControlStateNormal];
    daiyaohuoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    daiyaohuoBtn.layer.cornerRadius = 4.0;
    daiyaohuoBtn.clipsToBounds = YES;
    [daiyaohuoBtn addTarget:self action:@selector(enterRecordList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:daiyaohuoBtn];
}
// 设置渐变颜色
- (CAGradientLayer *)shadowAsInverse{
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(20, 300, self.view.frame.size.width - 40, 44);
    newShadow.frame = newShadowFrame;
    
    //添加渐变的颜色组合
    newShadow.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,(id)[UIColor blackColor].CGColor,nil];
    return newShadow;
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
    [GlobleData sharedInstance].typeName = nil;
}
- (void)tanchuoptions{
    ChoiceViewController *Vc = [[ChoiceViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
    
}
-(void)commitApply{
    
    if ([terminalNameTextField.text isEqualToString:@""]) {
        [self showMessage:@"电话不能为空"];
        return;
    }else if ([teleTextField.text isEqualToString:@""]){
        [self showMessage:@"其他电话不能为空"];
        return;
    }else if ([linkmanTextField.text isEqualToString:@""]){
        [self showMessage:@"联系人不能为空"];
        return;
    }else if ([linkmanTextField.text isEqualToString:@""]){
        [self showMessage:@"地址不能为空"];
        return;
    }else if ([textLabel.text isEqualToString:@"请选择终端类型"]){
        [self showMessage:@"请选择终端类型"];
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:@"是否确认提交申请？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 2011;
    [alertView show];
    
    }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2011) {
        switch (buttonIndex) {
            case 0:
            {
                [self commitApplyment];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)commitApplyment{
    
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *terminalName = terminalNameTextField.text;
    NSString *phone = teleTextField.text;
    NSString *loginId = teleTextField.text;
    NSString *otherPhone = otherTelTextField.text;
    NSString *terminalType = textLabel.text;
    if ([textLabel.text isEqualToString:@"酒水终端商"]) {
        terminalType = @"1";
    }else if([textLabel.text isEqualToString:@"大型KA卖场"]){
        terminalType = @"2";
    }else if([textLabel.text isEqualToString:@"高端餐饮店"]){
        terminalType = @"3";
    }
    NSString *linkMan = linkmanTextField.text;
    NSString *address = addressTextField.text;
    NSString *remarkStr = remark.text;
    [HttpTask accountApply:userid name:terminalName Type:terminalType linkMan:linkMan phone:phone loginId:loginId otherPhone:otherPhone address:address remark:remarkStr sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dictionary) {
            NSString *status = [dictionary objectForKey:@"status"];
            if ([status isEqualToString:@"1"]) {
                [self showMessage:@"申请成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if ([status isEqualToString:@"0"]){
                NSString *msg = [dictionary objectForKey:@"msg"];
                [self showMessage:msg];
            }
        }
    } failBlock:^(NSDictionary *erroDic) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"申请失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
    }];
}

// 进入到申请记录列表
- (void)enterRecordList{
    
    ApplyRecordViewController *applyVc = [[ApplyRecordViewController alloc] init];
    [self presentViewController:applyVc animated:YES completion:nil];
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
