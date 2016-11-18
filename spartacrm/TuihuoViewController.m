//
//  TuihuoViewController.m
//  wly
//
//  Created by luolihacker on 16/6/6.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "TuihuoViewController.h"
#import "ScanPhoneViewController.h"
#import "TuihuoChoiceListViewController.h"
#import "TerminalListViewController.h"
#import "TerminalModel.h"

@interface TuihuoViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UILabel *typeLabel;
    UITextView *describeTextView;
    NSString *remarkText; // 暂存备注
    UILabel *terminalNameLabel; // 终端账号名字Label
    NSString *zdsId; // 终端商id
    NSString *tuihuotype; // 退货类型
    UIControl *backControl;
}

@end

@implementation TuihuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    remarkText = [[NSString alloc] init];
    terminalNameLabel = [[UILabel alloc] init];
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self configUI];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - 80, self.view.frame.size.height - 36, 160, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(enterSaomiao) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"开始扫描" forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"退货";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
    
    describeTextView = [[UITextView alloc] init];
    describeTextView.frame = CGRectMake(12, 80, self.view.frame.size.width - 24, 120);
    describeTextView.delegate = self;
    describeTextView.layer.borderWidth = 1.5;
    describeTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    describeTextView.text = @"请输入备注（50字以内）";
    describeTextView.textColor = UIColorFromRGB(0xA6A7B1);
    [self.view addSubview:describeTextView];
    
    if ([[GlobleData sharedInstance].userType isEqualToString:@"3"]) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12, 80, self.view.frame.size.width - 24, 30)];
        [self.view addSubview:backView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
        imageView.image = [UIImage imageNamed:@"buttonBackground.png"];
        [backView addSubview:imageView];
        if ([[GlobleData sharedInstance].userType isEqualToString:@"3"]) {
            typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 30)];
            typeLabel.text = @"请选择退货类型";
            typeLabel.textColor = [UIColor blackColor];
            typeLabel.font = [UIFont systemFontOfSize:14];
            [backView addSubview:typeLabel];
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width - 40, 2, 26, 26)];
            image.image = [UIImage imageNamed:@"xiangyou.png"];
            [backView addSubview:image];
            UIButton *choiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)];
            [choiceBtn addTarget:self action:@selector(enterChoiceList) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:choiceBtn];
            describeTextView.frame = CGRectMake(12, 135, self.view.frame.size.width - 24, 120);
        }else{
            describeTextView.frame = CGRectMake(12, 80, self.view.frame.size.width - 24, 120);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if ([typeLabel.text isEqualToString:@"终端商"]) {
        describeTextView.frame = CGRectMake(12, 180, self.view.frame.size.width - 24, 120);
        if (backControl == nil) {
            backControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 50)];

        }else{
            backControl.hidden = NO;
        }
        [backControl addTarget:self action:@selector(enterTerminalList) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *upLineview = [[UIView alloc] initWithFrame:CGRectMake(8, 1, backControl.frame.size.width - 12, 0.5)];
        upLineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [backControl addSubview:upLineview];
        
        UIView *downLineview = [[UIView alloc] initWithFrame:CGRectMake(8, 49, upLineview.frame.size.width, 0.5)];
        downLineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [backControl addSubview:downLineview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 45, 20)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x24344e);
        label.text = @"终端商:";
        [backControl addSubview:label];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 28, 10, 18, 30)];
        imgView.image = [UIImage imageNamed:@"enternextarrow"];
        [backControl addSubview:imgView];
        
        terminalNameLabel.frame = CGRectMake(60, label.frame.origin.y, self.view.frame.size.width - 70, 20);
        terminalNameLabel.font = [UIFont systemFontOfSize:13];
        terminalNameLabel.textColor = UIColorFromRGB(0x24344e);
        [backControl addSubview:terminalNameLabel];
        
        [self.view addSubview:backControl];
    }else{
        backControl.hidden = YES;
        for (UIView *view in backControl.subviews) {
            [view removeFromSuperview];
        }
        terminalNameLabel.text = @"";
        describeTextView.frame = CGRectMake(12, 135, self.view.frame.size.width - 24, 120);
    }
}

