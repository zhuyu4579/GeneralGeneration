//
//  ZDFindCustomerController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//
#import <Masonry.h>
#import "UIView+Frame.h"
#import "ZDMeCustCell.h"
#import "ZDMeCustItem.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
#import "ZDOrderDetailsController.h"
#import "ZDFindCustomerController.h"

static  NSString * const ID = @"cell";
@interface ZDFindCustomerController ()<UISearchBarDelegate>{
    //页数
    NSInteger current;
}
@property (strong, nonatomic) UISearchBar *searchBar;
//搜索内容
@property(nonatomic,strong)NSString *name;
//数据数组
@property(nonatomic,strong)NSMutableArray *custormArray;
//数据数组
@property(nonatomic,strong)NSMutableArray *cusListArray;
//刷新到最后没有数据了
@property(nonatomic,strong)MJRefreshBackGifFooter *footer;
//无数据展示
@property(nonatomic,strong)UIView *viewNo;

@end
//查询条数
static NSString *size = @"20";

@implementation ZDFindCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.hidesBackButton = YES;
    //创建搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-20, 45)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, searchView.fWidth, 44)];
    searchBar.placeholder = @"请搜索楼盘、客户名称、电话";
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.returnKeyType = UIReturnKeySearch;
    searchBar.delegate = self;
    _searchBar = searchBar;
    
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    [searchField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    searchField1.backgroundColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor blackColor];
    
    [searchView addSubview:searchBar];
    
    self.navigationItem.titleView = searchView;
    self.tableView.backgroundColor = UIColorRBG(242, 242, 242);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZDMeCustCell" bundle:nil] forCellReuseIdentifier:ID];
    
    [self headerRefresh];
    [self setNoData];
    
}
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
     [self performSelector:@selector(setCorrectFocus) withObject:NULL afterDelay:0.5];
}
-(void) setCorrectFocus {
    [self.searchBar becomeFirstResponder];
}
//开始输入
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    
    // 如果希望在点击搜索按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    _name = searchBar.text;
    _cusListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    //如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    self.tableView.mj_header = header;
    
    //创建上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic{
    [self.tableView.mj_header beginRefreshing];
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
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"dealStatus"] = @"";
    paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"size"] = size;
    paraments[@"name"] = _name;
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
    label.text = @"小的无能，找不到你想要的结果";
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    ZDOrderDetailsController *order = [[ZDOrderDetailsController alloc] init];
    order.ID = cell.ID;
    order.statu = cell.statu;
    [self.navigationController pushViewController:order animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
