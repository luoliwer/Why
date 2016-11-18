//
//  AdviseViewController.h
//  aioa
//
//  Created by hunkzeng on 15/8/16.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"

@interface AdviseViewController : UIViewController
@property (weak, nonatomic) IBOutlet SAMTextView *textAdvise;
- (IBAction)btnSubmitClick:(id)sender;

@end
