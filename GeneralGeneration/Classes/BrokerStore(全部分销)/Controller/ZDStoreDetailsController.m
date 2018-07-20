//
//  ZDStoreDetailsController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDStoreDetailsController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <BRPickerView.h>
#import "ZDProjectListView.h"
#import "ZDProjectListItem.h"
#import "ZDContractProjectController.h"
#import "ZDReadFollowsController.h"
#import "ZDMapController.h"
#import "NSString+LCExtension.h"
#import "ZDStorePunchController.h"
#import "UIBarButtonItem+Item.h"
@interface ZDStoreDetailsController ()<UITextViewDelegate,UITextFieldDelegate>
//内容scrollView
@property(nonatomic,strong)UIScrollView *scrollView;
//分销名称
@property(nonatomic,strong)UILabel *storeName;
//分销编码
@property(nonatomic,strong)UILabel *companyCode;
//分销类型
@property(nonatomic,strong)UILabel *storeType;
//分销按钮
@property(nonatomic,strong)UIButton *storeTypeButton;
//录入经服
@property(nonatomic,strong)UILabel *storeCreator;
//公司名称
@property(nonatomic,strong)UITextField *companyName;
//分销位置
@property(nonatomic,strong)UIButton *addrButton;
@property(nonatomic,strong)UILabel *address;
//分销地址
@property(nonatomic,strong)UITextField *addr;
//分销人数
@property(nonatomic,strong)UITextField *totalPeople;
//负责人
@property(nonatomic,strong)UITextField *dutyName;
//联系电话
@property(nonatomic,strong)UITextField *telphone;
//公司简介
@property(nonatomic,strong)UITextView *remarks;
//数据字典
@property(nonatomic,strong)NSDictionary *storeDicty;
//是否已关注
@property(nonatomic,strong)NSString *iscollect;
//按钮view
@property(nonatomic,strong)UIView *buttonView;
//签约楼盘
@property (strong, nonatomic)  UIButton *contractProject;
//关注
@property (strong, nonatomic)  UIButton *collect;
//写跟进
@property (strong, nonatomic)  UIButton *readFollow;
//打卡
@property (strong, nonatomic)  UIButton *punsh;
//分销经纬度
@property(nonatomic,strong)NSString *lnglat;
//已签约楼盘
@property(nonatomic,strong)NSArray *projectList;
//公司简介view
@property(nonatomic,strong)UIView *viewSix;
//已签约楼盘View
@property(nonatomic,strong)UIView *projectView;
//已签约楼盘View
@property(nonatomic,strong)UIView *projectListView;
//已签约楼盘View
@property(nonatomic,strong)NSString *adCode;
//分销类型数组
@property(nonatomic,strong)NSMutableArray *storeTypeArray;
//分销类型数组value
@property(nonatomic,strong)NSMutableArray *valueTypeArray;

@end

