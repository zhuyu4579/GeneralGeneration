//
//  ZDSetPassWordController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDSetPassWordController.h"
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
@interface ZDSetPassWordController ()
//第一次密码
@property (strong, nonatomic) IBOutlet UITextField *passWordOne;
//第二次密码
@property (strong, nonatomic) IBOutlet UITextField *passWordTwo;
//显示密码
@property (strong, nonatomic) IBOutlet UIButton *showPassWord;
//提交按钮
@property (strong, nonatomic) IBOutlet UIButton *comfileButton;

- (IBAction)showPWAction:(UIButton *)sender;
- (IBAction)comfireAction:(UIButton *)sender;

@end

@implementation ZDSetPassWordController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
    self.navigationItem.title = @"设置密码";
    //设置按钮
    //设置按钮
    [self setUpButton];
}
//设置控件按钮
-(void)setUpButton{
    //设置登录按钮圆角
    self.comfileButton.layer.cornerRadius = 22.0;
    self.comfileButton.layer.masksToBounds = YES;
    self.comfileButton.backgroundColor = UIColorRBG(3, 133, 219);
    
    [self.showPassWord setEnlargeEdge:10];
    //设置文本框
    [self setTextFeildbords];
}
#pragma mark -设置输入框
-(void)setTextFeildbords{
  
    self.passWordOne.keyboardType = UIKeyboardTypeASCIICapable;
    //编辑时显示一键清除键
    self.passWordOne.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passWordOne becomeFirstResponder];
    //设置密码框
    [self.passWordOne setSecureTextEntry:YES];
    //键盘设置
    self.passWordTwo.keyboardType = UIKeyboardTypeASCIICapable;
    //设置密码框
    [self.passWordTwo setSecureTextEntry:YES];
    //编辑时显示一键清除键
    self.passWordTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passWordOne resignFirstResponder];
    [self.passWordTwo resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)showPWAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.passWordOne setSecureTextEntry:YES];
         [self.passWordTwo setSecureTextEntry:YES];
    }else{
        [self.passWordOne setSecureTextEntry:NO];
        [self.passWordTwo setSecureTextEntry:NO];
    }
}

- (IBAction)comfireAction:(UIButton *)sender {
    //获取第一个密码
    NSString *passwordOne = _passWordOne.text;
    if ([passwordOne isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    if (passwordOne.length<6 ||passwordOne.length>16) {
         [SVProgressHUD showInfoWithStatus:@"密码格式不正确"];
        return;
    }
    //获取第二个密码
    NSString *passwordTwo = _passWordTwo.text;
    if ([passwordTwo isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }
    if (passwordTwo.length<6 ||passwordTwo.length>16) {
        [SVProgressHUD showInfoWithStatus:@"密码格式不正确"];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 30;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"password"] = passwordOne;
    paraments[@"phone"] = _phone;
    NSString *url = [NSString stringWithFormat:@"%@/sysUser/ga/changePassword",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        
        if ([code isEqual:@"200"]) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userDefaults dictionaryRepresentation];
            for (NSString *key in dic) {
                [userDefaults removeObjectForKey:key];
            }
            [userDefaults synchronize];
            //返回登录页面
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
}
@end
