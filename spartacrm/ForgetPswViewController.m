//
//  ForgetPswViewController.m
//  aioa
//
//  Created by hunkzeng on 15/8/6.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "ForgetPswViewController.h"
#import "HttpTask.h"
#import "ModifyPSWViewController.h"
#import "GlobleData.h"
@implementation ForgetPswViewController
{
    NSString *status;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册代理
    [_txtName setDelegate:self];
    [_txtUsername setDelegate:self];
    [self configUI];
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"忘记密码";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    navItem.titleView.frame = CGRectMake(self.view.center.x - 100, navBar.center.y - 10, 60, 20);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
}
- (IBAction)touchUpInsideAction:(id)sender {
    [_txtUsername resignFirstResponder];
    [_txtName resignFirstResponder];
}

- (IBAction)btnSubmit:(id)sender {
    NSString *namekey = [_txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *telkey = [_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (namekey.length == 0 || telkey.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名和电话号码不能为空，请输入正确的用户名和电话号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        [GlobleData sharedInstance].whenForegetPswUsername = _txtName.text;
        [HttpTask forgetPSW:_txtName.text telephone:_txtUsername.text sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        status = [dictionary objectForKey:@"status"];
        NSString *msg = [dictionary objectForKey:@"msg"];
        if ([status isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"您输入的用户名或电话号码有误，请核对后重新获取。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failBlock:^(NSDictionary *errDic) {
        
    }];
    }
}



#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_txtName isFirstResponder]) {
        [_txtUsername becomeFirstResponder];
        
    } else if([_txtUsername isFirstResponder]) {
        //
        [textField resignFirstResponder];
    }
    
    return YES;
    
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