@implementation ZDStoreDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    //读取数据字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictionaries.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    
    NSArray *itemArray;
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //跟进类别
        if ([code isEqual:@"mdlx"]) {
            itemArray = [obj valueForKey:@"dicts"];
        }
    }
    _storeTypeArray = [NSMutableArray array];
    _valueTypeArray = [NSMutableArray array];
    for (NSDictionary *dicty in itemArray) {
        NSString *label = [dicty valueForKey:@"label"];
        NSString *value = [dicty valueForKey:@"value"];
        [_storeTypeArray addObject:label];
        [_valueTypeArray addObject:value];
    }
    //设置标题
    [self setNav];
    //创建内容
    [self creatController];
    //请求数据
    [self loadData];
    
}
//设置标题
-(void)setNav{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"详情页";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(edit) title:@"编辑"];
}
//请求数据
-(void)loadData{
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _storeId;
         NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompany/info",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                _storeDicty = data;
                [self setUpData];
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
//设置内容数据
-(void)setUpData{
    _storeName.text = [_storeDicty valueForKey:@"name"];
    _companyName.text = [_storeDicty valueForKey:@"companyName"];
    _companyCode.text = [_storeDicty valueForKey:@"storeCode"];
    //分销类型
    NSString *storeType =  [_storeDicty valueForKey:@"storeType"];
    
    for (int i = 0; i<_valueTypeArray.count; i++) {
        if ([storeType isEqual:_valueTypeArray[i]]) {
            _storeType.text = _storeTypeArray[i];
            break;
        }
    }
    _storeCreator.text = [_storeDicty valueForKey:@"storeCreator"];
    _address.text = [_storeDicty valueForKey:@"address"];
    _addr.text = [_storeDicty valueForKey:@"addr"];
    _totalPeople.text = [_storeDicty valueForKey:@"totalPeople"];
    _dutyName.text = [_storeDicty valueForKey:@"dutyName"];
    _telphone.text = [_storeDicty valueForKey:@"telphone"];
    _remarks.text = [_storeDicty valueForKey:@"remarks"];
    _iscollect = [_storeDicty valueForKey:@"collect"];
    _adCode = [_storeDicty valueForKey:@"adCode"];
    if ([_iscollect isEqual:@"0"]) {
        [_collect setTitle:@"加关注" forState:UIControlStateNormal];
    }else if([_iscollect isEqual:@"1"]){
        [_collect setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    _lnglat = [_storeDicty valueForKey:@"lnglat"];
    
    _projectList = [_storeDicty valueForKey:@"projectList"];
    if(_projectList.count==0){
        [_projectListView setHidden:YES];
        [_projectView setHidden:YES];
    }
}
//创建内容
-(void)creatController{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight-20, self.view.fWidth, self.view.fHeight-51)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    //创建内容
    [self createVC];
    //创建签约楼盘列表
    UIView *projectView = [[UIView alloc] initWithFrame:CGRectMake(self.view.fWidth-38, 220, 38, 125)];
    _projectView = projectView;
    projectView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:projectView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, projectView.fWidth, projectView.fHeight)];
    imageView.image = [UIImage imageNamed:@"window"];
    [projectView addSubview:imageView];
    UIButton *button = [[UIButton alloc] init];
    button.frame = imageView.bounds;
    [button setImage:[UIImage imageNamed:@"arrowmark_2"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.numberOfLines = 0;
    [button setTitle:@" 已\n 签\n 约\n 项\n 目" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(projectLiset) forControlEvents:UIControlEventTouchUpInside];
    [projectView addSubview:button];
    
    //创建按钮view
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fHeight-49-JF_BOTTOM_SPACE, self.view.fWidth, 49+JF_BOTTOM_SPACE)];
    buttonView.backgroundColor = [UIColor whiteColor];
    _buttonView = buttonView;
    [self.view addSubview:buttonView];
    //创建按钮
    UIButton *contractProject = [[UIButton alloc] init];
    contractProject.layer.cornerRadius = 10.0;
    contractProject.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    contractProject.layer.borderWidth = 1.0;
    _contractProject = contractProject;
    [contractProject setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [contractProject setTitle:@"签约楼盘" forState:UIControlStateNormal];
    [contractProject addTarget:self action:@selector(contractProjects) forControlEvents:UIControlEventTouchUpInside];

    contractProject.titleLabel.font = [UIFont systemFontOfSize:13];
    [buttonView addSubview:contractProject];
    [contractProject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(15);
        make.right.equalTo(buttonView.mas_right).offset(-15);
        make.width.offset(60);
        make.height.offset(20);
    }];
    
    UIButton *collect = [[UIButton alloc] init];
    collect.layer.cornerRadius = 10.0;
    collect.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    collect.layer.borderWidth = 1.0;
    _collect = collect;
    [collect setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [collect setTitle:@"加关注" forState:UIControlStateNormal];
    collect.titleLabel.font = [UIFont systemFontOfSize:13];
    [collect addTarget:self action:@selector(collects) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:collect];
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(15);
        make.right.equalTo(contractProject.mas_left).offset(-18);
        make.width.offset(60);
        make.height.offset(20);
    }];
    
    UIButton *readFollow = [[UIButton alloc] init];
    readFollow.layer.cornerRadius = 10.0;
    readFollow.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    readFollow.layer.borderWidth = 1.0;
    _readFollow = readFollow;
    [readFollow setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [readFollow setTitle:@"跟进" forState:UIControlStateNormal];
    readFollow.titleLabel.font = [UIFont systemFontOfSize:13];

    [readFollow addTarget:self action:@selector(readFollows) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:readFollow];
    [readFollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(15);
        make.right.equalTo(collect.mas_left).offset(-18);
        make.width.offset(60);
        make.height.offset(20);
    }];
    
    UIButton *punsh = [[UIButton alloc] init];
    punsh.layer.cornerRadius = 10.0;
    punsh.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    punsh.layer.borderWidth = 1.0;
    _punsh = punsh;
    [punsh setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [punsh setTitle:@"打卡" forState:UIControlStateNormal];
    punsh.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [punsh addTarget:self action:@selector(punshs) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:punsh];
    [punsh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top).offset(15);
        make.right.equalTo(readFollow.mas_left).offset(-18);
        make.width.offset(60);
        make.height.offset(20);
    }];
}

