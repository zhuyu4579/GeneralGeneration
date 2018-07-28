//
//  ZDLoginController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDLoginController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "UIView+Frame.h"
#import "ZDFindPWController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDHomePageController.h"
#import "ZDNavgationController.h"
#import "JPUSHService.h"
@interface ZDLoginController ()
//登录头像
@property (strong, nonatomic) IBOutlet UIImageView *headImage;

//密码
@property (strong, nonatomic) IBOutlet UITextField *passWord;
//显示密码/隐藏密码
@property (strong, nonatomic) IBOutlet UIButton *showPassWord;

//登录按钮
@property (strong, nonatomic) IBOutlet UIButton *loginButton;


//显示密码
- (IBAction)showPassWord:(UIButton *)sender;
//登录
- (IBAction)login:(UIButton *)sender;

@end

@implementation ZDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置按钮
    [self setUpButton];
    //获取账号
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *username = [ user objectForKey:@"username"];
    _admin.text = username;
}
//设置控件按钮
-(void)setUpButton{
    //设置登录按钮圆角
    self.loginButton.layer.cornerRadius = 22.0;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.backgroundColor = UIColorRBG(3, 133, 219);
    _headHeight.constant = kApplicationStatusBarHeight + 160;
     [self.showPassWord setEnlargeEdge:10];
    //设置文本框
    [self setTextFeildbords];
}
#pragma mark -设置输入框
-(void)setTextFeildbords{

    self.admin.keyboardType = UIKeyboardTypeDefault;
    //编辑时显示一键清除键
    self.admin.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.admin.borderStyle = UITextBorderStyleNone;
    //给文本框绑定事件
    [self.admin addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //给文本框绑定事件
    [self.passWord addTarget:self action:@selector(usernameTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    //键盘设置
    self.passWord.keyboardType = UIKeyboardTypeASCIICapable;
    self.passWord.borderStyle = UITextBorderStyleNone;
    //设置密码框
    [self.passWord setSecureTextEntry:YES];
    //编辑时显示一键清除键
    self.passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}
//文本框值改变事件
-(void)usernameTextFieldChanged:(UITextField *)sender{
    
    NSString *admin =  sender.text;
    NSInteger tag = sender.tag;
    UIButton *btu =(UIButton *) [self.view viewWithTag:(tag+1)];
    [btu setEnlargeEdge:10];
    if (admin.length==1) {
        [btu setHidden:NO];
        btu.enabled = YES;
    }
    if (admin.length == 0) {
        [btu setHidden:YES];
        btu.enabled = NO;
    }
    
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.admin resignFirstResponder];
    [self.passWord resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)showPassWord:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [self.passWord setSecureTextEntry:YES];
    }else{
        [self.passWord setSecureTextEntry:NO];
    }
}
////找回密码
//- (IBAction)findPassWord:(UIButton *)sender {
//    ZDFindPWController *findVC = [[ZDFindPWController alloc] init];
//    findVC.navigationItem.title = @"忘记密码";
//    [self.navigationController pushViewController:findVC animated:YES];
//}
//登录
- (IBAction)login:(UIButton *)sender {
    //判断账户和密码不能为空
    NSString *name = self.admin.text;
    NSString *password = self.passWord.text;
    if (name.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"账号为空"];
        return;
    }
    if (password.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"密码为空"];
        return;
    }
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"username"] = name;
    paraments[@"password"] = password;
    //3.发送请求
    NSString *url = [NSString stringWithFormat:@"%@/app/ga/login.api",URL];
    [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        //解析数据
        int code = [[responseObject valueForKey:@"code"] intValue];
        
        if (code == 200) {
            NSDictionary  *loginItem = [responseObject valueForKey:@"data"];
            [JPUSHService setAlias:[loginItem valueForKey:@"id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                if (iResCode == 0) {
                    NSLog(@"添加别名成功");
                }
            } seq:1];
            if(![loginItem isEqual:@""]){
                //数据持久化
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[loginItem valueForKey:@"uuid"] forKey:@"uuid"];
                [defaults setObject:[loginItem valueForKey:@"username"] forKey:@"username"];
                [defaults setObject:[loginItem valueForKey:@"id"] forKey:@"userId"];
                [defaults setObject:[loginItem valueForKey:@"realname"] forKey:@"realname"];
                [defaults setObject:[loginItem valueForKey:@"deptId"] forKey:@"deptId"];
                [defaults setObject:[loginItem valueForKey:@"deptCode"] forKey:@"deptCode"];
                [defaults setObject:[loginItem valueForKey:@"gaCode"] forKey:@"gaCode"];
                [defaults setObject:[loginItem valueForKey:@"phone"] forKey:@"phone"];
                [defaults synchronize];
                [self preseVc];
            }else{
                 [SVProgressHUD showInfoWithStatus:@"获取数据失败"];
            }
            
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
-(void)preseVc{
    ZDHomePageController *homeVC = [[ZDHomePageController alloc] init];
    ZDNavgationController *nav = [[ZDNavgationController alloc] initWithRootViewController:homeVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}
@end
