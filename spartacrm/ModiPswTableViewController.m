//
//  ModiPswTableViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-6-6.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "ModiPswTableViewController.h"
#import "UIView+VJEx.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"
#import "HttpTask.h"

@interface ModiPswTableViewController ()

@end

@implementation ModiPswTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //向scrollview添加一个点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    
    //设置元素代理
    _txtOldPsw.delegate=self;
    _txtNewPsw.delegate=self;
    _txtConfirmPsw.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    if ([_txtOldPsw isFirstResponder]) {
        [_txtNewPsw becomeFirstResponder];
        
    } else if ([_txtNewPsw isFirstResponder]) {
        [_txtConfirmPsw becomeFirstResponder];
        
    } else if([_txtConfirmPsw isFirstResponder]) {
        [self performSelector:@selector(doModiPsw:) withObject:nil];
    }
    
    
    return YES;
    
}

/**
 * @brief 整个scrollview背景点击时的事件
 */
- (void)didTappedBackground:(id)sender {
    UITextField* txt= ( UITextField *)[self.view findFirstResponder];
    [txt resignFirstResponder];
}




- (IBAction)doModiPsw:(id)sender {
    NSLog(@"do moid psw");
    
    NSString * strOldPsw= _txtOldPsw.text;
    NSString * strNewPsw= _txtNewPsw.text;
    NSString * strNewPswConfirm= _txtConfirmPsw.text;
    
    
    if (![strNewPsw isEqualToString:strNewPswConfirm] ) {
        
        [[[UIAlertView alloc]initWithTitle:@"提示"
                                   message:@"新密码与确认密码不一致！"
                                  delegate:nil
                         cancelButtonTitle:@"确定"
                         otherButtonTitles:nil] show];
        
        
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTask modifyPsw:strOldPsw strNewPsw:strNewPsw strNewPswConfirm:strNewPswConfirm sucessBlock:^(NSString * jsonString) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"接收到的服务器端的数据为:%@",jsonString);
        
        @try {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            //指明是否有下一页
            int  status = [[dictionary objectForKey:@"status"] intValue];
            if (status==1 ) {
                [[[UIAlertView alloc]initWithTitle:@"提示"
                                           message:@"密码修改成功，确定后重新登录！"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil] show];
            } else {
                [[[UIAlertView alloc]initWithTitle:@"提示"
                                           message:[dictionary objectForKey:@"msg"]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil] show];
                [self goLogin];
            }
            
        }
        @catch (NSException *e) {
            NSLog(@"JSON解析失败，原因:%@",[e reason]);
        }
        @finally {
        }
    } failBlock:^(NSDictionary * dicErr){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}



-(void) goLogin {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
