//
//  TerminalAccountApplyViewController.h
//  wly
//
//  Created by luolihacker on 16/1/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TerminalAccountApplyViewController : UIViewController
@property (nonatomic, strong)UITextField *terminalNameTextField;
@property (nonatomic, strong)UITextField *teleTextField;
@property (nonatomic, strong)UITextField *addressTextField;
@property (nonatomic, strong)UIControl *selectBtn;
@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *commitBtn;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong)NSArray *listArray;
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)NSString *nameText;
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)NSString *whichIsSelected;

@end
