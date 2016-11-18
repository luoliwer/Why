//
//  AccountViewController.m
//  aioa
//
//  Created by hunkzeng on 15/8/6.
//  Copyright (c) 2015年 vojo. All rights reserved.
//

#import "AccountViewController.h"
#import "MainTabBarViewController.h"
#import "GlobleData.h"
#import "HttpTask.h"

#import "GroupTableViewControlle.h"

@implementation AccountViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *userInfo=[GlobleData sharedInstance].userInfo;
     _lblUserName.text=[NSString stringWithFormat:@"%@%@",@"姓名:",[userInfo objectForKey:@"username"]];
     _lblName.text=[NSString stringWithFormat:@"%@%@",@"登录名:",[userInfo objectForKey:@"name"]];
     _lblDptName.text=[NSString stringWithFormat:@"%@%@",@"部门:",[userInfo objectForKey:@"deptName"]];
     _lblBuildingName.text=[NSString stringWithFormat:@"%@%@",@"楼栋:",[userInfo objectForKey:@"buildName"]];
    _lblEmail.text=[NSString stringWithFormat:@"%@%@%@",@"邮件:",[userInfo objectForKey:@"username"],@"@accenture.com"];
     _lblProjectName.text=[NSString stringWithFormat:@"%@%@",@"项目:",[userInfo objectForKey:@"groupName"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id dest=[segue destinationViewController];
    if ([dest isKindOfClass:[GroupTableViewController class]]) {
        GroupTableViewController * groupController=(GroupTableViewController *) dest;
        groupController.accountControllerDelegate=self;

    }
}



#pragma mark -  OfficeSuppliesTableViewControllerDelegate
-(void) modifyGroup:(NSString *) groupId groupName:(NSString *) groupName{
    _lblProjectName.text=[NSString stringWithFormat:@"%@%@",@"项目:",groupName];
  
    [HttpTask setgroup:groupId sucessBlock:^(NSString * jsonStr) {
        
    } failBlock:^(NSDictionary * errDic) {
        
    }];

}





#pragma mark - Navigation




- (IBAction)logoutClick:(id)sender {
    
    //把帐号信息放入本地保存，退出的时候进行清空
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    [userDefaultes setValue:@"" forKey:@"usr.loginid"];
    [userDefaultes setValue:@"" forKey:@"usr.psw"];
    
    
    //解绑相关设备
    [HttpTask unbindBPush:@"4" channelid:[GlobleData sharedInstance].BPush_ChannelId sucessBlock:^(NSString * jsonStr) {
        
    } failBlock:^(NSDictionary * errDic) {
        
    }];
    
    
    [GlobleData sharedInstance].userInfo=nil;
    
    MainTabBarViewController * tabbarView = (MainTabBarViewController *) self.navigationController.parentViewController;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [tabbarView.navigationController popToRootViewControllerAnimated:YES];
    
}


- (IBAction)btnGroupClick:(id)sender {
    [self performSegueWithIdentifier:@"toGroups" sender:sender];
}
@end
