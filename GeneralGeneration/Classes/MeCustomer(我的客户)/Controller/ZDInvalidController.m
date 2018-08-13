//
//  ZDInvalidController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDInvalidController.h"
#import "ZDMeCustCell.h"
#import "ZDOrderDetailsController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDMeCustItem.h"
#import "NSString+LCExtension.h"
#import <Masonry.h>
@interface ZDInvalidController ()
{
    //页数
    NSInteger current;
}
//数据数组
@property(nonatomic,strong)NSArray *custormArray;
//数据数组
@property(nonatomic,strong)NSMutableArray *cusListArray;
//刷新到最后没有数据了
@property(nonatomic,strong)MJRefreshBackGifFooter *footer;
//无数据展示
@property(nonatomic,strong)UIView *viewNo;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end
static  NSString * const ID = @"cell";
//查询条数
static NSString *size = @"20";

@implementation ZDInvalidController
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    _isRequestFinish = YES;
    _cusListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
    [self setNoData];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZDMeCustCell" bundle:nil] forCellReuseIdentifier:ID];
    [self headerRefresh];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewTopics) name:@"Refresh" object:nil];
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
    
    self.tableView.mj_header = header;
    
    //创建上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _cusListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
-(void)loadNewTopics{
    
    _cusListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
    
}
//上拉刷新
-(void)loadMoreData{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
//数据请求
-(void)loadData{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
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
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"dealStatus"] = @"4";
        paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
        paraments[@"size"] = size;
         NSString *url = [NSString stringWithFormat:@"%@/order/general/list",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"rows"];
                if (rows.count == 0) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (int i=0; i<rows.count; i++) {
                        [_cusListArray addObject:rows[i]];
                    }
                    
                    current +=1;
                    [self.tableView.mj_footer endRefreshing];
                }
                if (_cusListArray.count == 0 ) {
                    [_viewNo setHidden:NO];
                }else{
                    [_viewNo setHidden:YES];
                }
                _custormArray = [ZDMeCustItem mj_objectArrayWithKeyValuesArray:_cusListArray];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            _isRequestFinish = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            _isRequestFinish = YES;
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
    label.text = @"暂无数据哦！请下拉刷新！！！";
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
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 248;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _custormArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDMeCustCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDMeCustItem *item = _custormArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDMeCustCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *source = cell.source;
    if ([source isEqual:@"1"]) {
        ZDOrderDetailsController *order = [[ZDOrderDetailsController alloc] init];
        order.ID = cell.ID;
        order.statu = cell.statu;
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
@end
