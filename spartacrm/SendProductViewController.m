//
//  SendProductViewController.m
//  wly
//
//  Created by luolihacker on 15/12/16.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "SendProductViewController.h"

@interface SendProductViewController ()

@end

@implementation SendProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0].CGColor;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 180, 200, 160)];
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setImage:[UIImage imageNamed:@""]];
    [view addSubview:imageView];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:self.view.bounds];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"发货";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:14];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0x4682B4)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
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

@end
