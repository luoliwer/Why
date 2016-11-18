//
//  HomepageViewController.h
//  aioa
//
//  Created by hunkzeng on 15/8/16.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageViewController : UIViewController
- (IBAction)onExpressClick:(id)sender;
- (IBAction)onOfficeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
