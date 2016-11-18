//
//  ImageAlertView.h
//  CIBSafeBrowser
//
//  Created by luolihacker on 15/12/30.
//  Copyright © 2015年 cib. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageAlertViewDelegate
- (void)clickMyButtonIndex:(NSInteger)buttonIndex;
@end

@interface ImageAlertView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isSelect;
@property (weak, nonatomic) id<ImageAlertViewDelegate>delegate;
- (void)viewShowWithImage:(UIImage *)loadingImage message:(NSString *)message;
@end