//创建内容
-(void)createVC{
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.fWidth, 181)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewOne];
    //第一个view
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.text = @"公司简称:";
    labelOne.textColor = UIColorRBG(153, 153, 153);
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewOne addSubview:labelOne];
    [labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewOne.mas_top).offset(17);
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.height.offset(13);
    }];
    //分销名称
    UILabel *storeName = [[UILabel alloc] init];
    storeName.text = @"无";
    storeName.textColor = UIColorRBG(68, 68, 68);
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [viewOne addSubview:storeName];
    _storeName = storeName;
    [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewOne.mas_top).offset(16);
        make.left.equalTo(labelOne.mas_right).offset(9);
        make.height.offset(14);
    }];
    UIView *ineOne = [[UIView alloc] initWithFrame:CGRectMake(15, 45, viewOne.fWidth-15, 1)];
    ineOne.backgroundColor = UIColorRBG(242, 242, 242);
    [viewOne addSubview:ineOne];
    
    //分销编码
    UILabel *companyCodeLabel = [[UILabel alloc] init];
    companyCodeLabel.text = @"分销编码:";
    companyCodeLabel.textColor = UIColorRBG(153, 153, 153);
    companyCodeLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewOne addSubview:companyCodeLabel];
    [companyCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOne.mas_bottom).offset(17);
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.height.offset(13);
    }];
    //分销名称
    UILabel *companyCode = [[UILabel alloc] init];
    companyCode.text = @"无";
    companyCode.textColor = UIColorRBG(68, 68, 68);
    companyCode.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [viewOne addSubview:companyCode];
    _companyCode = companyCode;
    [companyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOne.mas_bottom).offset(16);
        make.left.equalTo(companyCodeLabel.mas_right).offset(9);
        make.height.offset(14);
    }];
    UIView *ineOnes = [[UIView alloc] initWithFrame:CGRectMake(15, 90, viewOne.fWidth-15, 1)];
    ineOnes.backgroundColor = UIColorRBG(242, 242, 242);
    [viewOne addSubview:ineOnes];
    
    UILabel *labelOne2 = [[UILabel alloc] init];
    labelOne2.text = @"公司名称:";
    labelOne2.textColor = UIColorRBG(153, 153, 153);
    labelOne2.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewOne addSubview:labelOne2];
    [labelOne2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOnes.mas_bottom).offset(17);
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.height.offset(13);
    }];
    //公司名称
    UITextField *companyName = [[UITextField alloc] init];
    companyName.borderStyle = UITextBorderStyleNone;
    companyName.textColor = UIColorRBG(68, 68, 68);
    companyName.placeholder = @"请输入公司名称";
    companyName.font = [UIFont systemFontOfSize:14];
    companyName.keyboardType = UIKeyboardTypeDefault;
    companyName.enabled = NO;
    companyName.delegate = self;
    _companyName = companyName;
    [viewOne addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOnes.mas_bottom).offset(0);
        make.left.equalTo(labelOne2.mas_right).offset(9);
        make.height.offset(45);
        make.width.offset(250);
    }];
    //分割线
    UIView *ineOneTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 135, viewOne.fWidth-15, 1)];
    ineOneTwo.backgroundColor = UIColorRBG(242, 242, 242);
    [viewOne addSubview:ineOneTwo];
    
    UILabel *labelOne3 = [[UILabel alloc] init];
    labelOne3.text = @"分销类型:";
    labelOne3.textColor = UIColorRBG(153, 153, 153);
    labelOne3.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewOne addSubview:labelOne3];
    [labelOne3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOneTwo.mas_bottom).offset(17);
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.height.offset(13);
    }];
    
    //分销类型
    UILabel *storeType = [[UILabel alloc] init];
    storeType.text = @"无";
    storeType.textColor = UIColorRBG(68, 68, 68);
    storeType.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    _storeType = storeType;
    [viewOne addSubview:storeType];
    [storeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOneTwo.mas_bottom).offset(16);
        make.left.equalTo(labelOne.mas_right).offset(9);
        make.height.offset(14);
    }];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.image = [UIImage imageNamed:@"more_unfold_2"];
    [viewOne addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOneTwo.mas_bottom).offset(14);
        make.right.equalTo(viewOne.mas_right).offset(-15);
        make.height.offset(17);
        make.width.offset(9);
    }];
    //选择按钮
    UIButton *typeButton = [[UIButton alloc] init];
    [typeButton addTarget:self action:@selector(selectStoreType) forControlEvents:UIControlEventTouchUpInside];
    _storeTypeButton = typeButton;
    [typeButton setEnabled:NO];
    [viewOne addSubview:typeButton];
    [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineOneTwo.mas_bottom);
        make.left.equalTo(viewOne.mas_left);
        make.height.offset(45);
        make.width.offset(viewOne.fWidth);
    }];
    
    
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0,viewOne.fY+viewOne.fHeight+10, _scrollView.fWidth, 91)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewTwo];
    
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"位      置:";
    labelTwo.textColor = UIColorRBG(153, 153, 153);
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewTwo addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTwo.mas_top).offset(17);
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.height.offset(13);
    }];
    //分销位置
    UIButton *addrButton = [[UIButton alloc] init];
    [addrButton setEnlargeEdgeWithTop:15 right:100 bottom:15 left:100];
    addrButton.enabled = NO;
    _addrButton = addrButton;
    [addrButton setBackgroundImage:[UIImage imageNamed:@"place"] forState:UIControlStateNormal];
    [addrButton addTarget:self action:@selector(addrSelect) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:addrButton];
    [addrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTwo.mas_top).offset(11.5);
        make.left.equalTo(labelTwo.mas_right).offset(9);
        make.height.offset(22);
        make.width.offset(16);
    }];
    UILabel *address = [[UILabel alloc] init];
    address.text = @"点击按钮选择位置";
    address.textColor = UIColorRBG(68, 68, 68);
    _address = address;
    address.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    [viewTwo addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTwo.mas_top).offset(17);
        make.left.equalTo(addrButton.mas_right).offset(10);
        make.height.offset(13);
    }];
    
    UIView *ineTwo = [[UIView alloc] initWithFrame:CGRectMake(15, 45, viewTwo.fWidth-15, 1)];
    ineTwo.backgroundColor = UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ineTwo];
    
    UILabel *labelTwo2 = [[UILabel alloc] init];
    labelTwo2.text = @"详细地址:";
    labelTwo2.textColor = UIColorRBG(153, 153, 153);
    labelTwo2.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewTwo addSubview:labelTwo2];
    [labelTwo2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineTwo.mas_bottom).offset(17);
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.height.offset(13);
    }];
    //分销地址
    UITextField *addr = [[UITextField alloc] init];
    addr.borderStyle = UITextBorderStyleNone;
    addr.textColor = UIColorRBG(68, 68, 68);
    addr.placeholder = @"请输入详细地址";
    addr.font = [UIFont systemFontOfSize:14];
    addr.keyboardType = UIKeyboardTypeDefault;
    addr.delegate = self;
    addr.enabled = NO;
    _addr = addr;
    [viewTwo addSubview:addr];
    [addr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineTwo.mas_bottom).offset(0);
        make.left.equalTo(labelTwo2.mas_right).offset(9);
        make.height.offset(45);
        make.width.offset(250);
    }];
    
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+10, _scrollView.fWidth, 45)];
    viewThree.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewThree];
    
    UILabel *labelThree = [[UILabel alloc] init];
    labelThree.text = @"人     数:";
    labelThree.textColor = UIColorRBG(153, 153, 153);
    labelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewThree addSubview:labelThree];
    [labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewThree.mas_top).offset(17);
        make.left.equalTo(viewThree.mas_left).offset(15);
        make.height.offset(13);
    }];
    //分销人数
    UITextField *totalPeople = [[UITextField alloc] init];
    totalPeople.borderStyle = UITextBorderStyleNone;
    totalPeople.textColor = UIColorRBG(68, 68, 68);
    totalPeople.placeholder = @"请输入人数";
    totalPeople.font = [UIFont systemFontOfSize:14];
    totalPeople.keyboardType = UIKeyboardTypeNumberPad;
    totalPeople.delegate = self;
    totalPeople.enabled = NO;
    _totalPeople = totalPeople;
    [viewThree addSubview:totalPeople];
    [totalPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewThree.mas_top).offset(0);
        make.left.equalTo(labelThree.mas_right).offset(9);
        make.height.offset(45);
        make.width.offset(250);
    }];
    
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, viewThree.fY+viewThree.fHeight+10, _scrollView.fWidth, 91)];
    viewFour.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewFour];
    
    UILabel *labelFour = [[UILabel alloc] init];
    labelFour.text = @"负 责 人:";
    labelFour.textColor = UIColorRBG(153, 153, 153);
    labelFour.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewFour addSubview:labelFour];
    [labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewFour.mas_top).offset(17);
        make.left.equalTo(viewFour.mas_left).offset(15);
        make.height.offset(13);
    }];
    //负责人姓名
    UITextField *dutyName = [[UITextField alloc] init];
    dutyName.borderStyle = UITextBorderStyleNone;
    dutyName.textColor = UIColorRBG(68, 68, 68);
    dutyName.placeholder = @"请输入负责人姓名";
    dutyName.font = [UIFont systemFontOfSize:14];
    dutyName.keyboardType = UIKeyboardTypeDefault;
    dutyName.delegate = self;
    dutyName.enabled = NO;
    _dutyName = dutyName;
    [viewFour addSubview:dutyName];
    [dutyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewFour.mas_top).offset(0);
        make.left.equalTo(labelFour.mas_right).offset(9);
        make.height.offset(45);
        make.width.offset(250);
    }];
    
    UIView *ineFour = [[UIView alloc] initWithFrame:CGRectMake(15, 45, viewFour.fWidth-15, 1)];
    ineFour.backgroundColor = UIColorRBG(242, 242, 242);
    [viewFour addSubview:ineFour];
    
    UILabel *labelFour2 = [[UILabel alloc] init];
    labelFour2.text = @"联系电话:";
    labelFour2.textColor = UIColorRBG(153, 153, 153);
    labelFour2.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewFour addSubview:labelFour2];
    [labelFour2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineFour.mas_bottom).offset(17);
        make.left.equalTo(viewFour.mas_left).offset(15);
        make.height.offset(13);
    }];
    //联系电话
    UITextField *telphone = [[UITextField alloc] init];
    telphone.borderStyle = UITextBorderStyleNone;
    telphone.textColor = UIColorRBG(68, 68, 68);
    telphone.placeholder = @"请输入联系电话";
    telphone.font = [UIFont systemFontOfSize:14];
    telphone.keyboardType = UIKeyboardTypeNumberPad;
    telphone.delegate = self;
    telphone.enabled = NO;
    _telphone = telphone;
    [viewFour addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineFour.mas_bottom).offset(0);
        make.left.equalTo(labelFour2.mas_right).offset(9);
        make.height.offset(45);
        make.width.offset(250);
    }];
    UIButton *playPhone = [[UIButton alloc] init];
    [playPhone setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [playPhone setEnlargeEdge:10];
    [playPhone addTarget:self action:@selector(playPhone) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:playPhone];
    [playPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineFour.mas_bottom).offset(11);
        make.right.equalTo(viewFour.mas_right).offset(-15);
        make.height.offset(23);
        make.width.offset(16);
    }];
    UIView *viewFive = [[UIView alloc] initWithFrame:CGRectMake(0, viewFour.fY+viewFour.fHeight+10, _scrollView.fWidth, 45)];
    viewFive.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:viewFive];
    
    UILabel *labelFive = [[UILabel alloc] init];
    labelFive.text = @"录入经服:";
    labelFive.textColor = UIColorRBG(153, 153, 153);
    labelFive.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewFive addSubview:labelFive];
    [labelFive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewFive.mas_top).offset(17);
        make.left.equalTo(viewFive.mas_left).offset(15);
        make.height.offset(13);
    }];
    //录入经服
    UILabel *storeCreator = [[UILabel alloc] init];
    storeCreator.text = @"无";
    storeCreator.textColor = UIColorRBG(68, 68, 68);
    storeCreator.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewFive addSubview:storeCreator];
    _storeCreator = storeCreator;
    [storeCreator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewFive.mas_top).offset(17);
        make.left.equalTo(labelFive.mas_right).offset(9);
        make.height.offset(13);
    }];
    
    UIView *viewSix = [[UIView alloc] initWithFrame:CGRectMake(0, viewFive.fY+viewFive.fHeight+10, _scrollView.fWidth, 142)];
    viewSix.backgroundColor = [UIColor whiteColor];
    _viewSix = viewSix;
    [_scrollView addSubview:viewSix];
    
    UILabel *labelSix = [[UILabel alloc] init];
    labelSix.text = @"公司简介:";
    labelSix.textColor = UIColorRBG(153, 153, 153);
    labelSix.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [viewSix addSubview:labelSix];
    [labelSix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewSix.mas_top).offset(17);
        make.left.equalTo(viewSix.mas_left).offset(15);
        make.height.offset(13);
    }];
    UITextView *remarks = [[UITextView alloc] init];
    remarks.textColor = UIColorRBG(68, 68, 68);//设置textview里面的字体颜色
    remarks.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    remarks.delegate = self;//设置它的委托方法
    _remarks = remarks;
    remarks.editable = NO;
    remarks.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    remarks.returnKeyType = UIReturnKeyDefault;//返回键的类型
    remarks.keyboardType = UIKeyboardTypeDefault;//键盘类型
    remarks.scrollEnabled = YES;//是否可以拖动
    remarks.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [viewSix addSubview: remarks];//加入到页面中
    [remarks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelSix.mas_bottom).offset(15);
        make.left.equalTo(viewSix.mas_left).offset(15);
        make.height.offset(90);
        make.width.offset(viewSix.fWidth-30);
    }];
     _scrollView.contentSize = CGSizeMake(0, viewSix.fY+viewSix.fHeight+10);
}
//选择类型
-(void)selectStoreType{
    NSString *storeType = _storeType.text;
    [BRStringPickerView showStringPickerWithTitle:@"分销类型" dataSource:_storeTypeArray defaultSelValue:storeType resultBlock:^(id selectValue) {
        _storeType.text = selectValue;
    }];
}
//编辑按钮
-(void)edit{
     _scrollView.contentSize = CGSizeMake(0, self.view.fHeight + 135);
     self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(success) title:@"完成"];
    [_storeTypeButton setEnabled:YES];
    [_buttonView setHidden:YES];
    [_projectListView setHidden:YES];
    [_projectView setHidden:YES];
    _companyName.enabled = YES;
    _addrButton.enabled = YES;
    _addr.enabled = YES;
    _totalPeople.enabled = YES;
    _dutyName.enabled = YES;
    _telphone.enabled = YES;
    _remarks.editable = YES;
}
//提交编辑保存数据
-(void)success{
    NSString *storeId = _storeId;
    if ([storeId isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"保存数据失败"];
        return;
    }
    NSString *companyName = _companyName.text;
    if ([companyName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"公司名称不能为空"];
        return;
    }
    NSString *companyCode = _companyCode.text;
    if ([companyCode isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"分销编码不能为空"];
        return;
    }
    NSString *address = _address.text;
    if ([address isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"位置不能为空"];
        return;
    }
    NSString *addr = _addr.text;
    if ([addr isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"地址为空"];
        return;
    }
    NSString *lnglat = _lnglat;
    if ([lnglat isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"位置坐标为空，重新选择位置"];
        return;
    }
    NSString *totalPeople = _totalPeople.text;
    if ([totalPeople isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"人数为空"];
        return;
    }
    NSString *dutyName = _dutyName.text;
    if ([dutyName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"负责人为空"];
        return;
    }
    NSString *telphone = _telphone.text;
    if ([telphone isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"联系电话为空"];
        return;
    }
    NSString *remarks = _remarks.text;

    //分销类型
    NSString *storeType = _storeType.text;
    
    NSString *storeTypes = @"1";
    for (int i = 0; i<_storeTypeArray.count; i++) {
        if ([storeType isEqual:_storeTypeArray[i]]) {
            storeTypes = _valueTypeArray[i];
            break;
        }
    }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
         paraments[@"id"] = storeId;
         paraments[@"companyName"] = companyName;
         paraments[@"storeCode"] = companyCode;
         paraments[@"storeType"] = storeTypes;
         paraments[@"address"] = address;
         paraments[@"addr"] = addr;
         paraments[@"lnglat"] = lnglat;
         paraments[@"totalPeople"] = totalPeople;
         paraments[@"dutyName"] = dutyName;
         paraments[@"dutyName"] = dutyName;
         paraments[@"remarks"] = remarks;
         paraments[@"adCode"] = _adCode;
        NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompany/updateInfo",URL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
               [SVProgressHUD showInfoWithStatus:@"保存成功"];
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(edit) title:@"编辑"];
                [_buttonView setHidden:NO];
                [_storeTypeButton setEnabled:NO];
                _companyName.enabled = NO;
                _addrButton.enabled = NO;
                _addr.enabled = NO;
                _totalPeople.enabled = NO;
                _dutyName.enabled = NO;
                _telphone.enabled = NO;
                _remarks.editable = NO;
                if (_projectList.count!=0) {
                    [_projectView setHidden:NO];
                }
                 _scrollView.contentSize = CGSizeMake(0, _viewSix.fY+_viewSix.fHeight+10);
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
//打电话
-(void)playPhone{
    NSString *phone = _telphone.text;
    
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"号码为空"];
    }
 
}
//选择分销位置
-(void)addrSelect{
    ZDMapController *map = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
    map.addrBlock = ^(NSMutableDictionary *address) {
        _address.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adCode"];
    };
}
//已签约楼盘列表
-(void)projectLiset{
    [self setUpProjectList];
    [_projectView setHidden:YES];
    [_projectListView setHidden:NO];
    
}

