//
//  ZDOrderDetailsController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDOrderDetailsController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDRefusalController.h"
#import "NSString+LCExtension.h"
@interface ZDOrderDetailsController ()<UIScrollViewDelegate>

@property(nonatomic,weak) UIScrollView *scrollView;
//拒单按钮
@property(nonatomic,weak) UIButton *refusalButton;
//楼盘名称
@property (strong, nonatomic)UILabel *itemName;
//订单日期
@property (strong, nonatomic)UILabel *orderTime;
//客户姓名
@property (strong, nonatomic)UILabel *customerName;
//预计上客时间
@property (strong, nonatomic)UILabel *estimateTime;
//客户电话
@property (strong, nonatomic)UILabel *cusPhone;
//经纪人姓名
@property (strong, nonatomic) UILabel *brokerName;
//经纪人电话
@property (strong, nonatomic) UILabel *brokerPhone;
//打电话按钮
@property (strong, nonatomic) UIButton *playButton;
//公司
@property (strong, nonatomic) UILabel *company;
//分销
@property (strong, nonatomic) UILabel *storeAddress;
//出行人数
@property (strong, nonatomic) UILabel *travel;
//用餐人数
@property (strong, nonatomic) UILabel *meals;
//出发城市
@property (strong, nonatomic) UILabel *departureCity;
//到达方式
@property (strong, nonatomic) UILabel *partWay;
//最晚上客时间
@property (strong, nonatomic) UILabel *boardingEnd;
//数据
@property (strong, nonatomic) NSDictionary *custors;
@end

