//
//  ZDSelectProjectController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDSelectProjectController.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+Item.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDCityItem.h"
#import "ZDCityCell.h"
#import "ZDRightTableView.h"
#import "ZDAreasItem.h"
#import "ZDSureProjectsTableView.h"
#import "ZDProjectItem.h"
#import "NSString+LCExtension.h"
#import <Masonry.h>
@interface ZDSelectProjectController ()
//项目数组
@property(nonatomic,strong)NSArray *projectArray;
//项目列表
@property(nonatomic,weak)ZDSureProjectsTableView *projects;
//无数据展示
@property(nonatomic,strong)UIView *viewNo;
@end
static  NSString * const ID = @"cell";
@implementation ZDSelectProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    //获取列表数据
    [self loadData];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"选择项目";
    //创建列表
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-45-JF_BOTTOM_SPACE)];
    proView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:proView];
    ZDSureProjectsTableView *pro = [[ZDSureProjectsTableView alloc] initWithFrame:proView.bounds];
    _projects = pro;
    [proView addSubview:pro];
     [self setNoData];
    
    if (_projectBlocks) {
        _projects.projectBlock = ^(NSDictionary *projectDicty) {
            _projectBlocks(projectDicty);
        };
    }
}
//列表的数据请求
-(void)loadData{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 40;
        //申明返回的结果是json类型
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        //申明请求的数据是json类型
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"distributionCompanyId"] = _storeId;
    
        NSString *url = [NSString stringWithFormat:@"%@/projectCompany/signList",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"rows"];
                if (rows.count == 0 ) {
                    [_viewNo setHidden:NO];
                }else{
                    [_viewNo setHidden:YES];
                }
                _projectArray = [ZDProjectItem mj_objectArrayWithKeyValuesArray:rows];
                _projects.projectArray = _projectArray;
                [_projects reloadData];
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
//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = self.view.bounds;
    [view setHidden:YES];
    _viewNo = view;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"empty"];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(view.mas_top).offset(kApplicationStatusBarHeight+44+103);
        make.width.offset(129);
        make.height.offset(86);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"太低调了！一个项目也没有哦～";
    label.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    label.textColor = UIColorRBG(158, 158, 158);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(29);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
