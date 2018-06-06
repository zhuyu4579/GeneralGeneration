//
//  ZDScavengController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  扫码二维码

#import "ZDScavengController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZDScaveResultController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "ZDLoginController.h"
#import "ZDNavgationController.h"
#import "UIView+Frame.h"
@interface ZDScavengController ()<AVCaptureMetadataOutputObjectsDelegate>{
    CAShapeLayer *cropLayer;
    
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIImageView * line;
@end

@implementation ZDScavengController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"扫码上客";
    [self configView];
    [self setCropRect:kScanRect];
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
}
-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"box"];
    [self.view addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.fWidth-100)/2.0, imageView.fY+imageView.fHeight+41, 100, 13)];
    label.text = @"扫描上客二维码";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [self.view addSubview:label];
}


- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
    
    
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = 220/SCREEN_WIDTH;
    CGFloat height = 220/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
        [SVProgressHUD showWithStatus:@"请稍后..."];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        //请求数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        NSString *username = [ user objectForKey:@"username"];
        if (uuid) {
            //创建会话请求
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            mgr.requestSerializer.timeoutInterval = 20;
            
            mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
            [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
            //2.拼接参数
            NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
            paraments[@"url"] = stringValue;
            
            NSString *url = [NSString stringWithFormat:@"%@/order/decodeQrCode",URL];
            [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                NSString *code = [responseObject valueForKey:@"code"];
                if ([code isEqual:@"200"]) {
                    NSDictionary *data = [responseObject valueForKey:@"data"];
                    [SVProgressHUD dismiss];
                    ZDScaveResultController *result = [[ZDScaveResultController alloc] init];
                    result.resultArray = data;
                    [self.navigationController pushViewController:result animated:YES];
                }else{
                    NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                    if (_session != nil ) {
                        [_session startRunning];
                    }
                    if ([code isEqual:@"401"]) {
                        ZDLoginController *login = [[ZDLoginController alloc] init];
                        login.admin.text = username;
                        ZDNavgationController *nav = [[ZDNavgationController alloc] initWithRootViewController:login];
                        [self.navigationController presentViewController:nav animated:YES completion:nil];
                    }
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
                if (_session != nil ) {
                    [_session startRunning];
                }
            }];
            
        }
        
        
    } else {
        
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (_session != nil ) {
        [_session startRunning];
    }
}

@end
