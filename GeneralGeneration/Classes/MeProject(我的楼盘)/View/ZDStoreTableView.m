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
    return 84;
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
    UIViewController *VC = [UIViewController viewController:self.superview];
    ZDStoreCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *storeId = cell.storeId;
    NSString *signStatus = cell.signStatus;
    if ([signStatus isEqual:@"2"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"不能签约分销" message:[NSString stringWithFormat:@"分销已被经服%@签约，签约有效期：%@至%@，有效期结束后你可签约",cell.dutyName,cell.defaultSignStartTime,cell.signEndTime]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        [alert addAction:cancelAction];
        [VC presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSString *projectType = cell.protectType;
    if ([projectType isEqual:@"1"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"不能签约分销" message:[NSString stringWithFormat:@"分销在经服%@的录入保护期，保护期内只能录入经服签约，保护期结束后你可约",cell.storeCreatorName]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                              }];
        [alert addAction:cancelAction];
        [VC presentViewController:alert animated:YES completion:nil];
        return;
    }
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"storeId"] = storeId;
    dicty[@"storeName"] = cell.storeName.text;
    dicty[@"defaultSignStartTime"] = cell.defaultSignStartTime;
    [self loadDate:storeId dicty:dicty];
    
}
//请求分销信息
-(void)loadDate:(NSString *)storeId dicty:(NSMutableDictionary *)dicty{
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
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
