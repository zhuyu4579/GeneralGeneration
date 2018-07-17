//
//  ZDStorePunchController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDStorePunchController.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+LCExtension.h"
#import "ZDPunchRecordController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZDPunchTableView.h"
#import "ZDPunchItem.h"
#import "UIView+Frame.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <Masonry.h>
#import "GKCover.h"
@interface ZDStorePunchController ()<CLLocationManagerDelegate,UIAlertViewDelegate>{
    //页数
    NSInteger current;
}
//打卡记录view
@property(nonatomic,strong)UIView *punchView;
//打卡按钮
@property(nonatomic,strong)UIButton *punchButton;
//打卡记录数组
@property(nonatomic,strong)NSMutableArray *punchArray;

@property(nonatomic,strong)ZDPunchTableView *punchs;
//使用定位
@property (nonatomic , strong)CLLocationManager *locationManager;
//定位坐标
@property(nonatomic,strong)NSString *lnglat;
//打卡类型
@property(nonatomic,strong)NSString *clockType;
//打卡内容
@property(nonatomic,strong)NSString *content;
@end
//查询条数
static NSString *size = @"20";
@implementation ZDStorePunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"门店打卡";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtons:self action:@selector(punchRecord) title:@"打卡记录"];
    _punchArray = [NSMutableArray array];
    current = 1;
    //创建view
    [self setViews];
    //下拉刷新
    [self headerRefresh];
    
}
//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    
    // 设置文字
    [header setTitle:@"刷新完毕..." forState:MJRefreshStateIdle];
    [header setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中..." forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    header.mj_h = 60;
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    _punchs.mj_header = header;
    
    [_punchs.mj_header beginRefreshing];
    //创建上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _punchs.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic{
    [_punchs.mj_header beginRefreshing];
    _punchArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//上拉刷新
-(void)loadMoreData{
    [_punchs.mj_footer beginRefreshing];
    [self loadData];
}
//查询当天的跟进记录
-(void)loadData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"companyId"] = _storeId;
    paraments[@"pageNumber"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"pageSize"] = size;
    paraments[@"clockDate"] = @"";
    NSString *url = [NSString stringWithFormat:@"%@/storeClock/read/list",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            if (rows.count == 0) {
                [_punchs.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_punchArray addObject:rows[i]];
                }
                current +=1;
                [_punchs.mj_footer endRefreshing];
            }
            
            _punchs.punchArray = [ZDPunchItem mj_objectArrayWithKeyValuesArray:_punchArray];
            [_punchs reloadData];
            [_punchs.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
            [_punchs.mj_header endRefreshing];
            [_punchs.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [_punchs.mj_header endRefreshing];
        [_punchs.mj_footer endRefreshing];
    }];
}

