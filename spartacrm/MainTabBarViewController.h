//
//  MainTabBarViewController.h
//  spartacrm
//
//  Created by hunkzeng on 14-6-8.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface MainTabBarViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic, strong)UICollectionView *collecView;
@end
