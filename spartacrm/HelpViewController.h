//
//  HelpViewController.h
//  aioa
//
//  Created by hunkzeng on 15/8/27.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
