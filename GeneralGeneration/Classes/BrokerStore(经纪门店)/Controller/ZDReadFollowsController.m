//
//  ZDReadFollowsController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  写跟进

#import "ZDReadFollowsController.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "ZDFollowTableView.h"
#import "ZDFollowItem.h"
#import <BRPickerView.h>
#import "NSString+LCExtension.h"
@interface ZDReadFollowsController ()<UITextFieldDelegate>
//门店名称
@property(nonatomic,strong)UILabel *storeName;
//门店地址
@property(nonatomic,strong)UILabel *address;
//负责人姓名
@property(nonatomic,strong)UILabel *dutyName;
//负责人联系电话
@property(nonatomic,strong)UILabel *telphone;
//跟进类型
@property(nonatomic,strong)UILabel *followType;
//跟进时间
@property(nonatomic,strong)UILabel *followTime;
//创建跟进类容
@property(nonatomic,strong)UITextField *followContent;
//发送内容的view
@property(nonatomic ,strong)UIView *viewThree;
@property(nonatomic ,strong)UIView *viewFour;
//跟进消息列表
@property(nonatomic,strong)ZDFollowTableView *tableView;
//跟进数组
@property(nonatomic,strong)NSMutableArray *followArray;
//跟进数组value
@property(nonatomic,strong)NSMutableArray *valueArray;
@end

