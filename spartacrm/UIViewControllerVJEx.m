//
//  UIViewControllerVJEx.m
//  spartacrm
//
//  Created by hunkzeng on 14-5-28.
//  Copyright (c) 2014年 vojo. All rights reserved.
//

#import "UIViewControllerVJEx.h"

@interface UIViewControllerVJEx ()

@end

@implementation UIViewControllerVJEx
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -UIViewControllerVJExDelegate
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];  //!< 键盘高度.
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;   //!< 键盘弹出时间.
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardWillShowEx:keyboardRect duration:animationDuration];
}




- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];//!< 键盘高度.
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration]; //!< 键盘弹出时间.
    
    [self keyboardWillHideEx:keyboardRect duration:animationDuration];
}


/**
 *
 *此类请在子类覆盖
 *
 *@brief 键盘将要弹出时的调用方法
 *@param keyboardRect 键盘显示大小
 *@param duration 键盘弹出时间
 *
 */
 
-(void) keyboardWillShowEx:(CGRect)keyboardRect duration:(NSTimeInterval)duration{
}

/**
 *
 *此类请在子类覆盖
 *
 *@brief 键盘将要半闭时的调用方法
 *@param keyboardRect 键盘显示大小
 *@param duration 键盘弹出时间
 *
 */

-(void) keyboardWillHideEx:(CGRect)keyboardRect duration:(NSTimeInterval)duration{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidUnLoad
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
