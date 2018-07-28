//
//  ZDAddCusController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  新增客户

#import <Masonry.h>
#import "GKCover.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "UIView+Frame.h"
#import "ZDAddCusController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDHouseTableViewController.h"
@interface ZDAddCusController ()<UITextFieldDelegate>
//楼盘名称
@property(nonatomic,strong)UILabel *houseName;
//客户姓名
@property(nonatomic,strong)UITextField *customerName;
//报备号码类型
@property(nonatomic,strong)NSString *realTelFlag;
//ID
@property(nonatomic,strong)NSString *ID;
//号码view
@property(nonatomic,strong)UIView *telphoneView;
//请求参数
@property(nonatomic,strong)NSDictionary *paraments;
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
    //号码
    UIView *telphoneView = [[UIView alloc] init];
    telphoneView.backgroundColor = [UIColor clearColor];
    _telphoneView = telphoneView;
    [self.view addSubview:telphoneView];
    [telphoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(viewOne.mas_bottom).offset(1);
        make.height.mas_offset(183);
        make.width.mas_offset(self.view.fWidth);
    }];
    //确认添加按钮
    UIButton *SubButton = [[UIButton alloc] init];
    SubButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    [SubButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [SubButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SubButton.backgroundColor = UIColorRBG(3, 133, 219);
    [SubButton addTarget:self action:@selector(SubmitCus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SubButton];
    [SubButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49+JF_BOTTOM_SPACE);
        make.width.mas_offset(self.view.fWidth);
    }];
}
#pragma mark -客户电话
-(void)customerTelphone:(UIImage *)image action:(SEL)action num:(NSInteger)n{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, n*46, self.view.fWidth, 45)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = n+100;
    [_telphoneView addSubview:view];
    //客户电话
    UILabel *cusTelphoneLabel = [[UILabel alloc] init];
    cusTelphoneLabel.text = @"客户电话：";
    cusTelphoneLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    cusTelphoneLabel.textColor = UIColorRBG(153, 153, 153);
    [view addSubview:cusTelphoneLabel];
    [cusTelphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(16);
        make.height.offset(14);
    }];
    if([_realTelFlag isEqual:@"0"]){
        //不是实号
        UITextField *top = [[UITextField alloc] init];
        top.placeholder = @"前三位";
        top.delegate = self;
        top.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        top.textAlignment = NSTextAlignmentRight;
        top.textColor = UIColorRBG(68, 68, 68);
        top.tag = 70;
        //键盘设置
        top.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:top];
        [top mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cusTelphoneLabel.mas_right);
            make.top.equalTo(view.mas_top);
            make.height.offset(45);
            make.width.mas_offset(44);
        }];
        UILabel *hideLable = [[UILabel alloc] init];
        hideLable.text = @"****";
        hideLable.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        hideLable.textColor = UIColorRBG(68, 68, 68);
        [view addSubview:hideLable];
        [hideLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(top.mas_right);
            make.top.equalTo(view.mas_top).with.offset(17);
            make.height.mas_offset(15);
        }];
        //添加文本框后部分
        UITextField  *bottom = [[UITextField alloc] init];
        bottom.placeholder = @"后四位";
        bottom.delegate = self;
        bottom.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        bottom.textColor = UIColorRBG(68, 68, 68);
        //键盘设置
        bottom.keyboardType = UIKeyboardTypeNumberPad;
        bottom.tag = 71;
        [view addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hideLable.mas_right);
            make.top.equalTo(view.mas_top);
            make.height.mas_offset(45);
            make.width.mas_offset(44);
        }];
    }else{
        //全号
        UITextField *telphone = [[UITextField alloc] init];
        telphone.placeholder = @"全号";
        telphone.delegate = self;
        telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        telphone.textColor = UIColorRBG(68, 68, 68);
        telphone.tag = 70;
        //键盘设置
        telphone.keyboardType = UIKeyboardTypeNumberPad;
        [view addSubview:telphone];
        [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cusTelphoneLabel.mas_right);
            make.top.equalTo(view.mas_top);
            make.height.offset(45);
            make.width.mas_offset(250);
        }];
    }
    //创建按钮
    UIButton *CleanTelephone = [[UIButton alloc] init];
    [CleanTelephone setEnlargeEdge:44];
    [CleanTelephone setBackgroundImage:image forState:UIControlStateNormal];
    [CleanTelephone addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    CleanTelephone.tag = n+10;
    [view addSubview:CleanTelephone];
    [CleanTelephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).with.offset(-15);
        make.top.equalTo(view.mas_top).with.offset(15);
        make.height.mas_offset(15);
        make.width.mas_offset(15);
    }];
    
}
#pragma mark -选择楼盘
-(void)selectHouse{
    ZDHouseTableViewController *houseTVC = [[ZDHouseTableViewController alloc] init];
    [self.navigationController pushViewController:houseTVC animated:YES];
    houseTVC.HouseBlocks = ^(NSDictionary *data) {
        _houseName.text = [data valueForKey:@"name"];
        _houseName.textColor = UIColorRBG(68, 68, 68);
        _ID = [data valueForKey:@"ID"];
        _realTelFlag = [data valueForKey:@"realTelFlag"];
        //创建第一个电话号码
        [_telphoneView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        __weak typeof (self) weakSelf = self;
        [weakSelf customerTelphone:[UIImage imageNamed:@"add_2"] action:@selector(addTelphone) num:0];
        
    };
}
#pragma mark -增加号码
-(void)addTelphone{
    NSUInteger n = _telphoneView.subviews.count;
    if (n<4) {
        [self customerTelphone:[UIImage imageNamed:@"delete-1"] action:@selector(delTelphone:) num:n];
    }
}
#pragma mark -删除号码
-(void)delTelphone:(UIButton *)button{
    // NSUInteger n = _telphoneView.subviews.count;
    if (button.superview.tag == 101) {
        UIView *view1 = [_telphoneView viewWithTag:102];
        [view1 setTag:101];
        UIView *view2 = [_telphoneView viewWithTag:103];
        [view2 setTag:102];
        view1.fY -= 46;
        view2.fY -=46;
    }else if(button.superview.tag == 102){
        UIView *view = [_telphoneView viewWithTag:103];
        [view setTag:102];
        view.fY -=46;
    }
    [button.superview removeFromSuperview];
}
#pragma mark -提交数据
-(void)SubmitCus{
    //楼盘名
    NSString *name = _houseName.text;
    if ([name isEqual:@"请选择"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择楼盘"];
        return;
    }
    //客户姓名
    NSString *cusName = _customerName.text;
    if ([cusName isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请选择楼盘"];
        return;
    }
    //电话号码
    NSString *missContactOne = @"";
    NSString *missContactTwo = @"";
    NSString *missContactThree = @"";
    NSString *missContactFour = @"";
    
    if([_realTelFlag isEqual:@"0"]){
        //非全号
        //第一个号码
        UITextField *topOne =  [[_telphoneView viewWithTag:100] viewWithTag:70];
        UITextField *botOne =  [[_telphoneView viewWithTag:100] viewWithTag:71];
        if ([topOne.text isEqual:@""]) {
            [SVProgressHUD showInfoWithStatus:@"第一个号码不能为空"];
            return;
        }
        if([botOne.text isEqual:@""]){
            [SVProgressHUD showInfoWithStatus:@"第一个号码不能为空"];
            return;
        }
        missContactOne = [NSString stringWithFormat:@"%@****%@",topOne.text,botOne.text];
        
        //第二个号码
        UITextField *topTwo =  [[_telphoneView viewWithTag:101] viewWithTag:70];
        UITextField *botTwo =  [[_telphoneView viewWithTag:101] viewWithTag:71];
        if(![topTwo.text isEqual:@""]&&![botTwo.text isEqual:@""]){
            missContactTwo = [NSString stringWithFormat:@"%@****%@",topTwo.text,botTwo.text];
        }
        
        //第三个号码
        UITextField *topThree =  [[_telphoneView viewWithTag:102] viewWithTag:70];
        UITextField *botThree =  [[_telphoneView viewWithTag:102] viewWithTag:71];
        if(![topThree.text isEqual:@""]&&![botThree.text isEqual:@""]){
            missContactThree = [NSString stringWithFormat:@"%@****%@",topThree.text,botThree.text];
        }
        //第四个号码
        UITextField *topFour =  [[_telphoneView viewWithTag:103] viewWithTag:70];
        UITextField *botFour =  [[_telphoneView viewWithTag:103] viewWithTag:71];
        if(![topFour.text isEqual:@""]&&![botFour.text isEqual:@""]){
            missContactFour = [NSString stringWithFormat:@"%@****%@",topFour.text,botFour.text];
        }
        
    }else{
        //全号
        //第一个号码
        UITextField *topOne =  [[_telphoneView viewWithTag:100] viewWithTag:70];
        if ([topOne.text isEqual:@""]) {
            [SVProgressHUD showInfoWithStatus:@"第一个号码不能为空"];
            return;
        }
        missContactOne = topOne.text;
        //第二个号码
        UITextField *topTwo =  [[_telphoneView viewWithTag:101] viewWithTag:70];
        if (![topTwo.text isEqual:@""]) {
            missContactTwo = topTwo.text;
        }
        //第三个号码
        UITextField *topThree =  [[_telphoneView viewWithTag:102] viewWithTag:70];
        if (![topThree.text isEqual:@""]) {
            missContactThree = topThree.text;
        }
        //第四个号码
        UITextField *topFour =  [[_telphoneView viewWithTag:103] viewWithTag:70];
        if (![topFour.text isEqual:@""]) {
             missContactFour = topFour.text;
        }
       
    }
    //2.拼接参数
    //创建字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"name"] = cusName;
    dictionary[@"missContacto"] = missContactOne;
    dictionary[@"missContacttw"] = missContactTwo;
    dictionary[@"missContactth"] = missContactThree;
    dictionary[@"missContactf"] = missContactFour;
    NSMutableArray *phoneArrays = [NSMutableArray array];
    [phoneArrays addObject:dictionary];
    
    NSMutableDictionary *order = [NSMutableDictionary dictionary];
    order[@"projectName"] = name;
    order[@"projectId"] = _ID;
    
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"order"] = order;
    paraments[@"list"] = phoneArrays;
    _paraments = paraments;
    NSLog(@"%@",paraments);
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"添加中"];
    
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
}
//发送请求
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/order/fcOrder",URL];
    [mgr POST:url parameters:_paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            [SVProgressHUD showInfoWithStatus:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            if(![code isEqual:@"401"] && ![msg isEqual:@""]){
                [SVProgressHUD showInfoWithStatus:msg];
            }
            
        }
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
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
    NSUInteger n = _telphoneView.subviews.count;
    for (int i = 0; i<n; i++) {
        UIView *view = [_telphoneView viewWithTag:i+100];
        UITextField *text1 = [view viewWithTag:70];
        UITextField *text2 = [view viewWithTag:71];
        if ([_realTelFlag isEqual:@"0"]) {
            if (text1 == textField) {
                if (toBeString.length>3) {
                    [text2 becomeFirstResponder];
                    return NO;
                }
            }
            if (text2 == textField) {
                if (toBeString.length>4) {
                    return NO;
                }
            }
        }else{
            if (text1 == textField) {
                if (toBeString.length>11) {
                    [text2 becomeFirstResponder];
                    return NO;
                }
            }
        }
       
    }
    return YES;
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.customerName resignFirstResponder];
    [self findSubView:_telphoneView];
}
-(void)findSubView:(UIView*)view
{
    for (id object in [view subviews]) {
        if ([object isKindOfClass:[UIView class]]) {
            UIView * view = (UIView *)object;
            [self findSubView:view];
        }
        if ([object isKindOfClass:[UITextField class]]) {
            UITextField * view = (UITextField *)object;
            [view resignFirstResponder];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
