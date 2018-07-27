//
//  ZDAddCusController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  新增客户

#import <Masonry.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import "ZDAddCusController.h"

@interface ZDAddCusController ()<UITextFieldDelegate>
//楼盘名称
@property(nonatomic,strong)UILabel *houseName;
//客户姓名
@property(nonatomic,strong)UITextField *customerName;
@end

@implementation ZDAddCusController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.navigationItem.title = @"新增客户";
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    //创建控件
    [self foundControl];
}
#pragma mark -创建控件
-(void)foundControl{
    UIView *viewOne = [[UIView alloc] init];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    [viewOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight+54);
        make.width.offset(self.view.fWidth);
        make.height.offset(91);
    }];
    //楼盘选择
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"楼 盘 名：";
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    titleLabel.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.top.equalTo(viewOne.mas_top).offset(16);
        make.height.offset(14);
    }];
    //楼盘名
    UILabel *houseName = [[UILabel alloc] init];
    houseName.text = @"请选择";
    houseName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    houseName.textColor = UIColorRBG(153, 153, 153);
    _houseName = houseName;
    [viewOne addSubview:houseName];
    [houseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right);
        make.top.equalTo(viewOne.mas_top).offset(16);
        make.height.offset(14);
        make.width.offset(240);
    }];
    //选择图标
    UIImageView *selectImage = [[UIImageView alloc] init];
    selectImage.image = [UIImage imageNamed:@"more_unfold_2"];
    [viewOne addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).offset(-15);
        make.top.equalTo(viewOne.mas_top).offset(14);
        make.height.offset(17);
        make.width.offset(9);
    }];
    //选择按钮
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton addTarget:self action:@selector(selectHouse) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left);
        make.top.equalTo(viewOne.mas_top);
        make.height.offset(45);
        make.width.offset(self.view.fWidth);
    }];
    //华丽的分割线
    UIView *ineOne = [[UIView alloc] init];
    ineOne.backgroundColor  = UIColorRBG(242, 242, 242);
    [viewOne addSubview:ineOne];
    [ineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.top.equalTo(selectButton.mas_bottom);
        make.height.offset(1);
        make.width.offset(self.view.fWidth-15);
    }];
    //客户姓名
    UILabel *cusNameLabel = [[UILabel alloc] init];
    cusNameLabel.text = @"客户姓名：";
    cusNameLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    cusNameLabel.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:cusNameLabel];
    [cusNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.top.equalTo(ineOne.mas_bottom).offset(16);
        make.height.offset(14);
    }];
    //客户姓名
    _customerName = [[UITextField alloc] init];
    _customerName.placeholder = @"必填";
    _customerName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    _customerName.textColor = UIColorRBG(68, 68, 68);
    _customerName.clearButtonMode = UITextFieldViewModeWhileEditing;
    //键盘设置
    _customerName.keyboardType = UIKeyboardTypeDefault;
    _customerName.delegate = self;
    [viewOne addSubview:_customerName];
    [_customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cusNameLabel.mas_right).with.offset(0);
        make.top.equalTo(ineOne.mas_bottom).with.offset(0);
        make.height.mas_offset(45);
        make.width.mas_offset(self.view.fWidth-100);
    }];
    //确认添加按钮
    UIButton *SubButton = [[UIButton alloc] init];
    SubButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [SubButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [SubButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SubButton.backgroundColor = UIColorRBG(3, 133, 219);
    [self.view addSubview:SubButton];
    [SubButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49+JF_BOTTOM_SPACE);
        make.width.mas_offset(self.view.fWidth);
    }];
}
#pragma mark -客户电话
-(void)customerTelphone{
    
}
#pragma mark -选择楼盘
-(void)selectHouse{
    
}
//点击键盘return收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_customerName == textField) {
        if (toBeString.length>15) {
            return NO;
        }
    }
    
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.customerName resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
