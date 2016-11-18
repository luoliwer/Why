//
//  JHCustomSegue.m
//  spartacrm
//
//  Created by hunkzeng on 14-5-26.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "LoginCustomSegue.h"

@implementation LoginCustomSegue

- (void) perform {
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
}
@end
