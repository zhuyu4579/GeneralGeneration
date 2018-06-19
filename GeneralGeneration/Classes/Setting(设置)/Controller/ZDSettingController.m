//
//  ZDSettingController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDSettingController.h"
#import "ZDFindPWController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDOpinionController.h"
#import "NSString+LCExtension.h"
@interface ZDSettingController ()
//箭头1，2，3
@property (strong, nonatomic) IBOutlet UIButton *JTOne;
@property (strong, nonatomic) IBOutlet UIButton *JTTwo;
@property (strong, nonatomic) IBOutlet UIButton *JTThree;
//缓存
@property (strong, nonatomic) IBOutlet UILabel *cache;
//退出
@property (strong, nonatomic) IBOutlet UIButton *exit;
//退出提示框
@property (strong, nonatomic) UIAlertAction *okAction;
@property (strong, nonatomic) UIAlertAction *cancelAction;
//修改密码
- (IBAction)modifyPW:(UIButton *)sender;
//清除缓存
- (IBAction)cleanCache:(UIButton *)sender;
//意见反馈
- (IBAction)Opinion:(UIButton *)sender;
//退出登录
- (IBAction)exitLogin:(UIButton *)sender;


@end

@implementation ZDSettingController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    _headHeight.constant = kApplicationStatusBarHeight+54;
    _cache.textColor = UIColorRBG(199, 199, 205);
    [_exit setTitleColor:UIColorRBG(255, 105, 110) forState:UIControlStateNormal];
    [_JTOne setEnlargeEdge:20];
    [_JTTwo setEnlargeEdge:20];
    [_JTThree setEnlargeEdge:20];
    
    _cache.text = [self sizeStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//修改密码
- (IBAction)modifyPW:(UIButton *)sender {
    ZDFindPWController *findPW = [[ZDFindPWController alloc] init];
    findPW.navigationItem.title=@"修改密码";
    [self.navigationController pushViewController:findPW animated:YES];
}
//清除缓存
- (IBAction)cleanCache:(UIButton *)sender {
    //获取文件夹管理者
    NSFileManager *mgr =  [NSFileManager defaultManager];
    //获取cache文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //获取路径
    NSArray *allPath =   [mgr contentsOfDirectoryAtPath:cachePath  error:nil];
    for (NSString *subPath in allPath) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:subPath];
        [mgr removeItemAtPath:filePath error:nil];
    }
    _cache.text = [self sizeStr];
}
//意见反馈
- (IBAction)Opinion:(UIButton *)sender {
    ZDOpinionController *opinion = [[ZDOpinionController alloc] init];
    [self.navigationController pushViewController:opinion animated:YES];
}
//退出登录
- (IBAction)exitLogin:(UIButton *)sender {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确认退出当前账号吗？" preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    _okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        // 1.清除用户名、密码的存储
        
        // 2.跳转到登录界面
        [self eixtLoginData];
    }];
    _cancelAction =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:_okAction];
    [alert addAction:_cancelAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];

}
//退出登录数据请求
-(void)eixtLoginData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;

    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    NSString *url = [NSString stringWithFormat:@"%@/app/logout.api",URL];
    [mgr POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            //清除持久数据
            [SVProgressHUD showInfoWithStatus:@"退出成功"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userDefaults dictionaryRepresentation];
            for (NSString *key in dic) {
                if (![key isEqual:@"username"]) {
                    [userDefaults removeObjectForKey:key];
                }
            }
            [userDefaults synchronize];
            [NSString isCode:self.navigationController code:@"401"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"退出失败"];
            [NSString isCode:self.navigationController code:code];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
//自定义清除缓存
-(NSInteger)getfileSize:(NSString *)DirectoryPath{
   //获取文件夹管理者
    NSFileManager *mgr =  [NSFileManager defaultManager];
    //获取文件夹下所有子路径
     NSArray *subPaths = [mgr subpathsAtPath:DirectoryPath];
     //遍历所有文件计算尺寸
    NSInteger totleSize = 0;
    for (NSString *subPath in subPaths) {
        NSString *filePath = [DirectoryPath stringByAppendingPathComponent:subPath];
        //判断是否是隐藏文件夹
        if ([filePath containsString:@".DS"]) continue;
        //判断是否是文件夹
        BOOL isDirectory;
        BOOL isExist =   [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory)continue;
        NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
        
        NSInteger fileSize =(NSInteger)[attr fileSize];
        
        totleSize +=fileSize;
    }
    return totleSize;
}
-(NSString *)sizeStr{
    //获取cache文件夹路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *str = @"0B";
    NSInteger size = [self getfileSize:cachePath];
    if (size>1000*1000) {
        //MB
        str = [NSString stringWithFormat:@"%.1fMB",size/1000.0/1000.0];
    }else if (size>1000){
        //kb
        str = [NSString stringWithFormat:@"%.1fKB",size/1000.0];
    }else if (size>0){
        //B
        str = [NSString stringWithFormat:@"%zdB",size];
    }
    return str;
}
@end
