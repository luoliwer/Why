//
//  LoginViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-5-26.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextFieldVJEx.h"
#import "UIViewControllerVJEx.h"

@interface LoginViewController : UIViewControllerVJEx<UITextFieldDelegate>{
    
}
//
@property (weak, nonatomic) IBOutlet UITextFieldVJEx *txtUsername;
@property (weak, nonatomic) IBOutlet UITextFieldVJEx *txtPassword;
- (IBAction)touchUpInsideAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) NSString *sendBtnType;

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)cacheBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnForget;
@property (weak, nonatomic) IBOutlet UIScrollView *sviewLogin;
- (IBAction)doLoginBtnClick:(id)sender;

@end
