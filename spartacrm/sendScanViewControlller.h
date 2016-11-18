//
//  sendScanViewControlller.h
//  wly
//
//  Created by luolihacker on 16/1/28.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol UIViewPassSendValueDelegate <NSObject>

@optional
- (void)passSendValue:(NSString *)value;
@end

@interface sendScanViewControlller : UIViewController
{
    int num;
    BOOL upOrdown;//判断是否上下
    NSTimer * timer;//时间
}
@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;
@property ( strong , nonatomic ) AVCaptureSession * session;
@property ( strong , nonatomic ) AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain ) UIImageView * line;//扫描线
@property (nonatomic , strong ) NSString * string;//结果
@property (nonatomic, weak) id <UIViewPassSendValueDelegate> delegate;

@end
