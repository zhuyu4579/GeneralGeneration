//
//  ZDHouseTableViewController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDHousesCell.h"
#import "ZDHousesItem.h"
#import "NSString+LCExtension.h"
#import "ZDHouseTableViewController.h"

@interface ZDHouseTableViewController ()
//楼盘数组
@property(nonatomic,strong)NSArray *projectArray;
//无数据展示
@property(nonatomic,strong)UIView *viewNo;

@end
static  NSString * const ID = @"cell";

@implementation ZDHouseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.navigationItem.title = @"选择楼盘";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    //获取列表数据
    [self loadData];
    [self setNoData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZDHousesCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//列表的数据请求
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 10;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
 
    NSString *url = [NSString stringWithFormat:@"%@/userProject/userProjectList",URL];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            if (rows.count == 0 ) {
                [_viewNo setHidden:NO];
            }else{
                [_viewNo setHidden:YES];
            }
            _projectArray = [ZDHousesItem mj_objectArrayWithKeyValuesArray:rows];
            [self.tableView reloadData];
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
    label.text = @"太低调了！一个楼盘也没有哦～";
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _projectArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHousesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDHousesItem *item = _projectArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDHousesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *ID = cell.ID;
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"ID"] = ID;
    dicty[@"name"] = cell.name.text;
    dicty[@"realTelFlag"] = cell.realTelFlag;
    if (_HouseBlocks) {
        _HouseBlocks(dicty);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
