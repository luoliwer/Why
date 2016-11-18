//
//  UIView+FindFirstResponder.m
//  spartacrm
//
//  Created by hunkzeng on 14-5-28.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "UIView+VJEx.h"

@implementation UIView (VJEx)
- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        id responder = [subView findFirstResponder];
        if (responder) return responder;
    }
    return nil;
}
@end
