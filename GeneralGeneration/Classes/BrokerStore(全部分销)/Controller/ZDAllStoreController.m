//
//  ZDAllStoreController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAllStoreController.h"
#import "ZDCityItem.h"
#import "ZDCityCell.h"
#import "ZDRightTableView.h"
#import "ZDAreasItem.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import "ZDAllStoreTableView.h"
#import "ZDAllStoreItem.h"
#import "NSString+LCExtension.h"
#import <Masonry.h>
@interface ZDAllStoreController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>{
    //页数
    NSInteger current;
}
//区域label
@property(nonatomic,strong)UILabel *labelOne;
//区域按钮
@property(nonatomic,strong)UIButton *buttonOne;
//列表view
@property(nonatomic,strong)UIView *framView;
//区域数据
@property(nonatomic,strong)NSArray *cityArray;
//左边tableview
@property(nonatomic,strong)UITableView *leftTableView;
//左边tableview
@property(nonatomic,strong)ZDRightTableView *rightTableView;
//默认选择第一个cell
@property(nonatomic,strong)NSIndexPath *indexPath;
//城市编码
@property(nonatomic,strong)NSString *cityId;
//区域编码
@property(nonatomic,strong)NSString *areaId;
//搜索分销名称
@property(nonatomic,strong)NSString *name;
//全部分销
@property(nonatomic,strong)ZDAllStoreTableView *allStore;
//数据数组
@property(nonatomic,strong)NSMutableArray *storeListArray;
//无数据展示
@property(nonatomic,strong)UIView *viewNo;
//数据请求是否完毕
@property (nonatomic, assign) BOOL isRequestFinish;

@end
static  NSString * const ID = @"cell";
//查询条数
static NSString *size = @"20";
@implementation ZDAllStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    [self setNoData];
    _isRequestFinish = YES;
    _storeListArray = [NSMutableArray array];
    current = 1;
    //区域数据的获取
    [self searchData];
    //搜索栏
    [self findView];
    
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
    
    _allStore.mj_header = header;
    //创建上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _allStore.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [_allStore.mj_header beginRefreshing];
    _storeListArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//上拉刷新
-(void)loadMoreData{
    [_allStore.mj_footer beginRefreshing];
    [self loadData];
}
//列表的数据请求
-(void)loadData{
    if (!_isRequestFinish) {
        return;
    }
    _isRequestFinish = NO;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
        NSString *location = [ user objectForKey:@"lnglat"];
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"cityId"] = _cityId;
        paraments[@"areaId"] = _areaId;
        paraments[@"name"] = _name;
        paraments[@"collect"] = @"";
        paraments[@"current"] = [NSString stringWithFormat:@"%ld",(long)current];
        paraments[@"size"] = size;
        paraments[@"location"] = location;
        NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompany/serverCompany/list",URL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"rows"];
                
                if (rows.count == 0) {
                   [_allStore.mj_footer endRefreshingWithNoMoreData];
                }else{
                    for (int i=0; i<rows.count; i++) {
                        [_storeListArray addObject:rows[i]];
                    }
                    current +=1;
                    [_allStore.mj_footer endRefreshing];
                    
                }
                if (_storeListArray.count == 0 ) {
                    [_viewNo setHidden:NO];
                }else{
                    [_viewNo setHidden:YES];
                }
                _allStore.storeArray = [ZDAllStoreItem mj_objectArrayWithKeyValuesArray:_storeListArray];
                [_allStore reloadData];
                [_allStore.mj_header endRefreshing];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                
                [NSString isCode:self.navigationController code:code];
                [_allStore.mj_header endRefreshing];
                [_allStore.mj_footer endRefreshing];
            }
            _isRequestFinish = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            [_allStore.mj_header endRefreshing];
            [_allStore.mj_footer endRefreshing];
            _isRequestFinish = YES;
        }];
    
}

