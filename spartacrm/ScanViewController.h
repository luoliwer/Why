//
//  ScanViewController.h
//  wly
//
//  Created by luolihacker on 15/12/15.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol UIViewPassValueDelegate <NSObject>

@optional
- (void)passValue:(NSString *)value;
@end

@interface ScanViewController : UIViewController
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
@property (nonatomic, weak) id <UIViewPassValueDelegate> delegate;
@end
