//
//  HomepageViewController.m
//  aioa
//
//  Created by hunkzeng on 15/8/16.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "HomepageViewController.h"
#import "Common.h"

@interface HomepageViewController ()

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _scrollView.contentSize=CGSizeMake(WIDTH, 560);
    // Do any additional setup after loading the view.
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

- (IBAction)onExpressClick:(id)sender {
    UINavigationController * nav=(UINavigationController * )[self parentViewController];
    UITabBarController * tabBar=(UITabBarController * )[nav parentViewController];
    tabBar.selectedIndex=1;
}

- (IBAction)onOfficeClick:(id)sender {
    UINavigationController * nav=(UINavigationController * )[self parentViewController];
    UITabBarController * tabBar=(UITabBarController * )[nav parentViewController];
    tabBar.selectedIndex=2;
}
@end
