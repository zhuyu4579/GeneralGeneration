//
//  ZDOpinionController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDOpinionController.h"
#import "UIBarButtonItem+Item.h"
#import "UIView+Frame.h"
#import <Masonry.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <MJRefresh.h>
#import <MJExtension.h>
#import "NSString+LCExtension.h"
@interface ZDOpinionController ()<UITextViewDelegate>
//文本输入框
@property (nonatomic, retain) UITextView *textView;
//文本提示语
@property (nonatomic, retain) UILabel *labels;
//文本数量
@property (nonatomic, retain) UILabel *labelSum;
@end

@implementation ZDOpinionController

- (void)viewDidLoad {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
     [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0f];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(Submission) title:@"提交"];
    //设置输入框
    [self setUpRead];
}
//设置输入框
-(void)setUpRead{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, kApplicationStatusBarHeight+54, self.view.fWidth-30, 185)];
    view.backgroundColor = UIColorRBG(245, 245, 245);
    [self.view addSubview:view];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, view.fWidth, view.fHeight-25)]; //初始化大小并自动释放
    
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:13.0];//设置字体名字和字体大小
    
    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    
    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [view addSubview: self.textView];//加入到页面中
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.textView.fWidth-20, 13)];
    lable.textColor = UIColorRBG(204, 204, 204);
    lable.font = [UIFont systemFontOfSize:13];
    lable.text = @"输入宝贵意见";
    _labels = lable;
    [self.textView addSubview:lable];
    
    UILabel *lable1 = [[UILabel alloc] init];
    lable1.textColor = UIColorRBG(204, 204, 204);
    lable1.font = [UIFont systemFontOfSize:13];
    lable1.text = @"0/400";
    _labelSum = lable1;
    [view addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-10);
        make.top.equalTo(view.mas_top).offset(162);
        make.height.offset(13);
    }];
    
}
//开始编辑
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [_labels setHidden:YES];
}
//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = textView.text;
    if (text.length == 0) {
        [_labels setHidden:NO];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
      NSString *text = textView.text;
    _labelSum.text = [NSString stringWithFormat:@"%lu/400",(unsigned long)text.length];
    if (text.length == 400) {
        textView.editable = NO;
    }
}
//提交
-(void)Submission{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [user objectForKey:@"uuid"];
        NSString *jobType = [user objectForKey:@"jobType"];
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
        paraments[@"content"] = _textView.text;
        paraments[@"type"] = jobType;
        NSString *url = [NSString stringWithFormat:@"%@/proposal/save",URL];
        [mgr POST:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                 [SVProgressHUD showInfoWithStatus:@"谢谢你的吐槽，我们将持续为你改进"];
                [self.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -软件盘收回
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}
@end