-(void)enterTerminalList{
    TerminalListViewController *Vc = [[TerminalListViewController alloc] init];
    Vc.transValue = ^(TerminalModel *model){
        terminalNameLabel.text = model.zdsName;
        zdsId = model.zdsid;
    };
    [self presentViewController:Vc animated:YES completion:nil];
    
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (![remarkText isEqualToString:@""]) {
        textView.text = remarkText;
    }else{
        textView.text = @"";
    }
    textView.textColor = UIColorFromRGB(0x24344e);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ) {
        describeTextView.textColor = UIColorFromRGB(0xa6a7b1);
        describeTextView.text = @"请输入备注(50字以内)";
        remarkText = @"";
    }else{
        remarkText = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 50 && text.length > range.length) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.markedTextRange == nil && 50 > 0 && textView.text.length > 50) {
        textView.text = [textView.text substringToIndex:50];
    }
    remarkText = textView.text;
}

// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [describeTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 进入选择列表
- (void)enterChoiceList{
    TuihuoChoiceListViewController *Vc = [[TuihuoChoiceListViewController alloc] init];
    Vc.transValue = ^(NSString *typeString){
        typeLabel.text = typeString;
    };
    [self presentViewController:Vc animated:YES completion:nil];
}

- (void)enterSaomiao{
    
    if ([[GlobleData sharedInstance].userType isEqualToString:@"3"] && [typeLabel.text isEqualToString:@"请选择退货类型"]) {
        [self showMessage:@"请先选择退货类型"];
        return;
    }
    ScanPhoneViewController *Vc = [[ScanPhoneViewController alloc] init];
    if ([typeLabel.text isEqualToString:@"终端商"]) {
        if ([terminalNameLabel.text isEqualToString:@""] || terminalNameLabel.text == nil) {
            [self showMessage:@"请选择终端商"];
            return;
        }else{
            Vc.tuihuoType = @"4";  // 终端商
            tuihuotype = @"4";
        }
    }else{
        Vc.tuihuoType = @"5"; // 个人
        tuihuotype = @"5";
    }
    if (zdsId) {
        Vc.zdsId = zdsId;
    }else{
        Vc.zdsId = @"";
    }
    
    NSString *zdsid = [NSString stringWithFormat:@"%@",zdsId];
    NSString *usrid = [GlobleData sharedInstance].userid;
    NSString *keyId;
    NSString *usreKey;
    if (zdsid && zdsid.length > 0) {
        keyId = [NSString stringWithFormat:@"%@",zdsid];
        usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:[GlobleData sharedInstance].dealtype];
    }else{
        usreKey = [usrid stringByAppendingString:[GlobleData sharedInstance].dealtype];
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [userDefault objectForKey:usreKey];
    if (dataArr && dataArr.count > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本地有缓存，请选择操作" delegate:self cancelButtonTitle:@"继续" otherButtonTitles:@"重扫", nil];
        alertView.tag = 201610;
        [alertView show];
    }else{
        [self presentViewController:Vc animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 201610) {
        switch (buttonIndex) {
            case 1:
            {
                NSString *zdsid = [NSString stringWithFormat:@"%@",zdsId];
                NSString *usrid = [GlobleData sharedInstance].userid;
                NSString *keyId;
                NSString *usreKey;
                if (zdsid && zdsid.length > 0) {
                    keyId = [NSString stringWithFormat:@"%@",zdsid];
                    usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:[GlobleData sharedInstance].dealtype];
                }else{
                    usreKey = [usrid stringByAppendingString:[GlobleData sharedInstance].dealtype];
                }

                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault removeObjectForKey:usreKey];
                [userdefault synchronize];
                
                ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
                VC.zdsId = zdsId;
                VC.tuihuoType = tuihuotype;
                [self presentViewController:VC animated:YES completion:nil];
            }
                break;
            default:
            {
                ScanPhoneViewController *VC = [[ScanPhoneViewController alloc] init];
                VC.zdsId = zdsId;
                VC.tuihuoType = tuihuotype;
                [self presentViewController:VC animated:YES completion:nil];
            }
                break;
        }

    }
}
//自定义提示框
- (void)showMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 100;
    CGFloat h = size.height + 20;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = window.bounds.size.height / 2 + 100;
    showview.frame = CGRectMake(x, y, w, h);
    showview.backgroundColor = RGB(0, 0, 0, 0.7);
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, w, h);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = K_FONT_14;
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
