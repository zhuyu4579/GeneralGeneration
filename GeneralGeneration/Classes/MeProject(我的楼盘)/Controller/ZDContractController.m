//
//  ZDContractController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDContractController.h"
#import "UIView+Frame.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "ZDSelectStoreController.h"
#import <BRDatePickerView.h>
#import "GKCover.h"
#import "ZDAlertView.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
@interface ZDContractController ()<UITextFieldDelegate>
//分销名称
@property(nonatomic,strong)UILabel *storeName;
//公司全称
@property(nonatomic,strong)UITextField *companyName;
//负责人
@property(nonatomic,strong)UITextField *changeName;
//联系电话
@property(nonatomic,strong)UITextField *phone;
//分销Id
@property(nonatomic,strong)NSString *storeId;
//图片数组
@property(nonatomic,strong)UIImage *oldImage;
//合同照片的view
@property(nonatomic,strong)UIView *imageViews;
//提示图标
@property(nonatomic,strong)UIImageView *image;
//提示文本
@property(nonatomic,strong)UILabel *label;
//下滑框
@property(nonatomic,strong)UIScrollView *scrollView;
//合同开始时间
@property(nonatomic,strong)UIButton *startTime;
//合同结束时间
@property(nonatomic,strong)UIButton *endTime;
//参数
@property(nonatomic,strong)NSDictionary *paraments;
@end