//创建已签约楼盘列表
-(void)setUpProjectList{
    UIView *projectListView = [[UIView alloc] initWithFrame:CGRectMake(self.view.fWidth-171, 220, 171, 125)];
    _projectListView = projectListView;
    [projectListView setHidden:YES];
    projectListView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:projectListView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, projectListView.fWidth, projectListView.fHeight)];
    imageView.image = [UIImage imageNamed:@"window_2"];
    [projectListView addSubview:imageView];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(11,10, 160, projectListView.fHeight-15)];
    view.backgroundColor = [UIColor clearColor];
    [projectListView addSubview:view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 59, 5, 8)];
    [button setEnlargeEdgeWithTop:30 right:30 bottom:30 left:5];
    [button setBackgroundImage:[UIImage imageNamed:@"arrowmark"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideProjectLiset) forControlEvents:UIControlEventTouchUpInside];
    [projectListView addSubview:button];
    ZDProjectListView *projectLists = [[ZDProjectListView alloc] init];
    projectLists.frame = view.bounds;
    projectLists.projectArray = [ZDProjectListItem mj_objectArrayWithKeyValuesArray:_projectList];
    [projectLists reloadData];
    [view addSubview:projectLists];
}
//隐藏已签约楼盘列表
-(void)hideProjectLiset{
    [self setKeyEvent];
    [_projectView setHidden:NO];
    [_projectListView setHidden:YES];
}
//签约楼盘
-(void)contractProjects{
    ZDContractProjectController *conProVc = [[ZDContractProjectController alloc] init];
    conProVc.storeId = _storeId;
    conProVc.storeName = _storeName.text;
    conProVc.companyName = _companyName.text;
    conProVc.dutyName = _dutyName.text;
    conProVc.telphone = _telphone.text;
    [self.navigationController pushViewController:conProVc animated:YES];
   }
