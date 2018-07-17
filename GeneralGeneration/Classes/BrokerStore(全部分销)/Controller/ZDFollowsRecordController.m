//
//  ZDFollowsRecordController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/14.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDFollowsRecordController.h"
#import "NSString+LCExtension.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDFollowItem.h"
#import "ZDFollowCell.h"
#import <BRDatePickerView.h>
static  NSString * const ID = @"cells";
@interface ZDFollowsRecordController (){
    //页数
    NSInteger current;
}
//跟进内容数组
@property(nonatomic,strong)NSMutableArray *recordArray;
//数据模型数组
@property(nonatomic,strong)NSArray *followArray;
//数据模型数组
@property(nonatomic,strong)NSString *dateTime;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;
@end
//查询条数
static NSString *size = @"20";

@implementation ZDFollowsRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"跟进记录";
    NSDate *date=[NSDate date];
    NSDateFormatter *format1=[[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr=[format1 stringFromDate:date];
    _dateTime = dateStr;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtonImage:[UIImage imageNamed:@"more_unfold_2-1"] target:self action:@selector(selectDate) title:dateStr];
    _isRequestFinish = YES;
    _recordArray = [NSMutableArray array];
    current = 1;
    [self loadData];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZDFollowCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //下拉刷新
    [self headerRefresh];
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
    footer.mj_h = JF_BOTTOM_SPACE + 20;
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [self.tableView.mj_header beginRefreshing];
    _recordArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//上拉刷新
-(void)loadMoreData{
    [self.tableView.mj_footer beginRefreshing];
    [self loadData];
}
//查询当天的跟进记录
-(void)loadData{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
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
    paraments[@"distributionCompanyId"] = _storeId;
    paraments[@"pageNumber"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"pageSize"] = size;
    paraments[@"followTime"] = _dateTime;
    NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompanyFollow/infoList",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            if (rows.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_recordArray addObject:rows[i]];
                }
                current +=1;
                [self.tableView.mj_footer endRefreshing];
            }
            _followArray = [ZDFollowItem mj_objectArrayWithKeyValuesArray:_recordArray];
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
//选择时间
-(void)selectDate{
    [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
         self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtonImage:[UIImage imageNamed:@"more_unfold_2-1"] target:self action:@selector(selectDate) title:selectValue];
        _dateTime = selectValue;
        _recordArray = [NSMutableArray array];
        current = 1;
        [self loadData];
    }];
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _followArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [cell.ineOne setHidden:NO];
    [cell.ineTwo setHidden:NO];
    if(_followArray.count == 1){
        [cell.ineOne setHidden:YES];
        [cell.ineTwo setHidden:YES];
    }else{
        if (indexPath.row == 0) {
            [cell.ineOne setHidden:YES];
            [cell.ineTwo setHidden:NO];
        }
        if (indexPath.row == (_followArray.count-1)) {
            [cell.ineOne setHidden:NO];
            [cell.ineTwo setHidden:YES];
        }
    }
    
    ZDFollowItem *item = _followArray[indexPath.row];
    cell.item = item;
    return cell;
}

@end