//创建内容
-(void)setViews{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"像蜜蜂一样勤劳工作才能享受甜蜜生活";
    label.textColor = UIColorRBG(135, 135, 135);
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+70);
        make.height.offset(13);
    }];
    UIView *punchView = [[UIView alloc] init];
    _punchView = punchView;
    punchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:punchView];
    [punchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(12);
        make.left.equalTo(self.view.mas_left);
        make.width.offset(self.view.fWidth);
        make.height.offset(self.view.fHeight-kApplicationStatusBarHeight-325);
    }];
    ZDPunchTableView *punchs = [[ZDPunchTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-325)];
    _punchs = punchs;
    [punchView addSubview:punchs];
    //打卡按钮
    UIButton *punchButton = [[UIButton alloc] init];
    _punchButton = punchButton;
    [punchButton setBackgroundImage:[UIImage imageNamed:@"dk_button"] forState:UIControlStateNormal];
    [punchButton setTitle:@"门店打卡" forState:UIControlStateNormal];
    [punchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    punchButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    [punchButton setTitleEdgeInsets:UIEdgeInsetsMake(-6,0, 6, 0)];
    [punchButton addTarget:self action:@selector(records) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:punchButton];
    [punchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.offset(150);
        make.height.offset(150);
    }];
}
//打卡
-(void)records{
    //定位
    [self locate];
    
    [self performSelector:@selector(updatePunch) withObject:self afterDelay:0.5];
}
-(void)updatePunch{
    if (!_lnglat) {
        [SVProgressHUD showInfoWithStatus:@"未获取到当前位置"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"companyId"] = _storeId;
    paraments[@"lnglat"] = _lnglat;
    _punchButton.enabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@/storeClock/clockValidate",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *clockType = [data valueForKey:@"clockType"];
            NSString *content = [data valueForKey:@"addr"];
            _content  = content;
            _clockType = clockType;
            [self promptView];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
        }
        _punchButton.enabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _punchButton.enabled = YES;
        [SVProgressHUD showInfoWithStatus:@"网络不给力，打卡失败"];
    }];
}
//开启定位
-(void)locate{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //提示用户无法进行定位操作
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到当前定位服务已关闭，建议您开启定位服务"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];//开启定位
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
//获取定位信息
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSString *lnglat = @"";
    if (locations.count != 0) {
        CLLocation *currentLocation = locations[0];
        CLLocationCoordinate2D  touchMapCoordinate = currentLocation.coordinate;
        [manager stopUpdatingLocation];
        lnglat = [NSString stringWithFormat:@"%f,%f",touchMapCoordinate.longitude,touchMapCoordinate.latitude];
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"定位失败"];
    }
    _lnglat = lnglat;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lnglat forKey:@"lnglat"];
    [defaults synchronize];
}
//弹窗
-(void)promptView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.fSize = CGSizeMake(270, 265);
    view.layer.cornerRadius = 6.0;
    UILabel *title = [[UILabel alloc] init];
    if ([_clockType isEqual:@"1"]) {
        title.text = @"已进入打卡范围";
    }else{
        title.text = @"当前不在打卡范围内";
    }
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    title.textColor = UIColorRBG(101, 101, 101);
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(31);
        make.centerX.equalTo(view.mas_centerX);
        make.height.offset(16);
    }];
    UIView *ine = [[UIView alloc] init];
    ine.backgroundColor = UIColorRBG(241, 241, 241);
    [view addSubview:ine];
    [ine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(18);
        make.left.equalTo(view.mas_left);
        make.height.offset(1);
        make.width.offset(view.fWidth);
    }];
    
    UILabel *contents = [[UILabel alloc] init];
    contents.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    contents.textColor = UIColorRBG(153, 153, 153);
    contents.text = _content;
    contents.numberOfLines = 0;
    [view addSubview:contents];
    [contents mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ine.mas_bottom).offset(47);
        make.centerX.equalTo(view.mas_centerX);
        make.width.offset(view.fWidth - 30);
    }];
    UIView *ine2 = [[UIView alloc] init];
    ine2.backgroundColor = UIColorRBG(241, 241, 241);
    [view addSubview:ine2];
    [ine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(-46);
        make.left.equalTo(view.mas_left);
        make.height.offset(1);
        make.width.offset(view.fWidth);
    }];
    UIButton *eixt = [[UIButton alloc] init];
    [eixt setTitle:@"退出" forState:UIControlStateNormal];
    [eixt setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [eixt addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:eixt];
    [eixt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left);
        make.height.offset(45);
        make.width.offset(view.fWidth/2.0);
    }];
    UIButton *next = [[UIButton alloc] init];
    if ([_clockType isEqual:@"1"]) {
        [next setTitle:@"门店打卡" forState:UIControlStateNormal];
    }else{
        [next setTitle:@"外勤打卡" forState:UIControlStateNormal];
    }
    [next setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [next addTarget:self action:@selector(punchsUp) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
        make.height.offset(45);
        make.width.offset(view.fWidth/2.0);
    }];
    UIView *ineTwo = [[UIView alloc] init];
    ineTwo.backgroundColor = UIColorRBG(241, 241, 241);
    [view addSubview:ineTwo];
    [ineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom);
        make.centerX.equalTo(view.mas_centerX);
        make.height.offset(45);
        make.width.offset(1);
    }];
    
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
}
//退出弹框
-(void)closeView{
    [GKCover hide];
}
//打卡
-(void)punchsUp{
    if (!_lnglat) {
        [SVProgressHUD showInfoWithStatus:@"未获取到当前位置"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"companyId"] = _storeId;
    paraments[@"lnglat"] = _lnglat;
    
    NSString *url = [NSString stringWithFormat:@"%@/storeClock/clock",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [self closeView];
        if ([code isEqual:@"200"]) {
            _punchArray = [NSMutableArray array];
            current = 1;
            [self loadData];
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *clockType = [data valueForKey:@"clockType"];
            if ([clockType isEqual:@"1"]) {
                [SVProgressHUD showInfoWithStatus:@"打卡成功"];
            }else{
                [SVProgressHUD showInfoWithStatus:@"外勤打卡成功"];
            }
            
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showInfoWithStatus:@"网络不给力，打卡失败"];
    }];
}
//打卡记录
-(void)punchRecord{
    ZDPunchRecordController *prC = [[ZDPunchRecordController alloc] init];
    prC.storeId = _storeId;
    [self.navigationController pushViewController:prC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
