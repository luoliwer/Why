//
//  ModiPswTableViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-6.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModiPswTableViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtOldPsw;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPsw;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPsw;
- (IBAction)doModiPsw:(id)sender;


@end