@implementation ZDReadFollowsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"门店跟进";
    //读取数据字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictionaries.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    NSArray *itemArray;
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //跟进类别
        if ([code isEqual:@"gjlb"]) {
           itemArray = [obj valueForKey:@"dicts"];
        }
    }
    _followArray = [NSMutableArray array];
    _valueArray = [NSMutableArray array];
    for (NSDictionary *dicty in itemArray) {
        NSString *label = [dicty valueForKey:@"label"];
        NSString *value = [dicty valueForKey:@"value"];
        [_followArray addObject:label];
        [_valueArray addObject:value];
    }
    //创建view
    [self createCV];
    //请求数据
    [self loadData];
}
//请求数据
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"distributionCompanyId"] = _storeId;
        NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompanyFollow/infoList",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                _storeName.text = [data valueForKey:@"name"];
                _address.text = [data valueForKey:@"addr"];
                _dutyName.text = [data valueForKey:@"dutyName"];
                _telphone.text = [data valueForKey:@"telphone"];
                NSArray *followArray = [data valueForKey:@"distributioncompanyfollow"];
                _tableView.followArray = [ZDFollowItem mj_objectArrayWithKeyValuesArray:followArray];
                [_tableView reloadData];
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
//创建控件
-(void)createCV{
    //创建view
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, kApplicationStatusBarHeight+45, self.view.fWidth, 134)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewOne];
    //门店名称
    UILabel *storeName = [[UILabel alloc] init];
    _storeName = storeName;
    storeName.text = @"无";
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    storeName.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:storeName];
    [storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(viewOne.mas_top).offset(20);
        make.height.offset(15);
    }];
    //门店地址
    UILabel *address = [[UILabel alloc] init];
    _address = address;
    address.text = @"无";
    address.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    address.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:address];
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(viewOne.mas_centerX);
        make.top.equalTo(storeName.mas_bottom).offset(16);
        make.height.offset(13);
    }];
    //负责人
    UILabel *duty = [[UILabel alloc] init];
    duty.text = @"负 责 人：";
    duty.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    duty.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:duty];
    [duty mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewOne.mas_left).offset(15);
        make.top.equalTo(address.mas_bottom).offset(40);
        make.height.offset(13);
    }];
    //负责人姓名
    UILabel *dutyName = [[UILabel alloc] init];
    dutyName.text = @"无";
    _dutyName = dutyName;
    dutyName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    dutyName.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:dutyName];
    [dutyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(duty.mas_right).offset(0);
        make.top.equalTo(address.mas_bottom).offset(40);
        make.height.offset(13);
    }];
    //打电话
    UIButton *playPhone = [[UIButton alloc] init];
    [playPhone setBackgroundImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
    [playPhone setEnlargeEdge:20];
    [playPhone addTarget:self action:@selector(palyPhone) forControlEvents:UIControlEventTouchUpInside];
    [viewOne addSubview:playPhone];
    [playPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewOne.mas_right).offset(-15);
        make.top.equalTo(address.mas_bottom).offset(34);
        make.height.offset(23);
        make.width.offset(16);
    }];
    //负责人电话
    UILabel *telphone = [[UILabel alloc] init];
    _telphone = telphone;
    telphone.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    telphone.textColor = UIColorRBG(3, 133, 219);
    [viewOne addSubview:telphone];
    [telphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(playPhone.mas_left).offset(-24);
        make.top.equalTo(address.mas_bottom).offset(40);
        make.height.offset(13);
    }];
    
    UIView *viewTwo = [[UIView alloc] initWithFrame:CGRectMake(0, viewOne.fY+144, self.view.fWidth, 91)];
    viewTwo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTwo];
    //跟进类型
    UILabel *follow = [[UILabel alloc] init];
    follow.text = @"跟进类型：";
    follow.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    follow.textColor = UIColorRBG(153, 153, 153);
    [viewTwo addSubview:follow];
    [follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(viewTwo.mas_top).offset(17);
        make.height.offset(13);
    }];
   //跟进类型
    UILabel *followType = [[UILabel alloc] init];
    if (_followArray.count !=0) {
         followType.text = _followArray[0];
    }else{
        followType.text = @"";
    }
   
    _followType = followType;
    followType.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    followType.textColor = UIColorRBG(68, 68, 68);
    [viewTwo addSubview:followType];
    [followType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(follow.mas_right).offset(0);
        make.top.equalTo(viewTwo.mas_top).offset(16);
        make.height.offset(14);
    }];
    //选择类型
    UIButton *selectType = [[UIButton alloc] init];
    [selectType setBackgroundImage:[UIImage imageNamed:@"more_unfold_2"] forState:UIControlStateNormal];
    [selectType setEnlargeEdgeWithTop:10 right:10 bottom:10 left:100];
    [selectType  addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:selectType];
    [selectType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.top.equalTo(viewTwo.mas_top).offset(14);
        make.height.offset(17);
        make.width.offset(9);
    }];
    UIView *ine = [[UIView alloc] initWithFrame:CGRectMake(15, 45, self.view.fWidth-15, 1)];
    ine.backgroundColor = UIColorRBG(242, 242, 242);
    [viewTwo addSubview:ine];
    
    //跟进类型
    UILabel *followT = [[UILabel alloc] init];
    followT.text = @"跟进时间：";
    followT.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    followT.textColor = UIColorRBG(153, 153, 153);
    [viewTwo addSubview:followT];
    [followT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTwo.mas_left).offset(15);
        make.top.equalTo(ine.mas_bottom).offset(17);
        make.height.offset(13);
    }];
    //跟进类型
    UILabel *followTime = [[UILabel alloc] init];
    followTime.text = @"请选择";
    _followTime = followTime;
    followTime.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    followTime.textColor = UIColorRBG(68, 68, 68);
    [viewTwo addSubview:followTime];
    [followTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(follow.mas_right).offset(0);
        make.top.equalTo(ine.mas_bottom).offset(16);
        make.height.offset(14);
    }];
    //选择类型
    UIButton *selectTime = [[UIButton alloc] init];
    [selectTime setBackgroundImage:[UIImage imageNamed:@"more_unfold_2"] forState:UIControlStateNormal];
    [selectTime setEnlargeEdgeWithTop:10 right:10 bottom:10 left:100];
    [selectTime  addTarget:self action:@selector(selectTime) forControlEvents:UIControlEventTouchUpInside];
    [viewTwo addSubview:selectTime];
    [selectTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewTwo.mas_right).offset(-15);
        make.top.equalTo(ine.mas_bottom).offset(14);
        make.height.offset(17);
        make.width.offset(9);
    }];
    
    UIView *viewThree = [[UIView alloc] initWithFrame:CGRectMake(0, viewTwo.fY+101, self.view.fWidth, self.view.fHeight-370)];
    _viewThree = viewThree;
    viewThree.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewThree];
    ZDFollowTableView *tableView = [[ZDFollowTableView alloc] init];
    tableView.frame = viewThree.bounds;
    _tableView = tableView;
    [viewThree addSubview:tableView];
    
    UIView *viewFour = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fHeight-49-JF_BOTTOM_SPACE, self.view.fWidth,49+JF_BOTTOM_SPACE)];
    viewFour.backgroundColor = [UIColor whiteColor];
    _viewFour = viewFour;
    [self.view addSubview:viewFour];
    //发送
    UIButton *send = [[UIButton alloc] init];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    send.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    [send setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    send.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
    send.backgroundColor = UIColorRBG(249, 249, 249);
    send.layer.borderWidth = 1.0;
    send.layer.cornerRadius = 5.0;
    [send  addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [viewFour addSubview:send];
    [send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewFour.mas_right).offset(-15);
        make.top.equalTo(viewFour.mas_top).offset(7);
        make.height.offset(35);
        make.width.offset(58);
    }];
    UITextField *followContent = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, viewFour.fWidth-90, 35)];
    //编辑时显示一键清除键
    followContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    _followContent = followContent;
    //再次编辑内容清除
    followContent.clearsOnBeginEditing = YES;
    followContent.keyboardType = UIKeyboardTypeDefault;
    followContent.placeholder = @"请输入跟进内容";
    followContent.textColor = UIColorRBG(68, 68, 68);
    followContent.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    followContent.backgroundColor = UIColorRBG(249, 249, 249);
    followContent.layer.borderWidth = 1.0;
    followContent.layer.cornerRadius = 5.0;
    followContent.layer.masksToBounds = YES;
    followContent.delegate = self;
    followContent.layer.borderColor = UIColorRBG(204, 204, 204).CGColor;
    [viewFour addSubview:followContent];
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    followContent.leftView = leftView;
    followContent.leftViewMode = UITextFieldViewModeAlways;
    followContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}