@implementation ZDContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMaximumDismissTimeInterval:2.0f];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"签约分销";
    //创建控件
    [self createController];
}
//创建控件
-(void)createController{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    UIView *viewOne = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.fWidth, 45)];
    viewOne.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:viewOne];
    _scrollView = scrollView;
    //1view
    UILabel *labelOne = [[UILabel alloc] init];
    labelOne.frame = CGRectMake(15,17,60,13);
    labelOne.text = @"公司简称:";
    labelOne.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelOne.textColor = UIColorRBG(153, 153, 153);
    [viewOne addSubview:labelOne];
    UILabel *storeName = [[UILabel alloc] init];
    storeName.frame = CGRectMake(84,17,260,13);
    storeName.text = @"请选择";
    _storeName = storeName;
    storeName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    storeName.textColor = UIColorRBG(68, 68, 68);
    [viewOne addSubview:storeName];
    UIButton *storeSelect = [[UIButton alloc] initWithFrame:CGRectMake(viewOne.fWidth-24, 15, 9, 17)];
    [storeSelect setBackgroundImage:[UIImage imageNamed:@"more_unfold_2"] forState:UIControlStateNormal];
    [storeSelect addTarget:self action:@selector(storeSelect) forControlEvents:UIControlEventTouchUpInside];
    [storeSelect setEnlargeEdge:15];
    [viewOne addSubview:storeSelect];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0,viewOne.fY+46, self.view.fWidth, 45)];
    view2.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view2];
    //2
    UILabel *labelTwo = [[UILabel alloc] init];
    labelTwo.frame = CGRectMake(15,17,60,13);
    labelTwo.text = @"公司全称:";
    labelTwo.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelTwo.textColor = UIColorRBG(153, 153, 153);
    [view2 addSubview:labelTwo];
    UITextField *companyName = [[UITextField alloc] initWithFrame:CGRectMake(84, 0, view2.fWidth-84, 45)];
    companyName.placeholder = @"无";
    companyName.delegate = self;
    companyName.textColor = UIColorRBG(153, 153, 153);
    [companyName setFont:[UIFont systemFontOfSize:14]];
    _companyName = companyName;
     companyName.keyboardType = UIKeyboardTypeDefault;
    [view2 addSubview:companyName];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.fY+56, self.view.fWidth, 45)];
    view3.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view3];
    //3
    UILabel *labelTHree = [[UILabel alloc] init];
    labelTHree.frame = CGRectMake(15,17,60,13);
    labelTHree.text = @"负 责 人:";
    labelTHree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelTHree.textColor = UIColorRBG(153, 153, 153);
    [view3 addSubview:labelTHree];
    UITextField *changeName = [[UITextField alloc] initWithFrame:CGRectMake(84, 0, view3.fWidth-84, 45)];
    changeName.placeholder = @"无";
    changeName.delegate = self;
    changeName.textColor = UIColorRBG(153, 153, 153);
    [changeName setFont:[UIFont systemFontOfSize:14]];
    _changeName = changeName;
    changeName.keyboardType = UIKeyboardTypeDefault;
    [view3 addSubview:changeName];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, view3.fY+46, self.view.fWidth, 45)];
    view4.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view4];
    //4
    UILabel *labelFour = [[UILabel alloc] init];
    labelFour.frame = CGRectMake(15,17,60,13);
    labelFour.text = @"联系电话:";
    labelFour.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelFour.textColor = UIColorRBG(153, 153, 153);
    [view4 addSubview:labelFour];
    UITextField *phone = [[UITextField alloc] initWithFrame:CGRectMake(84, 0, view4.fWidth-84, 45)];
    phone.placeholder = @"无";
    phone.delegate = self;
    phone.textColor = UIColorRBG(153, 153, 153);
    [phone setFont:[UIFont systemFontOfSize:14]];
    _phone = phone;
    phone.keyboardType = UIKeyboardTypeDefault;
    [view4 addSubview:phone];
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(0, view4.fY+56, self.view.fWidth, 45)];
    view5.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view5];
    //5
    UILabel *labelFever = [[UILabel alloc] init];
    labelFever.frame = CGRectMake(15,17,60,13);
    labelFever.text = @"楼盘名称:";
    labelFever.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelFever.textColor = UIColorRBG(153, 153, 153);
    [view5 addSubview:labelFever];
    UILabel *projectName = [[UILabel alloc] init];
    projectName.frame = CGRectMake(84,16, view5.fWidth-84,14);
    projectName.text = _projectName;
    projectName.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    projectName.textColor = UIColorRBG(68, 68, 68);
    [view5 addSubview:projectName];
    
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, view5.fY+56, self.view.fWidth, 45)];
    view6.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view6];
    //6
    UILabel *labelSix = [[UILabel alloc] init];
    labelSix.frame = CGRectMake(15,17,75,13);
    labelSix.text = @"合同有效期:";
    labelSix.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelSix.textColor = UIColorRBG(153, 153, 153);
    [view6 addSubview:labelSix];
    UIButton *dateOne = [[UIButton alloc] initWithFrame:CGRectMake(88, 0, 113, view6.fHeight)];
    [dateOne setTitle:@"开始日期" forState:UIControlStateNormal];
    [dateOne setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    [dateOne setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateSelected];
    _startTime = dateOne;
    dateOne.titleLabel.font = [UIFont systemFontOfSize:13];
    [dateOne addTarget:self action:@selector(beginDate:) forControlEvents:UIControlEventTouchUpInside];
    [view6 addSubview:dateOne];
    UILabel *DateZ = [[UILabel alloc] init];
    DateZ.frame = CGRectMake(201,16,14,14);
    DateZ.text = @"至";
    DateZ.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    DateZ.textColor = UIColorRBG(68, 68, 68);
    [view6 addSubview:DateZ];
    UIButton *dateTwo = [[UIButton alloc] initWithFrame:CGRectMake(215, 0, 113, view6.fHeight)];
    [dateTwo setTitle:@"结束日期" forState:UIControlStateNormal];
    [dateTwo setTitleColor:UIColorRBG(153, 153, 153) forState:UIControlStateNormal];
    [dateTwo setTitleColor:UIColorRBG(68, 68, 68) forState:UIControlStateSelected];
    _endTime = dateTwo;
    dateTwo.titleLabel.font = [UIFont systemFontOfSize:13];
    [dateTwo addTarget:self action:@selector(endDate:) forControlEvents:UIControlEventTouchUpInside];
    [view6 addSubview:dateTwo];
    
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(0, view6.fY+56, self.view.fWidth, 153)];
    view7.backgroundColor = [UIColor whiteColor];
    _imageViews = view7;
    [scrollView addSubview:view7];
    //7
    UILabel *labelSeven = [[UILabel alloc] init];
    labelSeven.frame = CGRectMake(15,20,60,13);
    labelSeven.text = @"上传合同";
    labelSeven.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    labelSeven.textColor = UIColorRBG(153, 153, 153);
    [view7 addSubview:labelSeven];
    
    [self createImageViews:CGRectMake(0, 38,( view7.fWidth/3.0), 105) tags:10];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, view7.fY+163, 6, 12)];
    imageView.image = [UIImage imageNamed:@"hint"];
    _image = imageView;
    [scrollView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, view7.fY+163, self.view.fWidth-26, 12)];
    label.text = @"审核通过后，在【已签约分销】里显示，否则，不显示";
    _label = label;
    label.font = [UIFont fontWithName:@"PingFang-SC-Light" size:12];
    label.textColor = UIColorRBG(153, 153, 153);
    [scrollView addSubview:label];
    scrollView.contentSize = CGSizeMake(0, self.view.fHeight);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.fHeight-49-JF_BOTTOM_SPACE, self.view.fWidth, 49+JF_BOTTOM_SPACE)];
    button.backgroundColor = UIColorRBG(3, 133, 219);
    [button setTitle:@"提交审核" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
//创建imageView的所有按钮
-(void)createImageViews:(CGRect)rect tags:(NSInteger)tag{
        UIView *view = [[UIView alloc] init];
        view.frame = rect;
        UIButton *imageViews = [[UIButton alloc] initWithFrame:CGRectMake((view.fWidth-85)/2.0,10, 85, 85)];
        imageViews.tag = tag;
        [imageViews setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [imageViews addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imageViews];
        _oldImage =  imageViews.currentBackgroundImage;
        [_imageViews addSubview:view];
        //创建删除按钮
    UIButton *cleanButton = [[UIButton alloc] initWithFrame:CGRectMake(imageViews.fX+imageViews.fWidth - 7,3, 15, 15)];
    [cleanButton setBackgroundImage:[UIImage imageNamed:@"delete-1"] forState:UIControlStateNormal];
    cleanButton.tag = tag+100;
    [cleanButton setHidden:YES];
    [cleanButton setEnlargeEdge:15];
    [cleanButton addTarget:self action:@selector(cleanView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cleanButton];
    
}
//选择分销
-(void)storeSelect{
    ZDSelectStoreController *store = [[ZDSelectStoreController alloc] init];
    store.projectId = _projectId;
    [self.navigationController pushViewController:store animated:YES];
    store.storeBlocks = ^(NSDictionary *stores) {
        _storeName.text = [stores valueForKey:@"storeName"];
        _companyName.text = [stores valueForKey:@"companyName"];
        _changeName.text = [stores valueForKey:@"dutyName"];
        _phone.text = [stores valueForKey:@"telphone"];
        _storeId = [stores valueForKey:@"storeId"];
        NSString *startTime = [stores valueForKey:@"defaultSignStartTime"];
        if (startTime) {
            [_startTime setTitle:startTime forState:UIControlStateNormal];
        }
    };
}
//选择开始时间
-(void)beginDate:(UIButton *)button{
    [self touches];
    [BRDatePickerView showDatePickerWithTitle:@"开始时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        button.selected = YES;
        [button setTitle:selectValue forState:UIControlStateNormal];
    }];
}
//选择结束时间
-(void)endDate:(UIButton *)button{
    [self touches];
    [BRDatePickerView showDatePickerWithTitle:@"结束时间" dateType:UIDatePickerModeDate defaultSelValue:nil resultBlock:^(NSString *selectValue) {
        button.selected = YES;
        [button setTitle:selectValue forState:UIControlStateNormal];
    }];
}
//拍照
-(void)clickImage:(UIButton *)button{
    [self touches];
   ZDAlertView  *redView = [ZDAlertView new];
    redView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:0.8];
   redView.fSize = CGSizeMake(KScreenW, 161);
    [GKCover coverFrom:self.view
           contentView:redView
                 style:GKCoverStyleTranslucent
             showStyle:GKCoverShowStyleBottom
             animStyle:GKCoverAnimStyleBottom
              notClick:NO
     ];
    
    redView.imageBlock = ^(UIImage *image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        NSInteger tag = button.tag;
        UIButton *buttons = [_imageViews viewWithTag:(tag+1)];
        NSInteger x = button.superview.fX;
        NSInteger Y = button.superview.fY;
        UIButton *clsenButton = [_imageViews viewWithTag:(tag+100)];
        [clsenButton setHidden:NO];
        if (!buttons) {
            if (x!= button.superview.fWidth*2) {
                [self createImageViews:CGRectMake(button.superview.fX+button.superview.fWidth, button.superview.fY,( _imageViews.fWidth/3.0), 105) tags:tag+1];
                
            }else{
                if ( Y!= 38+button.superview.fHeight) {
                    [self createImageViews:CGRectMake(0, 38+button.superview.fHeight,( _imageViews.fWidth/3.0), 105) tags:tag+1];
                    _imageViews.fHeight += 105;
                    _image.fY +=105;
                    _label.fY +=105;
                }else{
                     [self createImageViews:CGRectMake(_imageViews.fWidth, 38+button.superview.fHeight,( _imageViews.fWidth/3.0), 105) tags:tag+1];
                }
            }
            
        }
    };
}
//删除图片
-(void)cleanView:(UIButton *)button{
    NSInteger num = _imageViews.subviews.count;
    //总共有多少按钮
    NSInteger n = num -1;
    //按钮的tag
    NSInteger tag =(button.tag - 110);
    //点击的按钮后面所有的按钮
    NSInteger m = n - tag;
    if(n>3){
        if ((n-3)==1) {
            for (int i = 1; i<m; i++) {
                if (i == m-1) {
                    UIButton  *buttons = [_imageViews viewWithTag:(button.tag - 100+i)];
                    buttons.tag -=1;
                    UIButton *cleanButtons = [_imageViews viewWithTag:(button.tag +i)];
                    cleanButtons.tag -=1;
                    UIView *view = cleanButtons.superview;
                    view.fX = view.fWidth*2;
                    view.fY = 38;
                    
                }else{
                    UIButton  *buttons = [_imageViews viewWithTag:(button.tag - 100+i)];
                    buttons.tag -=1;
                    UIButton *cleanButtons = [_imageViews viewWithTag:(button.tag +i)];
                    cleanButtons.tag -=1;
                    UIView *view = cleanButtons.superview;
                    view.fX -=(_imageViews.fWidth/3.0);
                }
             
            }
            _imageViews.fHeight -= 105;
            _image.fY -=105;
            _label.fY -=105;
        }else{
            for (int i = 1; i<=m; i++) {
                if (i == 3) {
                    UIButton  *buttons = [_imageViews viewWithTag:(button.tag - 100+i)];
                    buttons.tag -=1;
                    UIButton *cleanButtons = [_imageViews viewWithTag:(button.tag +i)];
                    cleanButtons.tag -=1;
                    UIView *view = cleanButtons.superview;
                    view.fX = view.fWidth*2;
                    view.fY = 38;
                    
                }else{
                    UIButton  *buttons = [_imageViews viewWithTag:(button.tag - 100+i)];
                    buttons.tag -=1;
                    UIButton *cleanButtons = [_imageViews viewWithTag:(button.tag +i)];
                    cleanButtons.tag -=1;
                    UIView *view = cleanButtons.superview;
                    view.fX -=(_imageViews.fWidth/3.0);
                }
                
            }
        }
    }else{
        for (int i = 1; i<=m; i++) {
            UIButton  *buttons = [_imageViews viewWithTag:(button.tag - 100+i)];
            buttons.tag -=1;
            UIButton *cleanButtons = [_imageViews viewWithTag:(button.tag +i)];
            cleanButtons.tag -=1;
            UIView *view = cleanButtons.superview;
            view.fX -=(_imageViews.fWidth/3.0);
        }
    }
    UIView *views = button.superview;
    [views removeFromSuperview];
}
//提交审核
-(void)submit{
    //分销Id
    NSString *distributionCompanyId = _storeId;
    //获取分销名称
    NSString *distributionCompanyName = _storeName.text;
    if ([distributionCompanyName isEqual:@"请选择"]) {
        [SVProgressHUD showInfoWithStatus:@"公司简称不能为空"];
        return;
    }
    //楼盘Id
    NSString *projectId = _projectId;
    //楼盘名称
    NSString *projectName = _projectName;
    if([projectName isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"楼盘名不能为空"];
        return;
    }
    //合同开始时间
    NSString *validityTimeStart = _startTime.titleLabel.text;
    if ([validityTimeStart isEqual:@"开始时间"]) {
        [SVProgressHUD showInfoWithStatus:@"开始时间不能为空"];
        return;
    }
    //合同结束时间
    NSString *validityTimeEnd = _endTime.titleLabel.text;
    if ([validityTimeEnd isEqual:@"结束时间"]) {
        [SVProgressHUD showInfoWithStatus:@"结束时间不能为空"];
        return;
    }
     long sTime = [self getZiFuChuan:validityTimeStart];
     long eTime = [self getZiFuChuan:validityTimeEnd];
    if (eTime<=sTime) {
        [SVProgressHUD showInfoWithStatus:@"时间选择错误"];
        return;
    }
    //公司全称
    NSString *companyName = _companyName.text;
    if([companyName isEqual:@""]||!companyName){
        [SVProgressHUD showInfoWithStatus:@"公司全称不能为空"];
        return;
    }
    //负责人
    NSString *dutyName = _changeName.text;
    if([dutyName isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"负责人姓名不能为空"];
        return;
    }
    //联系电话
    NSString *telphone = _phone.text;
    if([telphone isEqual:@""]){
        [SVProgressHUD showInfoWithStatus:@"联系电话不能为空"];
        return;
    }
    NSInteger sum =  _imageViews.subviews.count;
    if (sum == 2) {
        [SVProgressHUD showInfoWithStatus:@"合同照片不能为空"];
        return;
    }
    //2.拼接参数
    NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
    paraments[@"distributionCompanyId"] = distributionCompanyId;
    paraments[@"distributionCompanyName"] = distributionCompanyName;
    paraments[@"projectId"] = projectId;
    paraments[@"projectName"] = projectName;
    paraments[@"validityTimeStart"] = validityTimeStart;
    paraments[@"validityTimeEnd"] = validityTimeEnd;
    paraments[@"companyName"] = companyName;
    paraments[@"dutyName"] = dutyName;
    paraments[@"telphone"] = telphone;
    _paraments = paraments;
    //添加遮罩
    UIView *view = [[UIView alloc] init];
    [GKCover translucentWindowCenterCoverContent:view animated:YES notClick:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"提交中"];
    
    [self performSelector:@selector(loadData) withObject:self afterDelay:1];
    
}
-(void)loadData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [ user objectForKey:@"uuid"];
    NSInteger sum =  _imageViews.subviews.count;
    //创建会话请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    mgr.requestSerializer.timeoutInterval = 20;
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/projectCompany/sign/project",URL];
    [mgr POST:url parameters:_paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<(sum-1); i++) {
            UIButton *but = [_imageViews viewWithTag:(10+i)];
            UIImage *img = but.currentBackgroundImage;
            if (![img isEqual:_oldImage]) {
                NSData *imageData = [ZDAlertView imageProcessWithImage:img];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
                // 任意的二进制数据MIMEType application/octet-stream
                [formData appendPartWithFileData:imageData name:@"face" fileName:fileName mimeType:@"image/png"];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        [GKCover hide];
        [SVProgressHUD dismiss];
        if([code isEqual:@"200"]){
            [SVProgressHUD showInfoWithStatus:@"提交审核成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.companyName resignFirstResponder];
    [self.changeName resignFirstResponder];
    [self.phone resignFirstResponder];
}
-(void)touches{
    [self.companyName resignFirstResponder];
    [self.changeName resignFirstResponder];
    [self.phone resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (long)getZiFuChuan:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date1=[dateFormatter dateFromString:time];
    
    return [date1 timeIntervalSince1970]*1000;
    
}
//文本框编辑时
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_phone == textField) {
        if (toBeString.length>13) {
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
    textField.returnKeyType = UIReturnKeyDone;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
@end
