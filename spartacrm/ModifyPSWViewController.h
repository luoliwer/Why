//
//  ModifyPSWViewController.h
//  wly
//
//  Created by luolihacker on 16/1/4.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyPSWViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *verifyInfoCode;
@property (strong, nonatomic) IBOutlet UITextField *newpsw;
- (IBAction)touchInsideAction:(id)sender;

- (IBAction)modifyPSW:(id)sender;
@end
