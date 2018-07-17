//
//  ZDFindPWController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDFindPWController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDSetPassWordController.h"
@interface ZDFindPWController ()
//手机号
@property (strong, nonatomic) IBOutlet UITextField *phone;

//下一步
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

//下一步
- (IBAction)nextAction:(UIButton *)sender;

@end

@implementation ZDFindPWController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    //设置按钮的样式
    [self setUpButton];
}
//设置按钮样式
-(void)setUpButton{
    _headHeight.constant = kApplicationStatusBarHeight+85;
    // //设置下一步按钮
    self.nextButton.layer.cornerRadius = 22.0;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.backgroundColor = UIColorRBG(3, 133, 219);
    //设置文本框
    [self setFindFile];
    
    [self.phone becomeFirstResponder];
        
    

}
-(void)setFindFile{
    //设置账户的底线
    self.phone.textColor =  UIColorRBG(68, 68, 68);
    //设置密码框
    [self.phone setSecureTextEntry:YES];
    
    self.phone.keyboardType = UIKeyboardTypeASCIICapable;
    //编辑时显示一键清除键
    self.phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phone resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}



//下一步
- (IBAction)nextAction:(UIButton *)sender {
    //获取手机文本框的手机号码
    NSString  *phone = _phone.text;
    if (!phone) {
        [SVProgressHUD showInfoWithStatus:@"旧密码不能为空"];
        return;
    }
    ZDSetPassWordController *setPW = [[ZDSetPassWordController alloc] init];
    setPW.phone = phone;
    [self.navigationController pushViewController:setPW animated:YES];
}
@end
