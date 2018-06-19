//
//  ZDStoreTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDStoreTableView.h"
#import "ZDStoreCell.h"
#import "ZDStoreItem.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIViewController+WZFindController.h"
@interface ZDStoreTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableDictionary *storeDicy;
@end
static  NSString * const ID = @"cells";
@implementation ZDStoreTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDStoreCell" bundle:nil] forCellReuseIdentifier:ID];
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storeArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDStoreItem *item = _storeArray[indexPath.row];
    cell.item = item;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDStoreCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *storeId = cell.storeId;
    
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"storeId"] = storeId;
    dicty[@"storeName"] = cell.storeName.text;
    dicty[@"defaultSignStartTime"] = cell.defaultSignStartTime;
    [self loadDate:storeId dicty:dicty];
    
}
//请求门店信息
-(void)loadDate:(NSString *)storeId dicty:(NSMutableDictionary *)dicty{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    if (uuid) {
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = storeId;
        NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompany/info",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSString *dutyName = [data valueForKey:@"dutyName"];
                NSString *telphone = [data valueForKey:@"telphone"];
                dicty[@"dutyName"] = dutyName;
                dicty[@"telphone"] = telphone;
                dicty[@"companyName"] = [data valueForKey:@"companyName"];
                if (_storeBlock) {
                    _storeBlock(dicty);
                }
                UIViewController *VC = [UIViewController viewController:self.superview];
                [VC.navigationController popViewControllerAnimated:YES];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
@end