//关注
-(void)collects{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"distributionCompanyId"] = _storeId;
         NSString *url = [NSString stringWithFormat:@"%@/collectCompany/follow",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSString *data = [responseObject valueForKey:@"data"];
                if ([data isEqual:@"0"]) {
                    [_collect setTitle:@"加关注" forState:UIControlStateNormal];
                }else{
                    [_collect setTitle:@"取消关注" forState:UIControlStateNormal];
                }
                
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
//写跟进
-(void)readFollows{
    ZDReadFollowsController *readF = [[ZDReadFollowsController alloc] init];
    readF.storeId = _storeId;
    [self.navigationController pushViewController:readF animated:YES];
}
//打卡
-(void)punshs{
    ZDStorePunchController *punch = [[ZDStorePunchController alloc] init];
    punch.storeId = _storeId;
    [self.navigationController pushViewController:punch animated:YES];
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_totalPeople == textField) {
        if (toBeString.length>5) {
            return NO;
        }
    }
    if (_telphone == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (toBeString.length>25) {
        return NO;
    }
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_companyName resignFirstResponder];
    [_addr resignFirstResponder];
    [_totalPeople resignFirstResponder];
    [_dutyName resignFirstResponder];
    [_telphone resignFirstResponder];
    [_remarks resignFirstResponder];
}
-(void)setKeyEvent{
    [_companyName resignFirstResponder];
    [_addr resignFirstResponder];
    [_totalPeople resignFirstResponder];
    [_dutyName resignFirstResponder];
    [_telphone resignFirstResponder];
    [_remarks resignFirstResponder];
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
    
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturn"]  target:self action:@selector(backs)];
        
    }
}
-(void)backs{
    
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    
    [pushJudge setObject:@"" forKey:@"push"];
    
    [pushJudge synchronize];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
