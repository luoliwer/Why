//
//  HelpViewController.m
//  aioa
//
//  Created by hunkzeng on 15/8/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "HelpViewController.h"
#import "Common.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REMOTE_URL,@"/app/help"]];
    
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:webUrl];
    [requestObj setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [requestObj setTimeoutInterval:30];
    [_webView loadRequest:requestObj];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
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
