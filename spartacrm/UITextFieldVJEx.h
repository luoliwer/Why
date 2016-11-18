//
//  UITextFieldVJEx.h
//  spartacrm
//
//  Created by hunkzeng on 14-5-28.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UITextFieldVJEx : UITextField {
    
    BOOL isEnablePadding;
    float paddingLeft;
    float paddingRight;
    float paddingTop;
    float paddingBottom;
    
}

- (void)setPadding:(BOOL)enable top:(float)top right:(float)right bottom:(float)bottom left:(float)left;
@end