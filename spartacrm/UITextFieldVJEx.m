//
//  UITextFieldVJEx.m
//  spartacrm
//
//  Created by hunkzeng on 14-5-28.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "UITextFieldVJEx.h"

@implementation UITextFieldVJEx
- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left {
    isEnablePadding = enable;
    paddingTop = top;
    paddingRight = right;
    paddingBottom = bottom;
    paddingLeft = left;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (isEnablePadding) {
        return CGRectMake(bounds.origin.x + paddingLeft,
                          bounds.origin.y + paddingTop,
                          bounds.size.width - paddingRight, bounds.size.height - paddingBottom);
    } else {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}


@end
