//
//  ZDScaveResultController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  扫码结果

#import "ZDScaveResultController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
@interface ZDScaveResultController ()<UITextFieldDelegate>
//客户姓名
@property(nonatomic,strong)UITextField *customerName;
//客
@property(nonatomic,strong)UITextField *phone;
//客
@property(nonatomic,strong)UIView *viewThree;
//1
@property(nonatomic,strong)UIView *fullContactoView;
//2
@property(nonatomic,strong)UIView *fullContacttwView;
//3
@property(nonatomic,strong)UIView *fullContactthView;
//4
@property(nonatomic,strong)UIView *fullContactfView;
//上客按钮
@property(nonatomic,strong)UIButton *guestButton;
@end

@implementation ZDScaveResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"订单资料";
    //创建控件
    [self createVc];
}
//创建控件
-(void)createVc{
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0,kApplicationStatusBarHeight+44                                                                                                 , self.view.fWidth, 65)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    //楼盘名称
    UILabel *projectName = [[UILabel alloc] initWithFrame:CGRectMake(15, 24, viewOne.fWidth-30, 17)];
    projectName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    projectName.textColor = UIColorRBG(68, 68, 68);
    projectName.text = [_resultArray valueForKey:@"projectName"];
    projectName.textAlignment = NSTextAlignmentCenter;
    [viewOne addSubview:projectName];
    
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, viewOne.fHeight+viewOne.fY+10, self.view.fWidth, 91)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTwo];
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.text = @"完善客户资料";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    labelTwo.textColor = UIColorRBG(68, 68, 68);
    [viewTwo addSubview:labelTwo];
    [labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTwo.mas_top).offset(16);
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.height.offset(15);
    }];
    UILabel *labelTwos = [[UILabel alloc] init];
    labelTwos.text = @"(点击修改)";
    labelTwos.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    labelTwos.textColor = UIColorRBG(153, 153, 153);
    [viewTwo addSubview:labelTwos];
    [labelTwos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewTwo.mas_top).offset(17);
        make.left.equalTo(labelTwo.mas_right).offset(10);
        make.height.offset(14);
    }];
    
    UIView *ineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, viewTwo.fWidth, 1)];
    ineView.backgroundColor = UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ineView];
    
    UILabel *cusNamelabel = [[UILabel alloc] init];
    cusNamelabel.text = @"客户姓名：";
    cusNamelabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    cusNamelabel.textColor = UIColorRBG(153, 153, 153);
    [viewTwo addSubview:cusNamelabel];
    [cusNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineView.mas_bottom).offset(16);
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.height.offset(13);
    }];
    UITextField *customerName = [[UITextField alloc] init];
    customerName.placeholder = @"请填写姓名";
    customerName.keyboardType = UIKeyboardTypeDefault;
    customerName.text = [_resultArray valueForKey:@"name"];
    //编辑时显示一键清除键
    customerName.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    customerName.textColor = UIColorRBG(68, 68, 68);
    
    customerName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _customerName = customerName;
    [viewTwo addSubview:customerName];
    [customerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ineView.mas_bottom).offset(0);
        make.left.equalTo(cusNamelabel.mas_right).offset(0);
        make.height.offset(45);
        make.width.offset(250);
    }];
    
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+viewTwo.fHeight+1, self.view.fWidth, 181)];
    viewThree.backgroundColor = [UIColor clearColor];
    _viewThree = viewThree;
    [self.view addSubview:viewThree];
    
    UIButton *guest = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.fHeight-49, self.view.fWidth, 49)];
    [guest setTitle:@"上客" forState:UIControlStateNormal];
    [guest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [guest setBackgroundColor:UIColorRBG(3, 133, 219)];
    guest.enabled = YES;
    guest.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    _guestButton = guest;
    [guest addTarget:self action:@selector(guest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guest];
    NSString *fullContacto = [_resultArray valueForKey:@"fullContacto"];
    if (fullContacto.length == 11) {
        UIView *fullOne = [self boardTelphone:CGRectMake(0, 0, viewThree.fWidth, 45) view:viewThree telphone:fullContacto];
        _fullContactoView = fullOne;
        [viewThree addSubview:fullOne];
        NSString *str2 = [fullContacto substringFromIndex:3];
        NSString *str3 = [str2 substringToIndex:4];
        NSString *real = [_resultArray valueForKey:@"real"];
        if ([real isEqual:@"1"] && [str3 isEqual:@"****"]) {
            [guest setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [guest setBackgroundColor:UIColorRBG(204, 204, 204)];
            guest.enabled = NO;
            UITextField *phonez = [_fullContactoView viewWithTag:20];
            [phonez addTarget:self action:@selector(phoneTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    NSString *fullContacttw = [_resultArray valueForKey:@"fullContacttw"];
    if (fullContacttw.length == 11) {
        UIView *fullTwo = [self boardTelphone:CGRectMake(0, 46, viewThree.fWidth, 45) view:viewThree telphone:fullContacttw];
        _fullContacttwView = fullTwo;
        [viewThree addSubview:fullTwo];
    }
    NSString *fullContactth = [_resultArray valueForKey:@"fullContactth"];
    if (fullContactth.length == 11) {
        UIView *fullThree = [self boardTelphone:CGRectMake(0, 92, viewThree.fWidth, 45) view:viewThree telphone:fullContactth];
        _fullContactthView = fullThree;
        [viewThree addSubview:fullThree];
    }
    NSString *fullContactf = [_resultArray valueForKey:@"fullContactf"];
    if (fullContactf.length == 11) {
        UIView *fullFour = [self boardTelphone:CGRectMake(0, 138, viewThree.fWidth, 45) view:viewThree telphone:fullContactf];
        _fullContactfView = fullFour;
        [viewThree addSubview:fullFour];
    }
    
}
//创建电话号码
-(UIView *)boardTelphone:(CGRect)rect view:(UIView *)view telphone:(NSString *)phone{
    
    UIView *pview = [[UIView alloc] initWithFrame:rect];
    pview.backgroundColor = [UIColor whiteColor];
    UILabel *boardLabel = [[UILabel alloc] init];
    boardLabel.text = @"报备电话：";
    boardLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    boardLabel.textColor = UIColorRBG(153, 153, 153);
    [pview addSubview:boardLabel];
    [boardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pview.mas_top).offset(16);
        make.left.equalTo(pview.mas_left).offset(15);
        make.height.offset(13);
    }];
    NSString *str1 = [phone substringToIndex:3];
    NSString *str2 = [phone substringFromIndex:3];
    UILabel *phoneOne = [[UILabel alloc] init];
    phoneOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    phoneOne.textColor = UIColorRBG(3, 133, 219);
    phoneOne.tag = 10;
    phoneOne.text = str1;
    [pview addSubview:phoneOne];
    [phoneOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pview.mas_top).offset(15);
        make.left.equalTo(boardLabel.mas_right).offset(0);
        make.height.offset(14);
    }];
    UITextField *phoneTwo = [[UITextField alloc] init];
    phoneTwo.placeholder = @"中间四位";
    phoneTwo.keyboardType = UIKeyboardTypeNumberPad;
    phoneTwo.textAlignment = NSTextAlignmentCenter;
    phoneTwo.tag = 20;
    phoneTwo.delegate = self;
    [phoneTwo addTarget:self action:@selector(phoneTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    NSString *str3 = [str2 substringToIndex:4];
    if (![str3 isEqual:@"****"]) {
        phoneTwo.text = str3;
    }
    phoneTwo.textColor = UIColorRBG(3, 133, 219);

    phoneTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [pview addSubview:phoneTwo];
    [phoneTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pview.mas_top).offset(0);
        make.left.equalTo(phoneOne.mas_right).offset(0);
        make.height.offset(45);
        make.width.offset(60);
    }];
    UILabel *phoneThree = [[UILabel alloc] init];
    phoneThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    phoneThree.textColor = UIColorRBG(3, 133, 219);
    phoneThree.tag = 30;
    phoneThree.text = [str2 substringFromIndex:4];
    [pview addSubview:phoneThree];
    [phoneThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pview.mas_top).offset(15);
        make.left.equalTo(phoneTwo.mas_right).offset(0);
        make.height.offset(14);
    }];
    return pview;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 4) {
         return NO;
    }
     return YES; 
}
//中间文本框改变
-(void)phoneTextFieldChanged:(UITextField *)textfield{
    NSString *str = textfield.text;
    if (str.length == 4) {
        [_guestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_guestButton setBackgroundColor:UIColorRBG(3, 133, 219)];
        _guestButton.enabled = YES;
    }else{
        [_guestButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_guestButton setBackgroundColor:UIColorRBG(204, 204, 204)];
        _guestButton.enabled = NO;
    }
   
}
//上客
-(void)guest{
    
    //客户姓名
    NSString *name = _customerName.text;
    if ([name isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"客户姓名不能为空"];
        return;
    }
    //第一个号码
     UITextField *phoneOneTop = [_fullContactoView viewWithTag:10];
     UITextField *phoneOneZ = [_fullContactoView viewWithTag:20];
     UITextField *phoneOneBottom = [_fullContactoView viewWithTag:30];
    if (phoneOneZ.text.length !=4) {
        phoneOneZ.text = @"****";
    }
     NSString *fullContacto = [NSString stringWithFormat:@"%@%@%@",phoneOneTop.text,phoneOneZ.text,phoneOneBottom.text];
    //第2个号码
    UITextField *phoneTwoTop = [_fullContacttwView viewWithTag:10];
    UITextField *phoneTwoZ = [_fullContacttwView viewWithTag:20];
    NSString *phone2 = phoneTwoZ.text;
    if([phone2 isEqual:@""]){
       phone2 = @"****";
    }
    UITextField *phoneTwoBottom = [_fullContacttwView viewWithTag:30];
    NSString *fullContacttw = [NSString stringWithFormat:@"%@%@%@",phoneTwoTop.text,phone2,phoneTwoBottom.text];
    //第3个号码
    UITextField *phoneThreeTop = [_fullContactthView viewWithTag:10];
    UITextField *phoneThreeZ = [_fullContactthView viewWithTag:20];
    NSString *phone3 = phoneThreeZ.text;
    if([phone3 isEqual:@""]){
        phone3 = @"****";
    }
    UITextField *phoneThreeBottom = [_fullContactthView viewWithTag:30];
    NSString *fullContactth = [NSString stringWithFormat:@"%@%@%@",phoneThreeTop.text,phone3,phoneThreeBottom.text];
    //第4个号码
    UITextField *phoneFourTop = [_fullContactfView viewWithTag:10];
    UITextField *phoneFourZ = [_fullContactfView viewWithTag:20];
    NSString *phone4 = phoneFourZ.text;
    if([phone4 isEqual:@""]){
        phone4 = @"****";
    }
    UITextField *phoneFourBottom = [_fullContactfView viewWithTag:30];
    NSString *fullContactf = [NSString stringWithFormat:@"%@%@%@",phoneFourTop.text,phone4,phoneFourBottom.text];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
    
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
        paraments[@"orderId"] = [_resultArray valueForKey:@"orderId"];
        paraments[@"codeContent"] = [_resultArray valueForKey:@"codeContent"];
        paraments[@"name"] = name;
        paraments[@"fullContacto"] = fullContacto;
        paraments[@"fullContacttw"] = fullContacttw;
        paraments[@"fullContactth"] = fullContactth;
        paraments[@"fullContactf"] = fullContactf;
        NSString *url = [NSString stringWithFormat:@"%@/order/boading",URL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                [SVProgressHUD showInfoWithStatus:@"扫码上客成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }];
        
    
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_customerName resignFirstResponder];
    UITextField *text = [_fullContactoView viewWithTag:20];
    [text resignFirstResponder];
    UITextField *text2 = [_fullContacttwView viewWithTag:20];
    [text2 resignFirstResponder];
    UITextField *text3 = [_fullContactthView viewWithTag:20];
    [text3 resignFirstResponder];
    UITextField *text4 = [_fullContactfView viewWithTag:20];
    [text4 resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
