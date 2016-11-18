//
//  ForgetPswViewController.h
//  aioa
//
//  Created by hunkzeng on 15/8/6.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPswViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtName;


- (IBAction)touchUpInsideAction:(id)sender;

- (IBAction)btnSubmit:(id)sender;

@end
