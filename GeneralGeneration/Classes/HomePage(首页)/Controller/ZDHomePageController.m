//
//  ZDHomePageController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDHomePageController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "ZDHomePageCell.h"
#import "ZDPageItem.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDSettingController.h"
#import "ZDMeCusController.h"
#import "ZDMeProjectController.h"
#import "ZDBrokerStoreController.h"
#import "ZDAddStoreController.h"
#import "ZDScavengController.h"
#import "NSString+LCExtension.h"
#import "GKCover.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <CoreLocation/CoreLocation.h>
@interface ZDHomePageController ()<UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate>
//名称
@property(nonatomic,strong)UILabel *labelName;
//左边数据
@property(nonatomic,strong)UILabel *labelOne;
//右边数据
@property(nonatomic,strong)UILabel *labelTwo;
//按钮数组
@property(nonatomic,strong)NSArray *buttonArray;
//左边数据
@property(nonatomic,strong)UILabel *leftNum;
//右边数据
@property(nonatomic,strong)UILabel *rightNum;
//app版本
@property(nonatomic,strong)NSString *appCurVersionNum;
//账号权限
@property(nonatomic,strong)NSMutableArray *enames;
//账号权限
@property(nonatomic,strong)UICollectionView *collectionView;
//
@property(nonatomic,strong)UIView *updateView;
//
@property(nonatomic,strong)NSString *downAddress;
//使用定位
@property (nonatomic , strong)CLLocationManager *locationManager;
//定位坐标
@property(nonatomic,strong)NSString *lnglat;
@end
static NSString * const ID = @"cell";
@implementation ZDHomePageController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建首页
    [self setViewsController];
    [self headerRefresh];
    [self findVersion];
}
//开启定位
-(void)locate{
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter= 10;
        [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        [_locationManager startUpdatingLocation];//开启定位
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

//下拉刷新
-(void)headerRefresh{
    //创建下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic:)];
    
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
    
    _collectionView.mj_header = header;
   
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    [self loadData];
}
//获取字典
-(void)hadeDictionaries{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    NSString *version = [ user objectForKey:@"version"];
    if (!version ||[version isEqual:@""]) {
        version = @"0";
    }
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];

    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"version"] = version;
    paraments[@"type"] = @"1";
    NSString *url = [NSString stringWithFormat:@"%@/version/dictList",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSMutableArray *array = [data valueForKey:@"dictGroups"];
        //数据持久化
        if (array.count!=0) {
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *fileName = [path stringByAppendingPathComponent:@"dictionaries.plist"];
            [array writeToFile:fileName atomically:YES];
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[data valueForKey:@"version"] forKey:@"version"];
        [defaults synchronize];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//创建控件
-(void)setViewsController{
    //第一个view
    float n = [UIScreen mainScreen].bounds.size.height/667.0;
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, 150*n)];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"background_2"];
    imageView.frame = viewOne.bounds;
    [viewOne addSubview:imageView];
    [self.view addSubview:viewOne];
    //创建名字
    UILabel *labelName = [[UILabel alloc] init];
    labelName.text = @"经服名";
    _labelName = labelName;
    labelName.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:18];
    labelName.textColor = [UIColor whiteColor];
    [viewOne addSubview:labelName];
    [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(viewOne.mas_top).offset(65);
        make.height.offset(18);
    }];
    //第二个View
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,150*n, self.view.fWidth, self.view.fHeight -150*n)];
    viewTwo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewTwo];
    //按钮图片
     NSArray *imageArray = @[@"home",@"home_2",@"home_3",@"map",@"project",@"client",@"scan",@"set"];
     NSArray *nameArray = @[@"经纪门店",@"关注门店",@"新增门店",@"地图找店",@"我的项目",@"我的客户",@"扫码上客",@"设置"];
    NSArray *nameType = @[@"jjmd",@"gzmd",@"xzmd",@"dtzd",@"wdxm",@"wdkh",@"smsk",@"sz"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<nameArray.count; i++) {
        NSMutableDictionary *button = [NSMutableDictionary dictionary];
        button[@"imageName"] = imageArray[i];
        button[@"name"] = nameArray[i];
        button[@"tag"] = [NSString stringWithFormat:@"%i",(100+i)];
        button[@"enames"] = nameType[i];
        [array addObject:button];
    }
    _buttonArray = [ZDPageItem mj_objectArrayWithKeyValuesArray:array];
    //创建按钮
     [self getUpButtonItem:viewTwo];
   //第三个view
    UIView *viewThew = [[UIView alloc] initWithFrame:CGRectMake(15, 150*n-40, self.view.fWidth-30, 80)];
    viewThew.backgroundColor = [UIColor whiteColor];
    viewThew.layer.cornerRadius = 4.0;
    viewThew.layer.shadowColor = [UIColor grayColor].CGColor;
    viewThew.layer.shadowOpacity = 0.8f;
    viewThew.layer.shadowRadius = 4.0f;
    viewThew.layer.shadowOffset = CGSizeMake(0,0);
    [self.view addSubview:viewThew];
    //创建两个label
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"今日订单";
    _labelOne = labelOne;
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelOne.textColor = UIColorRBG(68, 68, 68);
    [viewThew addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewThew.mas_centerX).offset(-viewThew.fWidth/4);
        make.top.equalTo(viewThew.mas_top).offset(28);
        make.height.offset(14);
    }];
    UILabel *labelOneNum = [[UILabel alloc] init];
    _leftNum = labelOneNum;
    labelOneNum.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelOneNum.textColor = UIColorRBG(153, 153, 153);
    [viewThew addSubview:labelOneNum];
    [labelOneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewThew.mas_centerX).offset(-viewThew.fWidth/4);
        make.top.equalTo(labelOne.mas_bottom).offset(9);
        make.height.offset(12);
    }];
    UIView *viewIne = [[UIView alloc] init];
    viewIne.frame = CGRectMake(viewThew.fWidth/2-0.5,10,1,viewThew.fHeight-20);
    viewIne.backgroundColor = UIColorRBG(238, 238, 238);
    [viewThew addSubview:viewIne];
   
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"签约门店";
    _labelTwo = labelTwo;
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwo.textColor = UIColorRBG(68, 68, 68);
    [viewThew addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewThew.mas_centerX).offset(viewThew.fWidth/4);
        make.top.equalTo(viewThew.mas_top).offset(28);
        make.height.offset(14);
    }];
    UILabel *labelTwoNum = [[UILabel alloc] init];
    _rightNum = labelTwoNum;
    labelTwoNum.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    labelTwoNum.textColor = UIColorRBG(153, 153, 153);
    [viewThew addSubview:labelTwoNum];
    [labelTwoNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewThew.mas_centerX).offset(viewThew.fWidth/4);
        make.top.equalTo(labelOne.mas_bottom).offset(9);
        make.height.offset(12);
    }];
}
#pragma mark -创建城市列表
-(void)getUpButtonItem:(UIView *)view{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(78, 28, 20, 28);
    layout.minimumLineSpacing = 34;
    layout.minimumInteritemSpacing = 30;
    layout.estimatedItemSize = CGSizeMake(80, 117);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView = collectionView;
    [view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZDHomePageCell" bundle:nil] forCellWithReuseIdentifier:ID];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _buttonArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHomePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    ZDPageItem *item = self.buttonArray[indexPath.row];
    cell.item = item;
    return cell;
}
#pragma mark -点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZDHomePageCell *cell =(ZDHomePageCell *) [collectionView cellForItemAtIndexPath:indexPath];
    NSString *tags = cell.tags;
    NSString *ename = cell.ename;
    if (![ename isEqual:@"sz"]) {
        BOOL isbool = [_enames containsObject: ename];
        if (!isbool) {
            [SVProgressHUD showInfoWithStatus:@"权限不够！无法操作"];
            return;
        }
    }
    int tag = [tags intValue];
    
    //点击跳转
    switch (tag) {
        case 100:
            //我的门店
            [self brokerStore];
            break;
        case 101:
            //我的收藏
            [self CollStore];
            break;
        case 102:
            //新增门店
            [self addStore];
            break;
        case 103:
            [self mapFindStore];
            break;
        case 104:
            //我的客户
            [self meProject];
            break;
        case 105:
           //扫码上客
            [self meCustomer];
            break;
        case 106:
            //设置
            [self scaveng];
            break;
        case 107:
            //设置
            [self setting];
            break;
    }
}
//扫码上客
-(void)scaveng{
    ZDScavengController *scaVc = [[ZDScavengController alloc] init];
    [self.navigationController pushViewController:scaVc animated:YES];
}

