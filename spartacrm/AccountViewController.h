//
//  AccountViewController.h
//  aioa
//
//  Created by hunkzeng on 15/8/6.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AccountControllerDelegate <NSObject>
-(void) modifyGroup:(NSString *) groupId groupName:(NSString *) groupName;
@end


@interface AccountViewController : UIViewController
- (IBAction)logoutClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDptName;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblBuildingName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblProjectName;
- (IBAction)btnGroupClick:(id)sender;



@end
