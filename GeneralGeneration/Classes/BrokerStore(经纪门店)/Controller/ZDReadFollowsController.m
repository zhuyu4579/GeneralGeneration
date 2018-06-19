//
//  ZDReadFollowsController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  写跟进

#import "ZDReadFollowsController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDFollowTableView.h"
#import "ZDFollowItem.h"
#import "NSString+LCExtension.h"
#import "UIBarButtonItem+Item.h"
#import "ZDFollowsRecordController.h"
@interface ZDReadFollowsController ()<UITextFieldDelegate,UITextViewDelegate>{
    //页数
    NSInteger current;
}
//跟进view
@property (nonatomic, strong) UIView *recordView;
//写跟进
@property (nonatomic, strong) UIView *views;
//文本输入框
@property (nonatomic, strong) UITextView *textView;
//文本提示语
@property (nonatomic, strong) UILabel *labels;
//文本数量
@property (nonatomic, strong) UILabel *labelSum;
//提交按钮
@property (nonatomic, strong) UIButton *button;
//跟进内容数组
@property(nonatomic,strong)NSMutableArray *recordArray;

@property(nonatomic,strong)ZDFollowTableView *follow;
@end
//查询条数
static NSString *size = @"20";

@implementation ZDReadFollowsController
- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"门店跟进";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButtons:self action:@selector(followRecord) title:@"跟进记录"];
    _recordArray = [NSMutableArray array];
    current = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification  object:nil];
    //创建控件
    [self createView];
    //查询数据
    [self loadData];
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
    
    _follow.mj_header = header;
    //创建上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _follow.mj_footer = footer;
}
#pragma mark -下拉刷新或者加载数据
-(void)loadNewTopic:(id)refrech{
    
    [_follow.mj_header beginRefreshing];
    _recordArray = [NSMutableArray array];
    current = 1;
    [self loadData];
}
//上拉刷新
-(void)loadMoreData{
    [_follow.mj_footer beginRefreshing];
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
    paraments[@"distributionCompanyId"] = _storeId;
    paraments[@"pageNumber"] = [NSString stringWithFormat:@"%ld",(long)current];
    paraments[@"pageSize"] = size;
    paraments[@"followTime"] = @"";
    NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompanyFollow/infoList",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"rows"];
            
            if (rows.count == 0) {
                [_follow.mj_footer endRefreshingWithNoMoreData];
            }else{
                for (int i=0; i<rows.count; i++) {
                    [_recordArray addObject:rows[i]];
                }
                current +=1;
                [_follow.mj_footer endRefreshing];
            }
            
            _follow.followArray = [ZDFollowItem mj_objectArrayWithKeyValuesArray:_recordArray];
            [_follow reloadData];
            [_follow.mj_header endRefreshing];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
            [_follow.mj_header endRefreshing];
            [_follow.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        [_follow.mj_header endRefreshing];
        [_follow.mj_footer endRefreshing];
    }];
}

#pragma mark -跟进记录
-(void)followRecord{
    ZDFollowsRecordController *followRecord = [[ZDFollowsRecordController alloc] init];
    followRecord.storeId = _storeId;
    [self.navigationController pushViewController:followRecord animated:YES];
}
#pragma mark -创建控件
-(void)createView{
    UILabel *title = [[UILabel alloc] init];
    title.text = @"像蜜蜂一样勤劳工作才能享受甜蜜生活";
    title.textColor = UIColorRBG(135, 135, 135);
    title.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+70);
        make.height.offset(13);
    }];
    //跟进记录view
    UIView *recordView = [[UIView alloc] init];
    recordView.backgroundColor = [UIColor whiteColor];
    _recordView = recordView;
    [self.view addSubview:recordView];
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(title.mas_bottom).offset(12);
        make.width.offset(self.view.fWidth);
        make.height.offset(self.view.fHeight-kApplicationStatusBarHeight-399);
    }];
    ZDFollowTableView *follow = [[ZDFollowTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-399)];
    _follow = follow;
    [recordView addSubview:follow];
    //输入框
    [self setUpRead];
    //提交按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button = button;
    button.backgroundColor = UIColorRBG(3, 133, 219);
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [button addTarget:self action:@selector(readRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.offset(self.view.fWidth);
        make.height.offset(49+JF_BOTTOM_SPACE);
    }];
}
//设置输入框
-(void)setUpRead{
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fHeight - 304 , self.view.fWidth, 233)];
    views.backgroundColor = [UIColor whiteColor];
    _views = views;
    [self.view addSubview:views];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorRBG(245, 245, 245);
    [views addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(views.mas_left).offset(15);
        make.top.equalTo(views.mas_top).offset(24);
        make.width.offset(self.view.fWidth-30);
        make.height.offset(185);
    }];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth-30, 185)]; //初始化大小并自动释放
    
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:13.0];//设置字体名字和字体大小
    
    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    
    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [view addSubview: self.textView];//加入到页面中
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.textView.fWidth-20, 13)];
    lable.textColor = UIColorRBG(204, 204, 204);
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = @"输入跟进内容";
    _labels = lable;
    [self.textView addSubview:lable];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.textColor = UIColorRBG(204, 204, 204);
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.text = @"0/400";
    _labelSum = lable1;
    [view addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(view.mas_top).offset(162);
        make.height.offset(13);
    }];
    
}
//提交跟进
-(void)readRecord{
    NSString *content = _textView.text;
    if (content.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"跟进内容不能为空"];
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
    paraments[@"distributionCompanyId"] = _storeId;
    paraments[@"content"] = content;
    NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompanyFollow/crateInfo",URL];
    _button.enabled = NO;
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"提交成功"];
            _recordArray = [NSMutableArray array];
            current = 1;
            [self loadData];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (![msg isEqual:@""]) {
                [SVProgressHUD showInfoWithStatus:msg];
            }
            [NSString isCode:self.navigationController code:code];
        }
        _button.enabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        _button.enabled = YES;
    }];
}
//取消键盘
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
     _views.fY = _recordView.fHeight+_recordView.fY;
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [_labels setHidden:YES];
    _views.fY = _recordView.fHeight+_recordView.fY - 209;
}
//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length == 0) {
        [_labels setHidden:NO];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    _labelSum.text = [NSString stringWithFormat:@"%lu/400",(unsigned long)text.length];
    if (text.length == 400) {
        textView.editable = NO;
    }
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   [_textView resignFirstResponder];
}
@end