//新增门店
-(void)addStore{
    ZDAddStoreController *addStore =   [[ZDAddStoreController alloc] init];
    [self.navigationController pushViewController:addStore animated:YES];
}
//我的收藏
-(void)CollStore{
    ZDBrokerStoreController *droker = [[ZDBrokerStoreController alloc] init];
    droker.status =1;
    [self.navigationController pushViewController:droker animated:YES];
}
//地图找店
-(void)mapFindStore{
    
}
//经纪门店
-(void)brokerStore{
    ZDBrokerStoreController *droker = [[ZDBrokerStoreController alloc] init];
    droker.status =0;
    [self.navigationController pushViewController:droker animated:YES];
}
//我的项目
-(void)meProject{
    ZDMeProjectController *mePro = [[ZDMeProjectController alloc] init];
    [self.navigationController pushViewController:mePro animated:YES];
}
//我的客户
-(void)meCustomer{
    ZDMeCusController *meCusVc = [[ZDMeCusController alloc] init];
    [self.navigationController pushViewController:meCusVc animated:YES];
}
//点击设置
-(void)setting{
    ZDSettingController *setting = [[ZDSettingController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //获取定位
    [self locate];
    //获取数据
    [self loadData];
    //获取字典
    [self hadeDictionaries];
}
//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSString *realname = [ user objectForKey:@"realname"];
    NSString *jobType = [ user objectForKey:@"jobType"];
    _labelName.text = realname;
    if ([jobType isEqual:@"1"]) {
        _labelOne.text = @"今日订单";
        _labelTwo.text = @"签约门店";
    }else if([jobType isEqual:@"2"]){
        _labelOne.text = @"预约上客";
        _labelTwo.text = @"今日上客";
    }
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        NSString *url = [NSString stringWithFormat:@"%@/sysUser/page",URL];
        [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                _leftNum.text = [data valueForKey:@"left"];
                _rightNum.text = [data valueForKey:@"right"];
                _enames = [data valueForKey:@"enames"];
                 [_collectionView.mj_header endRefreshing];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
                [_collectionView.mj_header endRefreshing];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            [_collectionView.mj_header endRefreshing];
        }];
    
}
#pragma mark - 版本获取
-(void)findVersion{
    // 当前应用版本号码   int类型
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _appCurVersionNum = appCurVersionNum;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"type"] = @"2";
    paraments[@"app"] = @"1";
    NSString *url = [NSString stringWithFormat:@"%@/version/versionUp",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            //最新版本号
            NSString *newVersion = [data valueForKey:@"version"];
            NSString *downAddress = [data valueForKey:@"downAddress"];
            _downAddress = downAddress;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:newVersion forKey:@"newVersion"];
            [defaults setObject:downAddress forKey:@"downAddress"];
            [defaults synchronize];
            
            NSInteger vn = [NSString compareVersion:appCurVersionNum to:newVersion];
            
            if (vn != 0) {
                [self updateVersion:data];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
//创建更新版本窗口
-(void)updateVersion:(NSDictionary *)dicy{
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(295, 392);
    _updateView = view;
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, view.fWidth, view.fHeight);
    imageView.image = [UIImage imageNamed:@"pop_2"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"发现新版本！(%@)",[dicy valueForKey:@"version"]];
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    label.textColor = UIColorRBG(68, 68, 68);
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(28);
        make.top.equalTo(view.mas_top).offset(168);
        make.height.offset(18);
    }];
    UIButton *cleanButton = [[UIButton alloc] init];
    [cleanButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cleanButton addTarget:self action:@selector(closeVersion) forControlEvents:UIControlEventTouchUpInside];
    [cleanButton setEnlargeEdge:44];
    NSString *isno_up = [dicy valueForKey:@"isno_up"];
    if ([isno_up isEqual:@"1"]) {
        [cleanButton setHidden:YES];
        cleanButton.enabled = NO;
    }else{
        [cleanButton setHidden:NO];
        cleanButton.enabled = YES;
    }
    [view addSubview:cleanButton];
    [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-21);
        make.top.equalTo(view.mas_top).offset(142);
        make.height.offset(22);
        make.width.offset(22);
    }];
    UILabel *description = [[UILabel alloc] init];
    description.text = [dicy valueForKey:@"version_description"];
    description.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    description.textColor = UIColorRBG(153, 153, 153);
    description.numberOfLines = 0;
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(28);
        make.top.equalTo(label.mas_bottom).offset(24);
        make.width.offset(view.fWidth-56);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"立即更新" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updataVersions) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"background_2"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.bottom.equalTo(view.mas_bottom).offset(-21);
        make.height.offset(43);
        make.width.offset(124);
    }];
    
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];

}
-(void)closeVersion{
    [GKCover hide];
}
-(void)updataVersions{
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_downAddress]]];
}
@end