//获得焦点
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _viewFour.fY -= 256+49;
    _viewThree.fHeight -=256+49;
    _tableView.fHeight -=256+49;
    return YES;
}
//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _viewFour.fY += 256+49;
    _viewThree.fHeight +=256+49;
    _tableView.fHeight +=256+49;
}
//选择跟进类型
-(void)selectType{
    NSString *type = _followType.text;
    [BRStringPickerView showStringPickerWithTitle:@"跟进类型" dataSource:_followArray defaultSelValue:type resultBlock:^(id selectValue) {
        _followType.text = selectValue;
    }];
}
//选择跟进时间
-(void)selectTime{
    [BRDatePickerView showDatePickerWithTitle:@"跟进时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        _followTime.text = selectValue;
    }];
}
//打电话
-(void)palyPhone{
    NSString *phone = _telphone.text;
    if (![phone isEqual:@""]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:@"号码为空"];
    }
 
}
//发送
-(void)send:(UIButton *)button{
  
    NSString *content = _followContent.text;
    if ([content isEqual:@""]) {
        [SVProgressHUD showInfoWithStatus:@"跟进内容不能为空"];
        return;
    }
    NSString *followTime = _followTime.text;
    if([followTime isEqual:@"请选择"]){
        [SVProgressHUD showInfoWithStatus:@"跟进时间不能为空"];
        return;
    }
    NSString *followType = _followType.text;
    NSString *followTypes = @"1";
    for (int i = 0; i<_followArray.count; i++) {
        if ([followType isEqual:_followArray[i]]) {
            followTypes = _valueArray[i];
        }
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    button.enabled = NO;
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"distributionCompanyId"] = _storeId;
        paraments[@"content"] = content;
        paraments[@"followTime"] = followTime;
        paraments[@"followType"] = followTypes;
        NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompanyFollow/crateInfo",URL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            
            if ([code isEqual:@"200"]) {
                [self loadData];
                [_followContent resignFirstResponder];
            }else{
                NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
                [NSString isCode:self.navigationController code:code];
            }
            button.enabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            button.enabled = YES;
        }];
        
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_followContent resignFirstResponder];
}


@end
