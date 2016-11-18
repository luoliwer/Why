//
//  LoginViewController.m
//  spartacrm
//
//  Created by hunkzeng on 14-5-26.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+VJEx.h"
#import "HttpTask.h"
#import "AppModel.h"
#import "MBProgressHUD.h"
#import "NSString+SAMAdditions.h"
#import "GlobleData.h"
#import "APService.h"
#import "UnlineLoadingViewController.h"
#import "CXAlertView.h"


@interface LoginViewController ()
{
    NSString *versionStatus;
    NSString *versionUpdateMessage;
    NSString *versionUpdateUrl;
    NSMutableArray *appArray;
    
}

@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *versionStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    versionStr = [NSString stringWithFormat:@" v%@",versionStr];
    self.versionLabel.text = [self.versionLabel.text stringByAppendingString:versionStr];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setTintColor:UIColorFromRGB(0xf2f2f2)];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],
    
    NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
    //布局信息修改
    [_txtUsername setPadding:YES top:0 right:0 bottom:0 left:0];
    [_txtPassword setPadding:YES top:0 right:0 bottom:0 left:0];
  
    //设置scrollview的内容大小
    [_sviewLogin setContentSize:CGSizeMake(_sviewLogin.frame.size.width, _sviewLogin.frame.size.height )];
    
    //注册代理
    [_txtUsername setDelegate:self];
    [_txtPassword setDelegate:self];
    
    //向scrollview添加一个点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTappedBackground:)];
    tapGesture.cancelsTouchesInView = NO;
    [_sviewLogin addGestureRecognizer:tapGesture];
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * loginid=[userDefaultes objectForKey:@"usr.loginid"];
    if (![loginid isEqualToString:@""]) {
        //把帐号信息放入本地保存，退出的时候进行清空
        _txtUsername.text=[userDefaultes objectForKey:@"usr.loginid"];
        _txtPassword.text=[userDefaultes objectForKey:@"usr.psw"];
//        [_btnLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self configUI];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        //把帐号信息放入本地保存，退出的时候进行清空
        _txtUsername.text=[userDefaultes objectForKey:@"usr.loginid"];
        _txtPassword.text=[userDefaultes objectForKey:@"usr.psw"];
}

// 初始化数据
- (void)initData{
    AppModel * fahuoApp = [[AppModel alloc] init];
    fahuoApp.appIcon = [UIImage imageNamed:@"receive"];
    fahuoApp.appName = @"发货";
    fahuoApp.appDaihao = @"fahuo";
    
    AppModel * shouhuoApp = [[AppModel alloc] init];
    shouhuoApp.appIcon = [UIImage imageNamed:@"send"];
    shouhuoApp.appName = @"收货";
    shouhuoApp.appDaihao = @"shouhuo";
    
    AppModel * diaohuofahuoApp = [[AppModel alloc] init];
    diaohuofahuoApp.appIcon = [UIImage imageNamed:@"middleReceive"];
    diaohuofahuoApp.appName = @"调货发货";
    diaohuofahuoApp.appDaihao = @"dhfh";
    
    AppModel * diaohuoshouhuoApp = [[AppModel alloc] init];
    diaohuoshouhuoApp.appIcon = [UIImage imageNamed:@"middleSend"];
    diaohuoshouhuoApp.appName = @"调货收货";
    diaohuoshouhuoApp.appDaihao = @"dhsh";
    
    AppModel * daiyaohuoApp = [[AppModel alloc] init];
    daiyaohuoApp.appIcon = [UIImage imageNamed:@"sourceCheck"];
    daiyaohuoApp.appName = @"代要货";
    daiyaohuoApp.appDaihao = @"dyh";
    
    AppModel * terminalApp = [[AppModel alloc] init];
    terminalApp.appIcon = [UIImage imageNamed:@"accountApply"];
    terminalApp.appName = @"终端账号申请";
    terminalApp.appDaihao = @"zdzhsq";
    
    AppModel * suyuanCheckApp = [[AppModel alloc] init];
    suyuanCheckApp.appIcon = [UIImage imageNamed:@"source"];
    suyuanCheckApp.appName = @"溯源查询";
    suyuanCheckApp.appDaihao = @"sycx";
    
    AppModel *tongjiApp = [[AppModel alloc] init];
    tongjiApp.appIcon = [UIImage imageNamed:@"tongjibaobiao"];
    tongjiApp.appName = @"统计报表";
    tongjiApp.appDaihao = @"tjbb";
    
    AppModel *xiaoApp = [[AppModel alloc] init];
    xiaoApp.appIcon = [UIImage imageNamed:@"receive"];
    xiaoApp.appName = @"销售";
    xiaoApp.appDaihao = @"xiaoshou";
    
    AppModel *tuihuoApp = [[AppModel alloc] init];
    tuihuoApp.appIcon = [UIImage imageNamed:@"tongjibaobiao"];
    tuihuoApp.appName = @"退货";
    tuihuoApp.appDaihao = @"tuihuo";
    
    AppModel *zdzhshApp = [[AppModel alloc] init];
    zdzhshApp.appIcon = [UIImage imageNamed:@"source"];
    zdzhshApp.appName = @"终端账号审核";
    zdzhshApp.appDaihao = @"zdzhshenhe";
    
    NSArray *Array = [NSArray arrayWithObjects:fahuoApp,shouhuoApp,diaohuofahuoApp,diaohuoshouhuoApp,daiyaohuoApp,terminalApp,suyuanCheckApp,tongjiApp,xiaoApp,tuihuoApp,zdzhshApp, nil];
    appArray = [NSMutableArray arrayWithArray:Array];
}

- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = [UIColor redColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"登 录";
    title.font = [UIFont systemFontOfSize:19];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    
    [navBar pushNavigationItem:navItem animated:NO];
    
    [self.view addSubview:navBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UIViewControllerVJEx
-(void) keyboardWillShowEx:(CGRect)keyboardRect duration:(NSTimeInterval)duration{
    [_sviewLogin setContentOffset:CGPointMake(0, 70) animated:YES];
    [_sviewLogin scrollRectToVisible:_btnRegister.frame animated:YES];
}
-(void) keyboardWillHideEx:(CGRect)keyboardRect duration:(NSTimeInterval)duration{
    [_sviewLogin setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([_txtUsername isFirstResponder]) {
        [_txtPassword becomeFirstResponder];
        
    } else if([_txtPassword isFirstResponder]) {
       //
        [textField resignFirstResponder];
    }
 
    return YES;
    
}

#pragma mark - action


/**
 * @brief 退回到登录页面的事件
 */
- (IBAction)goLogin:(UIStoryboardSegue *)segue {
    
}

/**
 * @brief 整个scrollview背景点击时的事件
 */
- (void)didTappedBackground:(id)sender {
    UITextField* txt= ( UITextField *)[_sviewLogin findFirstResponder];
    [txt resignFirstResponder];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


/**
 * @brief 点击登录时的触发事件
 */
- (IBAction)doLoginBtnClick:(id)sender {
    [self initData];
    [GlobleData sharedInstance].psw = _txtPassword.text;
    if ([_txtUsername.text  isEqualToString:@""]) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTask verifyLogin:_txtUsername.text psw:_txtPassword.text sucessBlock:^(NSString * responseStr) {
        @try {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            
            NSString * status=[dictionary objectForKey:@"status"];
            [GlobleData sharedInstance].userid = [dictionary objectForKey:@"userid"];
            [GlobleData sharedInstance].usrName = [dictionary objectForKey:@"name"];
            [GlobleData sharedInstance].companyName= [dictionary objectForKey:@"companyname"];
            [GlobleData sharedInstance].userType = [dictionary objectForKey:@"usertype"];
            BOOL dhfhnum =[[dictionary objectForKey:@"dhfh"] boolValue] ;
            if (!dhfhnum) {
                [self deleteApp:@"dhfh"];
            }
            BOOL dhshnum = [[dictionary objectForKey:@"dhsh"] boolValue];
            if (!dhshnum) {
                [self deleteApp:@"dhsh"];
            }
            BOOL dyhnum = [[dictionary objectForKey:@"dyh"]boolValue];
            if (!dyhnum) {
                [self deleteApp:@"dyh"];
            }
            
            BOOL fahuonum = [[dictionary objectForKey:@"fahuo"] boolValue];
            if (!fahuonum) {
                [self deleteApp:@"fahuo"];
            }
            
            BOOL shouhuonum = [[dictionary objectForKey:@"shouhuo"]boolValue];
            if (!shouhuonum) {
                [self deleteApp:@"shouhuo"];
            }
            
            BOOL sycxnum = [[dictionary objectForKey:@"sycx"]boolValue];
            if (!sycxnum) {
                [self deleteApp:@"sycx"];
            }
            
            BOOL tibbnum = [[dictionary objectForKey:@"tjbb"]boolValue];
            if (!tibbnum) {
                [self deleteApp:@"tjbb"];
            }
            
            BOOL xiaoshounum = [[dictionary objectForKey:@"xiaoshou"]boolValue];
            if (!xiaoshounum) {
                [self deleteApp:@"xiaoshou"];
            }
            
            BOOL zdzhsqnum = [[dictionary objectForKey:@"zdzhsq"]boolValue];
            if (!zdzhsqnum) {
                [self deleteApp:@"zdzhsq"];
            }
            
            BOOL tuihuonum = [[dictionary objectForKey:@"tuihuo"]boolValue];
            if(!tuihuonum) {
                [self deleteApp:@"tuihuo"];
            }
            
            BOOL zdzhnum = [[dictionary objectForKey:@"zdzhsh"] boolValue];
            if (!zdzhnum) {
                [self deleteApp:@"zdzhshenhe"];
            }
            
            [GlobleData sharedInstance].appArray = appArray;
            if ([@"1" isEqualToString:status]) {
                NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
                
                //把帐号信息放入本地保存，退出的时候进行清空
                [userDefaultes setObject:_txtUsername.text forKey:@"usr.loginid"];
                [userDefaultes setObject:_txtPassword.text forKey:@"usr.psw"];
                
                //绑定百度推送
                NSString * registrationID= [APService registrationID];
                
                [HttpTask bindBPush:@"4" channelid:registrationID sucessBlock:^(NSString * jsonStr) {
                    [GlobleData sharedInstance].BPush_ChannelId=registrationID;
                } failBlock:^(NSDictionary * errDic) {
                    
                }];
                
                //获取用户信息并存放到缓存中去
                [HttpTask userInfo:^(NSString * userInfoStr) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    NSError *error;
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:[userInfoStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                    [GlobleData sharedInstance].userInfo=userInfo;
                    
                    [self performSegueWithIdentifier:@"loginSuccess" sender:self.view];
                } failBlock:^(NSDictionary * dicErr){                     
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
                NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
                [HttpTask systemUpdateCheck:@"1" version:curVersion sucessBlock:^(NSString *responseStr) {
                    NSError *error;
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
                    NSLog(@"currentVersion = %@",curVersion);
                    versionStatus = [dictionary objectForKey:@"status"];
                    versionUpdateMessage = [dictionary objectForKey:@"message"];
                    versionUpdateUrl = [dictionary objectForKey:@"url"];
                    if ([versionStatus isEqualToString:@"0"]) {
                        
                    }else if ([versionStatus isEqualToString:@"1"]){
                        [self doVersionUpgrade:versionUpdateUrl];
                    }else {
                        [self systemMustUpdate:versionUpdateUrl];
                    }
                   
                    
                } failBlock:^(NSDictionary *dicErr) {
                    
                }];
                
            } else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[UIAlertView alloc]initWithTitle:@"提示"
                                           message:@"用户名或密码错误，请重新登录"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil] show];
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

//系统可以更新，也可以不更新的处理
- (void) doVersionUpgrade:(NSString *)url{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 0, 0)];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *string = versionUpdateMessage;
    label.font = [UIFont systemFontOfSize:12];
    label.text = string;
    CGSize size = CGSizeMake(320, 2000);
    CGSize labelSize = [string sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"应用已升级,确定是否升级应用？" contentView:label cancelButtonTitle:nil];
    
    
    [alertView addButtonWithTitle:@"取消"
                             type:CXAlertViewButtonTypeCustom
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              
                              [alertView dismiss];
                          }];
    
    
    [alertView addButtonWithTitle:@"确定"
                             type:CXAlertViewButtonTypeCustom
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              
                              [alertView dismiss];
                              
                              NSString *newUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",url];
                              NSURL *iTunesURL = [NSURL URLWithString:newUrl];
                              [[UIApplication sharedApplication] openURL:iTunesURL];
                              
                          }];
    [alertView show];
    
}

//应用必须升级需要做的处理
- (void)systemMustUpdate: (NSString *)url
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0 , 0, 0)];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *string = versionUpdateMessage;
    label.font = [UIFont systemFontOfSize:12];
    label.text = string;
    CGSize size = CGSizeMake(320, 2000);
    CGSize labelSize = [string sizeWithFont:label.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    
    //    [contentView addSubview:label];
    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:@"该应用必须升级，请点击确定进行升级" contentView:label cancelButtonTitle:nil];
    [alertView addButtonWithTitle:@"确定"
                             type:CXAlertViewButtonTypeCustom
                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                              
                              [alertView dismiss];
                              
                              NSString *newUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",url];
                              NSURL *iTunesURL = [NSURL URLWithString:newUrl];
                              [[UIApplication sharedApplication] openURL:iTunesURL];
                              
                          }];
    [alertView show];
}
// 删除app
- (void)deleteApp:(NSString *)appdaihao{
    NSArray *array = [NSArray arrayWithArray:appArray];
    for (AppModel *model in array) {
        if ([model.appDaihao isEqualToString:appdaihao]) {
            [appArray removeObject:model];
        }
    }
}

- (IBAction)touchUpInsideAction:(id)sender {
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (IBAction)cacheBtn:(id)sender {
    UnlineLoadingViewController *VC = [[UnlineLoadingViewController alloc] init];
    [GlobleData sharedInstance].dealtype = @"5";
    [self presentViewController:VC animated:YES completion:nil];
}
@end
