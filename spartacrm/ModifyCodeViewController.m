//
//  ModifyCodeViewController.m
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "ModifyCodeViewController.h"

@interface ModifyCodeViewController ()<UITextFieldDelegate>
{
    UITextField *oldCodeField; // 旧密码输入框
    UITextField *newCodeField; // 新密码输入框
    UITextField *sureCodeField; // 确认密码输入框
    
    NSString *oldCodeStr;
    NSString *newCodeStr;
    NSString *sureCodeStr;
}
@end

@implementation ModifyCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    oldCodeField = [[UITextField alloc] initWithFrame:CGRectMake(12, 80, self.view.frame.size.width - 24, 30)];
    oldCodeField.placeholder = @"请输入旧密码";
    oldCodeField.tag = 201605;
    oldCodeField.font = [UIFont systemFontOfSize:15];
    oldCodeField.layer.borderWidth = 0.5;
    oldCodeField.layer.borderColor = [UIColor blackColor].CGColor;
    oldCodeField.layer.cornerRadius = 3;
    oldCodeField.clipsToBounds = YES;
    oldCodeField.delegate = self;
    oldCodeField.secureTextEntry = YES;
    [self.view addSubview:oldCodeField];
    
    newCodeField = [[UITextField alloc] initWithFrame:CGRectMake(12, 125, oldCodeField.frame.size.width, 30)];
    newCodeField.placeholder = @"请输入新密码";
    newCodeField.tag = 201606;
    newCodeField.font = [UIFont systemFontOfSize:15];
    newCodeField.layer.borderWidth = 0.5;
    newCodeField.layer.borderColor = [UIColor blackColor].CGColor;
    newCodeField.layer.cornerRadius = 3;
    newCodeField.clipsToBounds = YES;
    newCodeField.delegate = self;
    newCodeField.secureTextEntry = YES;
    [self.view addSubview:newCodeField];
    
    sureCodeField = [[UITextField alloc] initWithFrame:CGRectMake(12, 170, oldCodeField.frame.size.width, 30)];
    sureCodeField.tag = 201607;
    sureCodeField.placeholder = @"请确认密码";
    sureCodeField.font = [UIFont systemFontOfSize:15];
    sureCodeField.layer.borderWidth = 0.5;
    sureCodeField.layer.borderColor = [UIColor blackColor].CGColor;
    sureCodeField.layer.cornerRadius = 3;
    sureCodeField.clipsToBounds = YES;
    sureCodeField.delegate = self;
    sureCodeField.secureTextEntry = YES;
    [self.view addSubview:sureCodeField];
    
    UIButton *modifyCommitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height - 80, self.view.frame.size.width - 40, 44)];
    modifyCommitBtn.layer.borderColor = [UIColor blackColor].CGColor;
    modifyCommitBtn.backgroundColor = UIColorFromRGB(0x62BAF7);
    modifyCommitBtn.layer.borderWidth = 0.5;
    [modifyCommitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [modifyCommitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [modifyCommitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    modifyCommitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    modifyCommitBtn.layer.cornerRadius = 4.0;
    modifyCommitBtn.clipsToBounds = YES;
    [modifyCommitBtn addTarget:self action:@selector(commitchange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyCommitBtn];

    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [oldCodeField resignFirstResponder];
    [newCodeField resignFirstResponder];
    [sureCodeField resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 201605) {
        oldCodeStr = textField.text;
    }
    if (textField.tag == 201606) {
        if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]){
            [self showMessage:@"新密码不能为空"];
            return;
        }else{
            newCodeStr = textField.text;
        }
    }
    if (textField.tag == 201607) {
        sureCodeStr = textField.text;
    }
    
    
}
- (void)configUI{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"修改密码";
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
- (void)commitchange{
    if ([[newCodeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [self showMessage:@"密码为空，请输入"];
        return;
    }else if(![newCodeStr isEqualToString:sureCodeStr]){
        [self showMessage:@"密码不一致，请检查"];
        return;
    }else{
        [HttpTask modifyCode:[GlobleData sharedInstance].userid pswold:oldCodeStr pswnew:newCodeStr sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSString *normal = [dictionary objectForKey:@"status"];
            NSString *msg = [dictionary objectForKey:@"remark"];
            if ([normal isEqualToString:@"1"]) {
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                [userDefaultes setValue:@"" forKey:@"usr.psw"];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                [self showMessage:@"修改成功"];
            }else{
                [self showMessage:msg];
            }
        } failBlock:^(NSDictionary *errDic) {
            
        }];
    }
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
