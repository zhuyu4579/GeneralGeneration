//
//  ZDNaturalCusDetailsController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/8/13.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "NSString+LCExtension.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDNaturalCusDetailsController.h"

@interface ZDNaturalCusDetailsController ()
//楼盘名称
@property (strong, nonatomic)UILabel *itemName;
//订单日期
@property (strong, nonatomic)UILabel *orderTime;
//客户姓名
@property (strong, nonatomic)UILabel *customerName;
//打电话按钮
@property (strong, nonatomic) UIButton *playButton;
//预计上客时间
@property (strong, nonatomic)UILabel *estimateTime;
//客户电话
@property (strong, nonatomic)UILabel *cusPhone;
//数据
@property (strong, nonatomic) NSDictionary *custors;

@end

@implementation ZDNaturalCusDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //创建控件
    [self createControl];
    //请求数据
    [self loadData];
}
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //防止返回值为null
    ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"id"] = _ID;
    NSString *url = [NSString stringWithFormat:@"%@/order/generalInfo",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            
            NSDictionary *data = [responseObject valueForKey:@"data"];
            _custors = data;
            [self setvalueCustor];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
//赋值
-(void)setvalueCustor{
    _itemName.text = [_custors valueForKey:@"projectName"];
    _orderTime.text = [_custors valueForKey:@"updateDate"];
    _customerName.text =[NSString stringWithFormat:@"客户姓名：%@",[_custors valueForKey:@"clientName"]];
    _estimateTime.text = [NSString stringWithFormat:@"上客时间：%@",[_custors valueForKey:@"createTime"]];
    _cusPhone.text = [_custors valueForKey:@"missContacto"];
    NSString *telphones = [_custors valueForKey:@"missContacto"];
    if ([telphones containsString:@"*"]&& ![telphones isEqual:@""]) {
        [_playButton setHidden:YES];
        [_playButton setEnabled:NO];
        _cusPhone.textColor = UIColorRBG(153, 153, 153);
    }
}
#pragma mark -创建控件
-(void)createControl{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(13);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+53);
        make.width.offset(self.view.fWidth-26);
        make.height.offset(188);
    }];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"background-1"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
        make.width.offset(self.view.fWidth-26);
        make.height.offset(188);
    }];
    //楼盘名称
    UILabel *itemName = [[UILabel alloc] init];
    itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    itemName.textColor = UIColorRBG(68, 68, 68);
    _itemName = itemName;
    [view addSubview:itemName];
    [itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(20);
        make.left.equalTo(view.mas_left).offset(18);
        make.height.offset(17);
    }];
    //楼盘日期
    UILabel *orderTime = [[UILabel alloc] init];
    orderTime.font =[UIFont fontWithName:@"PingFang-SC-Light" size:12];
    orderTime.textColor = UIColorRBG(204, 204, 204);
    _orderTime = orderTime;
    [view addSubview:orderTime];
    [orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemName.mas_bottom).offset(10);
        make.left.equalTo(view.mas_left).offset(18);
        make.height.offset(12);
    }];
    //客户姓名
    UILabel *customerName = [[UILabel alloc] init];
    customerName.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    customerName.textColor = UIColorRBG(153, 153, 153);
    _customerName = customerName;
    [view addSubview:customerName];
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderTime.mas_bottom).offset(33);
        make.left.equalTo(view.mas_left).offset(18);
        make.height.offset(14);
    }];
    //客户电话标题
    UILabel *cusPhoneLabel = [[UILabel alloc] init];
    cusPhoneLabel.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    cusPhoneLabel.textColor = UIColorRBG(153, 153, 153);
    cusPhoneLabel.text = @"客户电话：";
    [view addSubview:cusPhoneLabel];
    [cusPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerName.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(18);
        make.height.offset(14);
    }];
    //客户电话
    UILabel *cusPhone = [[UILabel alloc] init];
    cusPhone.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    cusPhone.textColor = UIColorRBG(3, 133, 219);
    _cusPhone = cusPhone;
    [view addSubview:cusPhone];
    [cusPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerName.mas_bottom).offset(14);
        make.left.equalTo(cusPhoneLabel.mas_right);
        make.height.offset(14);
    }];
    //上客时间
    UILabel *estimateTime = [[UILabel alloc] init];
    estimateTime.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    estimateTime.textColor = UIColorRBG(153, 153, 153);
    _estimateTime = estimateTime;
    [view addSubview:estimateTime];
    [estimateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cusPhoneLabel.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(18);
        make.height.offset(14);
    }];
    //打电话
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [playButton setEnlargeEdge:44];
    [playButton addTarget:self action:@selector(playTelphone) forControlEvents:UIControlEventTouchUpInside];
    _playButton = playButton;
    [view addSubview:playButton];
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerName.mas_bottom).offset(9);
        make.right.equalTo(view.mas_right).offset(-18);
        make.height.offset(23);
        make.width.offset(16);
    }];
}
//打电话
-(void)playTelphone{
    NSString *phone = _cusPhone.text;
    
    if (![phone isEqual:@""]&&![phone isEqual:@"无"]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
