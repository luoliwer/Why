//
//  ModifyPSWViewController.m
//  wly
//
//  Created by luolihacker on 16/1/4.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "ModifyPSWViewController.h"
#import "GlobleData.h"
#import "HttpTask.h"

@interface ModifyPSWViewController ()

@end

@implementation ModifyPSWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchInsideAction:(id)sender {
    [_verifyInfoCode resignFirstResponder];
    [_newpsw resignFirstResponder];
}

- (IBAction)modifyPSW:(id)sender {
    NSString *newpswKey = [_newpsw.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (newpswKey.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"新密码不能为空,请重新设置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }else{
        [HttpTask changePsw:[GlobleData sharedInstance].whenForegetPswUsername code:_verifyInfoCode.text newpsw:_newpsw.text sucessBlock:^(NSString *responseStr) {
            NSError *error;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
            NSString *status = [dictionary objectForKey:@"status"];
            NSString *msg = [dictionary objectForKey:@"msg"];
            if ([status isEqualToString:@"1"]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        } failBlock:^(NSDictionary *errDic) {
            
        }];
    }
}
@end