//创建无图表
-(void)setNoData{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 45, self.view.fWidth, self.view.fHeight -45);
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
    label.text = @"太低调了！一个分销也没有哦，\n\n赶快去新增吧～";
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
//搜索框
-(void)findView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    //创建区域
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 16, 27, 13);
    label.text = @"区域";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    label.textColor =UIColorRBG(102, 102, 102);
    _labelOne = label;
    [view addSubview:label];
    //创建按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(54, 20, 10, 6)];
    _buttonOne = button;
    [button setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"arrows"] forState:UIControlStateSelected];
    [button setEnlargeEdgeWithTop:20 right:29 bottom:20 left:54];
    [button  addTarget:self action:@selector(regionSelect) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    //创建线
    UIView *ine = [[UIView alloc]initWithFrame:CGRectMake(93, 6, 1,view.fHeight-12)];
    ine.backgroundColor = UIColorRBG(238, 238, 238);
    [view addSubview:ine];
    //创建搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(94, 0, view.fWidth-94, view.fHeight)];
    searchBar.placeholder = @"请搜索公司、分销名称";
    searchBar.barTintColor = [UIColor whiteColor];
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.returnKeyType = UIReturnKeyDone;
    searchBar.delegate = self;
    UITextField *searchField1 = [searchBar valueForKey:@"_searchField"];
    [searchField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    searchField1.backgroundColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor blackColor];
    [view addSubview:searchBar];
    [self.view addSubview:view];
    //创建列表
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.view.fWidth, self.view.fHeight-JF_BOTTOM_SPACE-89-kApplicationStatusBarHeight)];
    proView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:proView];
    ZDAllStoreTableView *allStore = [[ZDAllStoreTableView alloc] initWithFrame:proView.bounds];
    _allStore = allStore;
    [proView addSubview:allStore];
    
    //创建弹框
    UIView *framView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, self.view.fWidth, self.view.fHeight - 46)];
    [self.view addSubview:framView];
    [framView setHidden:YES];
    _framView = framView;
    [self getUpCover];
}
//区域选择
-(void)regionSelect{
    [_framView setHidden:NO];
    _buttonOne.selected = YES;
    _labelOne.textColor = UIColorRBG(3, 133, 219);
    [_leftTableView selectRowAtIndexPath:_indexPath animated:NO  scrollPosition:UITableViewScrollPositionTop];
    [self tableView:_leftTableView didSelectRowAtIndexPath:_indexPath];
    
}
//创建遮罩
-(void)getUpCover{
    //创建遮罩
    UIView *cover = [[UIView alloc] init];
    cover.frame = _framView.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)]];
    cover.userInteractionEnabled = YES;
    // 添加遮罩
    [_framView addSubview:cover];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _framView.fWidth, 200)];
    view.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:view];
   
    UIView *cleanView = [[UIView alloc] initWithFrame:CGRectMake(0, view.fHeight+view.fY, _framView.fWidth, 40)];
    cleanView.backgroundColor = [UIColor whiteColor];
    [_framView addSubview:cleanView];
    
    UIView *ineview = [[UIView alloc] initWithFrame:CGRectMake(15, 0,cleanView.fWidth-15, 1)];
    ineview.backgroundColor = UIColorRBG(243, 243, 243);
    [cleanView addSubview:ineview];
    
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake((cleanView.fWidth-100)/2.0,7 , 100, 25)];
    [cleanButton setTitle:@"清空" forState:UIControlStateNormal];
    [cleanButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    cleanButton.titleLabel.font = [UIFont systemFontOfSize:13];
    cleanButton.layer.cornerRadius = 12.5;
    cleanButton.layer.borderWidth = 1.0;
    cleanButton.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [cleanButton addTarget:self action:@selector(cleanSelect) forControlEvents:UIControlEventTouchUpInside];
    [cleanView addSubview:cleanButton];
    
    //创建左边的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 115, view.fHeight)];
    leftView.backgroundColor = [UIColor clearColor];
    [view addSubview:leftView];
    //创建左边的tableView
    UITableView *leftTableView = [[UITableView alloc] init];
    leftTableView.frame = leftView.bounds;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.showsVerticalScrollIndicator = NO;
    leftTableView.showsHorizontalScrollIndicator = NO;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView = leftTableView;
    //注册cell
    [leftTableView registerNib:[UINib nibWithNibName:@"ZDCityCell" bundle:nil] forCellReuseIdentifier:ID];
    [leftView addSubview:leftTableView];
    //创建右边的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(115, 0, view.fWidth-115, view.fHeight)];
    rightView.backgroundColor = UIColorRBG(242, 242, 242);
    [view addSubview:rightView];
    ZDRightTableView *rightTB = [[ZDRightTableView alloc] init];
    rightTB.frame = rightView.bounds;
    _rightTableView = rightTB;
    [rightView addSubview:rightTB];
    rightTB.cityBlock = ^(NSDictionary *citys) {
        _areaId = [citys valueForKey:@"areaId"];
        _labelOne.text = [citys valueForKey:@"name"];
        [self hideView];
        _storeListArray = [NSMutableArray array];
        current = 1;
        [self loadData];
    };
}
//清空城市选择
-(void)cleanSelect{
    [_framView setHidden:YES];
    _buttonOne.selected = NO;
    [_buttonOne setBackgroundImage:[UIImage imageNamed:@"arrows_2"] forState:UIControlStateNormal];
    _labelOne.textColor = UIColorRBG(102, 102, 102);
    _labelOne.text = @"区域";
    _cityId = @"";
    _areaId = @"";
    [self loadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cityArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _indexPath = indexPath;
    }
    ZDCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDCityItem *item = _cityArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDCityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _indexPath = indexPath;
    _cityId = cell.cityId;
    cell.cityName.textColor = UIColorRBG(3, 133, 219);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.selectedBackgroundView.backgroundColor = UIColorRBG(245, 245, 245);
    NSArray *areas = cell.areas;
    NSMutableArray *area = [NSMutableArray array];
    for (NSDictionary *dictys in areas) {
        NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
        NSString *areasName = [dictys valueForKey:@"areaName"];
        dicty[@"areaName"] = areasName;
        dicty[@"areaid"] = [dictys valueForKey:@"areaId"];
        if ([_labelOne.text isEqual: areasName]) {
            dicty[@"flag"] = @"1";
        }else{
            dicty[@"flag"] = @"0";
        }
        [area addObject:dicty];
    }
    
    _rightTableView.areas = [ZDAreasItem mj_objectArrayWithKeyValuesArray:area];
    [_rightTableView reloadData];
}
//点击遮罩事件
-(void)hideView{
    [_framView setHidden:YES];
    _buttonOne.selected = NO;
    _labelOne.textColor = UIColorRBG(3, 133, 219);
    [_buttonOne setBackgroundImage:[UIImage imageNamed:@"arrows_3"] forState:UIControlStateNormal];
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
//文本框改变时
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _name = searchText;
    current = 1;
    _storeListArray = [NSMutableArray array];
    [self loadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    
//    NSString *projectName = searchBar.text;
//    _name = projectName;
//    current = 1;
//    _storeListArray = [NSMutableArray array];
//    [self loadData];
}
//点击取消
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    // 如果希望在点击取消按钮调用结束编辑方法需要让加上这句代码
    [searchBar resignFirstResponder];
    NSString *projectName = searchBar.text;
    if (!projectName||[projectName isEqual:@""]) {
        _name = projectName;
        current = 1;
        _storeListArray = [NSMutableArray array];
        [self loadData];
    }
   
}

//请求数据 获取区域名称
-(void)searchData{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 60;
        //防止返回值为null
        ((AFJSONResponseSerializer *)mgr.responseSerializer).removesKeysWithNullValues = YES;
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
         NSString *url = [NSString stringWithFormat:@"%@/serverCity/cityList",URL];
        [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"rows"];
                _cityArray = [ZDCityItem mj_objectArrayWithKeyValuesArray:rows];
                [_leftTableView reloadData];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"请求区域列表超时"];
        }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}


@end
