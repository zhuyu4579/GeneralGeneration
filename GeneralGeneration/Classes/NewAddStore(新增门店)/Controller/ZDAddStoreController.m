//
//  ZDAddStoreController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAddStoreController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import <BRPickerView.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDMapController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "GKCover.h"
#import "ZDContractProjectController.h"
#import "NSString+LCExtension.h"
#import "ZDBrokerStoreController.h"
@interface ZDAddStoreController ()<UITextViewDelegate,UITextFieldDelegate>
//文本提示语
@property (nonatomic, retain) UILabel *labels;
//坐标
@property (nonatomic, retain) NSString *lnglat;
//区编码
@property (nonatomic, retain) NSString *adCode;
//跟进数组
@property(nonatomic,strong)NSMutableArray *storeTypeArray;
//跟进数组value
@property(nonatomic,strong)NSMutableArray *valueTypeArray;
//门店ID
@property(nonatomic,strong)NSString *storeId;
@property (strong, nonatomic) IBOutlet UIView *views;
//请求数据
@property(nonatomic,strong)NSString *uuid;

@property(nonatomic,strong)NSDictionary *paraments;

@end

@implementation ZDAddStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"新增门店";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(success) title:@"完成"];
    //读取数据字典
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"dictionaries.plist"];
    NSArray *result = [NSArray arrayWithContentsOfFile:fileName];
    
    NSArray *itemArray;
    for (NSDictionary *obj in result) {
        NSString *code = [obj valueForKey:@"code"];
        //跟进类别
        if ([code isEqual:@"mdlx"]) {
            itemArray = [obj valueForKey:@"dicts"];
        }
    }
    _storeTypeArray = [NSMutableArray array];
    _valueTypeArray = [NSMutableArray array];
    for (NSDictionary *dicty in itemArray) {
        NSString *label = [dicty valueForKey:@"label"];
        NSString *value = [dicty valueForKey:@"value"];
        [_storeTypeArray addObject:label];
        [_valueTypeArray addObject:value];
    }
    _headHeight.constant = kApplicationStatusBarHeight+45;
    //设置文本框属性
    _storeName.keyboardType = UIKeyboardTypeDefault;
     _storeName.delegate = self;
    
    _comptyName.keyboardType = UIKeyboardTypeDefault;
     _comptyName.delegate = self;
    _addr.keyboardType = UIKeyboardTypeDefault;
     _addr.delegate = self;
    _totalPeople.keyboardType = UIKeyboardTypeNumberPad;
     _totalPeople.delegate = self;
    _dutyName.keyboardType = UIKeyboardTypeDefault;
    _dutyName.delegate = self;
    _telphone.keyboardType = UIKeyboardTypeNumberPad;
    _telphone.delegate = self;
    _remarks.keyboardType = UIKeyboardTypeDefault;
    _remarks.delegate = self;
    _remarks.returnKeyType = UIReturnKeyDefault;//返回键的类型
    if (_storeTypeArray.count != 0) {
       _storeType.text = _storeTypeArray[0];
    }else{
        _storeType.text = @"";
    }
    [_addrButton setEnlargeEdgeWithTop:20 right:100 bottom:20 left:100];
    [_selectStoreType setEnlargeEdgeWithTop:20 right:15 bottom:20 left:100];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _remarks.fWidth-30, 13)];
    lable.textColor = UIColorRBG(204, 204, 204);
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = @"输入公司简介";
    _labels = lable;
    [_remarks addSubview:lable];
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_totalPeople == textField) {
        if (toBeString.length>5) {
            return NO;
        }
    }
    if (_telphone == textField) {
        if (toBeString.length>11) {
            return NO;
        }
    }
    if (toBeString.length>25) {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//获取焦点
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.returnKeyType =UIReturnKeyDone;
    UIView *view = textField.superview;
    int offset = view.fY+110 - (self.view.frame.size.height - 300.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.fWidth, self.view.fHeight);
    
    [UIView commitAnimations];
}
//失去焦点
-(void)textFieldDidEndEditing:(UITextField *)textField{
     self.view.frame =CGRectMake(0, 0, self.view.fWidth, self.view.fHeight);
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [_labels setHidden:YES];
     int offset =textView.superview.fY+110 - (self.view.frame.size.height - 300.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.fWidth, self.view.fHeight);
    
    [UIView commitAnimations];
}
//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = _remarks.text;
    if (text.length == 0) {
        [_labels setHidden:NO];
    }
     self.view.frame =CGRectMake(0, 0, self.view.fWidth, self.view.fHeight);
}
//创建成功的弹窗view
-(UIView *)createSuccess{
    //创建弹窗
    UIView *view = [[UIView alloc] init];
    view.fSize = CGSizeMake(263, 300);
    view.backgroundColor = [UIColor clearColor];
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 263, 264)];
    views.backgroundColor =  [UIColor whiteColor];
    [view addSubview:views];
    //142 124
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake((view.fWidth-142)/2.0, 1, 142, 124)];
    iamgeView.image = [UIImage imageNamed:@"win"];
    [view addSubview:iamgeView];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(55, 139, 166, 16);
    label.text = @"恭喜您，新增门店成功!";
    label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    label.textColor = UIColorRBG(68, 68, 68);
    [views addSubview:label];
    UIButton *buttonOne = [[UIButton alloc] initWithFrame:CGRectMake(32, 212, 95, 27)];
    [buttonOne setTitle:@"稍后再说" forState:UIControlStateNormal];
    [buttonOne setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    buttonOne.titleLabel.font = [UIFont systemFontOfSize:13];
    buttonOne.layer.cornerRadius = 13.5;
    buttonOne.layer.masksToBounds = YES;
    buttonOne.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    buttonOne.layer.borderWidth = 1.0;
    [buttonOne addTarget:self action:@selector(Later) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:buttonOne];
    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(149, 212, 95, 27)];
    [buttonTwo setTitle:@"签约项目" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    buttonTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    buttonTwo.layer.cornerRadius = 13.5;
    buttonTwo.layer.masksToBounds = YES;
    buttonTwo.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    buttonTwo.layer.borderWidth = 1.0;
    [buttonTwo addTarget:self action:@selector(store) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:buttonTwo];
    return view;
}
//稍后再说
-(void)Later{
    //返回根部
     [GKCover hide];
    //返回关注门店
    ZDBrokerStoreController *droker = [[ZDBrokerStoreController alloc] init];
    droker.status =1;
    [self.navigationController pushViewController:droker animated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
//签约门店
-(void)store{
    ZDContractProjectController *contract = [[ZDContractProjectController alloc] init];
    contract.storeId = _storeId;
    contract.storeName = _storeName.text;
    contract.companyName = _comptyName.text;
    contract.dutyName = _dutyName.text;
    contract.telphone = _telphone.text;
    [self.navigationController pushViewController:contract animated:YES];
     [GKCover hide];
}
//完成
-(void)success{
    [self setKeyEvent];
    //门店名称
    NSString *name = _storeName.text;
    if([name isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"门店名称不能为空"];
        return;
    }
    //公司名称
     NSString *companyName = _comptyName.text;
    
    //门店位置
    NSString *address = _address.text;
    if([address isEqual:@"请选择"]||!address){
        [SVProgressHUD showInfoWithStatus:@"门店位置不能为空"];
        return;
    }
    //门店地址
    NSString *addr = _addr.text;
    if([addr isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"门店地址不能为空"];
        return;
    }
    //门店人数
    NSString *totalPeople = _totalPeople.text;
    if([totalPeople isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"门店人数不能为空"];
        return;
    }
    //负责人
    NSString *dutyName = _dutyName.text;
    if([dutyName isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"负责人不能为空"];
        return;
    }
    //电话
    NSString *telphone = _telphone.text;
    if([telphone isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
        return;
    }
    //公司简介
    NSString *remarks = _remarks.text;
  
    //门店类型
    NSString *storeType = _storeType.text;
  
    NSString *storeTypes = @"1";
    for (int i = 0; i<_storeTypeArray.count; i++) {
        if ([storeType isEqual:_storeTypeArray[i]]) {
            storeTypes = _valueTypeArray[i];
        }
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    _uuid = uuid;
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"name"] = name;
    paraments[@"companyName"] = companyName;
    paraments[@"address"] = address;
    paraments[@"addr"] = addr;
    paraments[@"totalPeople"] = totalPeople;
    paraments[@"dutyName"] = dutyName;
    paraments[@"telphone"] = telphone;
    paraments[@"remarks"] = remarks;
    paraments[@"storeType"] = storeTypes;
    paraments[@"lnglat"] = _lnglat;
    paraments[@"adCode"] = _adCode;
    _paraments = paraments;
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
}
-(void)loadData{
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:_uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/proDistributionCompany/create",URL];
    [mgr POST:url parameters:_paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if ([code isEqual:@"200"]) {
            NSString *data = [responseObject valueForKey:@"data"];
            _storeId = data;
            UIView *view = [self createSuccess];
            // [GKCover translucentWindowCenterCoverContent:view animated:YES];
            [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
        }else{
            NSString *msg = [responseObject valueForKey:@"msg"];
                if (![msg isEqual:@""]) {
                    [SVProgressHUD showInfoWithStatus:msg];
                }
            [NSString isCode:self.navigationController code:code];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GKCover hide];
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"网络不给力"];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//选择类型
- (IBAction)selectStoreType:(id)sender {
    NSString *storeType = _storeType.text;
    [BRStringPickerView showStringPickerWithTitle:@"门店类型" dataSource:_storeTypeArray defaultSelValue:storeType resultBlock:^(id selectValue) {
        _storeType.text = selectValue;
    }];
}
//选择地址
- (IBAction)selectAddress:(UIButton *)sender {
    ZDMapController *mapVc = [[ZDMapController alloc] init];
    [self.navigationController pushViewController:mapVc animated:YES];
    mapVc.addrBlock = ^(NSMutableDictionary *address) {
        _address.text = [address valueForKey:@"address"];
        _lnglat = [address valueForKey:@"lnglat"];
        _adCode = [address valueForKey:@"adCode"];
    };
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_storeName resignFirstResponder];
    [_comptyName resignFirstResponder];
    [_addr resignFirstResponder];
    [_totalPeople resignFirstResponder];
    [_dutyName resignFirstResponder];
    [_telphone resignFirstResponder];
    [_remarks resignFirstResponder];
}
-(void)setKeyEvent{
    [_storeName resignFirstResponder];
    [_comptyName resignFirstResponder];
    [_addr resignFirstResponder];
    [_totalPeople resignFirstResponder];
    [_dutyName resignFirstResponder];
    [_telphone resignFirstResponder];
    [_remarks resignFirstResponder];
}
@end
