//
//  sendScanViewControlller.m
//  wly
//
//  Created by luolihacker on 16/1/28.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "sendScanViewControlller.h"
#import "MainTabBarViewController.h"
#import "ReceiveViewController.h"
#import "ScanPhoneViewController.h"
#import "GlobleData.h"
#import "CheckUIVIViewController.h"
#import "ScanPhoneSendViewController.h"

#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

@interface sendScanViewControlller ()<AVCaptureMetadataOutputObjectsDelegate>
{
    UILabel *labIntroudction;
    NSInteger Yline;
    NSInteger distance;
}
@property (nonatomic, strong) UIView *scanFrameView;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;


@end

@implementation sendScanViewControlller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self customTopViewShow:YES title:@"扫一扫"];
    //iphone 5/5s
    if(SCREEN_HEIGHT == 568.0f){
        Yline = 215;
        distance = 435;
        //4s
    }else if(SCREEN_HEIGHT == 480.0f){
        Yline = 190;
        distance = 375;
        //6
    }else if(SCREEN_HEIGHT == 667.0f){
        Yline = 240;
        distance = 500;
        //6plus
    }else if(SCREEN_HEIGHT == 736.0f){
        Yline = 255;
        distance = 545;
    }else{
        Yline = CGRectGetMaxY(labIntroudction.frame)+(int)SCREEN_WIDTH/10+(int)SCREEN_HEIGHT/50;
        distance = (int)SCREEN_HEIGHT*4/5;
    }
    //背景
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"scanBackground"];
    [self.view addSubview:imageView];
    
    //标签
    labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(15, 100, SCREEN_WIDTH-30, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50,(int)Yline, SCREEN_WIDTH-100, 3)];
    _line.image = [UIImage imageNamed:@"scanLine"];
    [_line setAlpha:0.5f];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self configUI];
    // Do any additional setup after loading the view.
}

//上下扫描
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(50, (int)Yline+3*num, SCREEN_WIDTH-100, 3);
        if (_line.center.y > (int)distance) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(50, (int)Yline+3*num, SCREEN_WIDTH-100, 3);
        if (_line.center.y < Yline) {
            upOrdown = NO;
        }
    }
    
}
//检查是否有权限
- (void)checkAVAuthorizationStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    NSString *tips = @"没有调用摄像头权限，请在手机设置中修改！";
    if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined)
    {
        [self setupCamera];
    }
    else if(status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied){
        //        [SVProgressHUD showErrorWithStatus:tips];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkAVAuthorizationStatus];
}

//调用摄像头
- (void)setupCamera
{
    // Device
    _device = [ AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
    // Input
    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self.device error : nil ];
    // Output
    _output = [[ AVCaptureMetadataOutput alloc ] init ];
    [ _output setMetadataObjectsDelegate:self  queue : dispatch_get_main_queue ()];
    //设置扫描敏感局域
    [_output setRectOfInterest:CGRectMake((Yline-10)/SCREEN_HEIGHT,40/SCREEN_WIDTH,(distance+20)/SCREEN_HEIGHT,(SCREEN_WIDTH-80)/SCREEN_WIDTH)];
    // Session
    _session = [[ AVCaptureSession alloc ] init ];
    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
    if ([ _session canAddInput : self.input ])
    {
        [ _session addInput : self.input ];
    }
    if ([ _session canAddOutput : self.output ])
    {
        [ _session addOutput : self.output ];
    }
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    [_output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    // Preview
    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill ;
    _preview.frame = self.view.layer.bounds ;
    [self.view.layer insertSublayer : _preview atIndex : 0 ];
    // Start
    [ _session startRunning];
}


// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"扫描箱码或盒码";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    navItem.titleView.frame = CGRectMake(self.view.center.x - 100, navBar.center.y - 10, 60, 20);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
}

#pragma AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _string = metadataObject.stringValue;
        [_session stopRunning];
            if ([_delegate respondsToSelector:@selector(passSendValue:)]){
                [_delegate passSendValue:_string];
                }
        [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
