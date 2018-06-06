//
//  ZDAllStoreTableView.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAllStoreTableView.h"
#import "ZDAllStoreCell.h"
#import "UIViewController+WZFindController.h"
#import "ZDStoreDetailsController.h"
#import "UIViewController+WZFindController.h"
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "ZDContractProjectController.h"
#import "ZDReadFollowsController.h"
#import "NSString+LCExtension.h"
static  NSString * const ID = @"cells";
@interface ZDAllStoreTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ZDAllStoreTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //tableView的代理
        self.delegate = self;
        self.dataSource = self;
    }
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"ZDAllStoreCell" bundle:nil] forCellReuseIdentifier:ID];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _storeArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDAllStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    ZDAllStoreItem *item = _storeArray[indexPath.row];
    cell.item = item;
    //签约项目
    [cell.contractProject addTarget:self action:@selector(contractProject:) forControlEvents:UIControlEventTouchUpInside];
    //关注
    [cell.collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    //写关注
    [cell.readFollow addTarget:self action:@selector(readFollow:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
//签约项目
-(void)contractProject:(UIButton *)button{
    CGPoint point = button.center;
    point = [self convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self indexPathForRowAtPoint:point];
    ZDAllStoreCell *cell = [self cellForRowAtIndexPath:indexpath];
    ZDContractProjectController *conProVc = [[ZDContractProjectController alloc] init];
    conProVc.storeId = cell.storeId;
    conProVc.storeName = cell.storeName.text;
    conProVc.companyName = cell.companyName;
    conProVc.dutyName  = cell.dutyName;
    conProVc.telphone = cell.telphone;
    UIViewController *vc = [UIViewController viewController:self.superview];
    UIViewController *Vc = [UIViewController viewController:vc.view.superview];
    [Vc.navigationController pushViewController:conProVc animated:YES];
}
//关注
-(void)collect:(UIButton *)button{
    CGPoint point = button.center;
    point = [self convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self indexPathForRowAtPoint:point];
    ZDAllStoreCell *cell = [self cellForRowAtIndexPath:indexpath];
   
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"distributionCompanyId"] = cell.storeId;
        NSString *url = [NSString stringWithFormat:@"%@/collectCompany/follow",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSString *data = [responseObject valueForKey:@"data"];
                if ([data isEqual:@"0"]) {
                    [cell.collect setTitle:@"加关注" forState:UIControlStateNormal];
                }else{
                    [cell.collect setTitle:@"取消关注" forState:UIControlStateNormal];
                }
                if (_collectBolck) {
                    _collectBolck(cell.storeId);
                }
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
}
//写跟进
-(void)readFollow:(UIButton *)button{
    CGPoint point = button.center;
    point = [self convertPoint:point fromView:button.superview];
    NSIndexPath *indexpath = [self indexPathForRowAtPoint:point];
    ZDAllStoreCell *cell = [self cellForRowAtIndexPath:indexpath];
    ZDReadFollowsController *readF = [[ZDReadFollowsController alloc] init];
    readF.storeId = cell.storeId;
    UIViewController *vc = [UIViewController viewController:self.superview];
    UIViewController *Vc = [UIViewController viewController:vc.view.superview];
    [Vc.navigationController pushViewController:readF animated:YES];
}
//点击cell跳转详情页
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDAllStoreCell *cell = [self cellForRowAtIndexPath:indexPath];
    ZDStoreDetailsController *detail = [[ZDStoreDetailsController alloc] init];
    detail.storeId = cell.storeId;
    UIViewController *vc = [UIViewController viewController:self.superview];
     UIViewController *Vc = [UIViewController viewController:vc.view.superview];
    [Vc.navigationController pushViewController:detail animated:YES];
}
@end