@implementation ZDOrderDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"订单详情";
    //创建view
    [self setUpController];
    //网络请求
    [self loadData];
    if ([_statu isEqual:@"1"]) {
        [_refusalButton setHidden:NO];
    }
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
     _estimateTime.text = [NSString stringWithFormat:@"预计上客：%@",[_custors valueForKey:@"boardingPlane"]];
     _cusPhone.text = [_custors valueForKey:@"missContacto"];
      NSDictionary *user = [_custors valueForKey:@"user"];
     _brokerName.text = [NSString stringWithFormat:@"姓       名：%@",[user valueForKey:@"realname"]];
     _brokerPhone.text = [user valueForKey:@"phone"];
    NSString *telphones = [user valueForKey:@"phone"];
    if ([telphones containsString:@"*"]&& ![telphones isEqual:@""]) {
        [_playButton setHidden:YES];
        [_playButton setEnabled:NO];
        _brokerPhone.textColor = UIColorRBG(153, 153, 153);
    }
     _company.text = [NSString stringWithFormat:@"公司全称：%@",[user valueForKey:@"companyName"]];
     _storeAddress.text = [NSString stringWithFormat:@"公司简称：%@",[user valueForKey:@"storeName"]];
    
     _travel.text = [NSString stringWithFormat:@"出行人数：%@",[_custors valueForKey:@"partPersonNum"]];
     _meals.text = [NSString stringWithFormat:@"用餐人数：%@",[_custors valueForKey:@"lunchNum"]];
     _departureCity.text = [NSString stringWithFormat:@"出发城市：%@",[_custors valueForKey:@"departureCity"]];
      NSString *parWay = [_custors valueForKey:@"partWay"];
    if ([parWay isEqual:@"1"]) {
        _partWay.text = [NSString stringWithFormat:@"到访方式：驾车"];
    }else if([parWay isEqual:@"2"]){
        _partWay.text = [NSString stringWithFormat:@"到访方式：班车"];
    }else{
        _partWay.text = [NSString stringWithFormat:@"到访方式：其他"];
    }
     _boardingEnd.text = [NSString stringWithFormat:@"最晚上客时间：%@",[_custors valueForKey:@"boardingEnd"]];
}
-(void)setUpController{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY, self.view.fWidth, self.view.fHeight-49);
    scrollView.backgroundColor = UIColorRBG(242, 242, 242);
    scrollView.bounces = YES;
    scrollView.delegate =self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //创建view
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(15,10,self.view.fWidth-30,555);
    view.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:view];
    scrollView.contentSize =CGSizeMake(0,view.fHeight+view.fY+10);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:@"background"];
    [view addSubview:imageView];
    //创建内容
    //楼盘名称
    UILabel *itemName = [[UILabel alloc] init];
    itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    itemName.textColor = UIColorRBG(68, 68, 68);
    _itemName = itemName;
    [view addSubview:itemName];
    [itemName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(20);
        make.left.equalTo(view.mas_left).offset(15);
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
        make.left.equalTo(view.mas_left).offset(15);
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
        make.left.equalTo(view.mas_left).offset(15);
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
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //客户电话
    UILabel *cusPhone = [[UILabel alloc] init];
    cusPhone.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    cusPhone.textColor = UIColorRBG(153, 153, 153);
    _cusPhone = cusPhone;
    [view addSubview:cusPhone];
    [cusPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customerName.mas_bottom).offset(14);
        make.left.equalTo(cusPhoneLabel.mas_right);
        make.height.offset(14);
    }];
    //预计上客时间
    UILabel *estimateTime = [[UILabel alloc] init];
    estimateTime.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    estimateTime.textColor = UIColorRBG(153, 153, 153);
    _estimateTime = estimateTime;
    [view addSubview:estimateTime];
    [estimateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cusPhoneLabel.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //经纪人
    UILabel *broke = [[UILabel alloc] init];
    broke.text = @"经纪人";
    broke.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:17];
    broke.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:broke];
    [broke mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(estimateTime.mas_bottom).offset(38);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(17);
    }];
    //经纪人姓名
    UILabel *brokerName = [[UILabel alloc] init];
    brokerName.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    brokerName.textColor = UIColorRBG(153, 153, 153);
    _brokerName = brokerName;
    [view addSubview:brokerName];
    [brokerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(broke.mas_bottom).offset(18);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //经纪人电话
    UILabel *brokerPhoneLabel = [[UILabel alloc] init];
    brokerPhoneLabel.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    brokerPhoneLabel.textColor = UIColorRBG(153, 153, 153);
    brokerPhoneLabel.text = @"电       话：";
    [view addSubview:brokerPhoneLabel];
    [brokerPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brokerName.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    
    UILabel *brokerPhone = [[UILabel alloc] init];
    brokerPhone.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    brokerPhone.textColor = UIColorRBG(3, 133, 219);
    _brokerPhone = brokerPhone;
    [view addSubview:brokerPhone];
    [brokerPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brokerName.mas_bottom).offset(14);
        make.left.equalTo(brokerPhoneLabel.mas_right);
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
        make.top.equalTo(brokerName.mas_bottom).offset(9);
        make.right.equalTo(view.mas_right).offset(-18);
        make.height.offset(23);
        make.width.offset(16);
    }];
    //经公司
    UILabel *company = [[UILabel alloc] init];
    company.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    company.textColor = UIColorRBG(153, 153, 153);
    _company = company;
    [view addSubview:company];
    [company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brokerPhone.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //分销地址
    UILabel *storeAddress = [[UILabel alloc] init];
    
    storeAddress.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    storeAddress.textColor = UIColorRBG(153, 153, 153);
    _storeAddress = storeAddress;
    [view addSubview:storeAddress];
    [storeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(company.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //更多信息
    UILabel *more = [[UILabel alloc] init];
    more.text = @"更多信息";
    more.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:16];
    more.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:more];
    [more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(storeAddress.mas_bottom).offset(38);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(16);
    }];
    //出行人数
    UILabel *travel = [[UILabel alloc] init];
    travel.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    travel.textColor = UIColorRBG(153, 153, 153);
    _travel = travel;
    [view addSubview:travel];
    [travel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(more.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //用餐人数
    UILabel *meals = [[UILabel alloc] init];
    meals.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    meals.textColor = UIColorRBG(153, 153, 153);
    _meals = meals;
    [view addSubview:meals];
    [meals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(travel.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //出发城市
    UILabel *departureCity = [[UILabel alloc] init];
    
    departureCity.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    departureCity.textColor = UIColorRBG(153, 153, 153);
    _departureCity = departureCity;
    [view addSubview:departureCity];
    [departureCity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(meals.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //到达方式
    UILabel *partWay = [[UILabel alloc] init];
    
    partWay.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    partWay.textColor = UIColorRBG(153, 153, 153);
    _partWay = partWay;
    [view addSubview:partWay];
    [partWay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(departureCity.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //最晚上客时间
    UILabel *boardingEnd = [[UILabel alloc] init];
   
    boardingEnd.font =[UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    boardingEnd.textColor = UIColorRBG(153, 153, 153);
    _boardingEnd = boardingEnd;
    [view addSubview:boardingEnd];
    [boardingEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(partWay.mas_bottom).offset(14);
        make.left.equalTo(view.mas_left).offset(15);
        make.height.offset(14);
    }];
    //创建拒单按钮
    UIButton *refusalButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.fHeight-49-JF_BOTTOM_SPACE, self.view.fWidth, 49+JF_BOTTOM_SPACE)];
    refusalButton.backgroundColor = UIColorRBG(3, 133, 219);
    _refusalButton = refusalButton;
    [refusalButton setTitle:@"拒单" forState:UIControlStateNormal];
    [refusalButton setHidden:YES];
    [refusalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refusalButton addTarget:self action:@selector(Redusal) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refusalButton];
}
//打电话
-(void)playTelphone{
    NSString *phone = _brokerPhone.text;
    
    if (![phone isEqual:@""]&&![phone isEqual:@"无"]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}
-(void)Redusal{
     ZDRefusalController *ref =[[ZDRefusalController alloc] init];
     ref.ID = _ID;
     [self.navigationController pushViewController:ref animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
