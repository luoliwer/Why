//
//  AdviseViewController.m
//  aioa
//
//  Created by hunkzeng on 15/8/16.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "AdviseViewController.h"
#import "SAMTextView.h"
#import "HttpTask.h"

@interface AdviseViewController ()

@end

@implementation AdviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您的要求是我们努力的方向，期待倾听您的声音"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[str length])];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0] range:NSMakeRange(0, [str length])];

    
    _textAdvise.attributedPlaceholder=str;

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

- (IBAction)btnSubmitClick:(id)sender {
    [HttpTask suggestionAdd:_textAdvise.text sucessBlock:^(NSString * jsonDic) {
        _textAdvise.text=@"";
    } failBlock:^(NSDictionary * errDic) {
        
    }];
    
    [[[UIAlertView alloc]initWithTitle:@"提示"
                               message:@"您的建议已提交，谢谢！"
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil] show];

}
@end
