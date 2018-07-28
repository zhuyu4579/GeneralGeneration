//
//  ZDMeCusController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDMeCusController.h"
#import "UIView+Frame.h"
#import "UIView+Center.h"
#import "ZDHaveController.h"
#import "UIBarButtonItem+Item.h"
#import "ZDSuccessController.h"
#import "ZDInvalidController.h"
#import "ZDAddCusController.h"
#import "ZDFindCustomerController.h"
@interface ZDMeCusController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak)UIView *titlesView;
@property(nonatomic,weak)UIButton *previousClickButton;
@property(nonatomic,weak)UIView *titleUnderLine;
@property(nonatomic,weak) UIScrollView *scrollView;
@end

@implementation ZDMeCusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"我的客户";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *jobType = [ user objectForKey:@"jobType"];
    if ([jobType isEqual:@"7"]) {
        self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search_1"] highImage:[UIImage imageNamed:@"search_1"] target:self action:@selector(findCustomer)],[UIBarButtonItem itemWithImage:[UIImage imageNamed:@"add"] highImage:[UIImage imageNamed:@"add"] target:self action:@selector(addCusController)]];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"search_1"] highImage:[UIImage imageNamed:@"search_1"] target:self action:@selector(findCustomer)];
    }
   
    //初始化子控制器
    [self setupAllChilds];
    //创建一个UIScrollView
    [self setUIScrollView];
    //创建标题栏
    [self setTitlesView];
}
//新增客户
-(void)addCusController{
    ZDAddCusController *addCus = [[ZDAddCusController alloc] init];
    [self.navigationController pushViewController:addCus animated:YES];
}
//搜索客户
-(void)findCustomer{
    ZDFindCustomerController *findCustomer = [[ZDFindCustomerController alloc] init];
    [self.navigationController pushViewController:findCustomer animated:YES];
}
#pragma mark -初始化子控制器
-(void)setupAllChilds{
    [self addChildViewController:[[ZDHaveController alloc] init]];
    [self addChildViewController:[[ZDSuccessController alloc] init]];
    [self addChildViewController:[[ZDInvalidController alloc] init]];
}
#pragma mark -创建UIScrollView
-(void)setUIScrollView{
    self.automaticallyAdjustsScrollViewInsets =NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(self.view.fX, self.view.fY+1, self.view.fWidth, self.view.fHeight);
    scrollView.backgroundColor = UIColorRBG(242, 242, 242);
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate =self;
    //    [scrollView setDelaysContentTouches:NO];
    //    [scrollView setCanCancelContentTouches:NO];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.contentSize =CGSizeMake(scrollView.fWidth*3,0);
}

#pragma mark -创建标题栏
-(void)setTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0,kApplicationStatusBarHeight+45, self.view.fWidth, 44)];
    titlesView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    //设置标题栏按钮
    [self setupTitlesButton];
    //设置下划线
    [self setupTitlesUnderline];
}
#pragma mark -设置标题栏按钮
-(void)setupTitlesButton{
    //文字
    NSArray *titles =@[@"进行中",@"已成交",@"已失效"];
    
    CGFloat titleButtonW = self.titlesView.fWidth/3;
    CGFloat titleButtonH =self.titlesView.fHeight;
    
    for (NSInteger i = 0; i<3; i++) {
        UIButton *titleButton = [[UIButton alloc] init];
        titleButton.tag = i;
        [self.titlesView addSubview:titleButton];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
        [titleButton setTitleColor:UIColorRBG(102, 102, 102) forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateSelected];
        titleButton.titleLabel.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        if (i == 0) {
            
            [self titleButtonClick:titleButton];
            
        }
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}
#pragma mark -按钮点击事件
-(void)titleButtonClick:(UIButton *)titleButton{
    self.previousClickButton.selected =NO;
    titleButton.selected = YES;
    self.previousClickButton = titleButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        //处理下划线
        self.titleUnderLine.cX = titleButton.cX;
        //联动
        self.scrollView.contentOffset = CGPointMake(self.scrollView.fWidth * titleButton.tag, self.scrollView.contentOffset.y);
    }completion:^(BOOL finished) {
        UIView *childsView = self.childViewControllers[titleButton.tag].view;
        childsView.frame = CGRectMake(self.scrollView.fWidth*titleButton.tag, _titlesView.fY+_titlesView.fHeight+1, self.scrollView.fWidth, self.scrollView.fHeight-(_titlesView.fY+_titlesView.fHeight+JF_BOTTOM_SPACE));
        [self.scrollView addSubview:childsView];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:nil];
    }];
}
#pragma mark -设置下划线
-(void)setupTitlesUnderline{
    UIButton *firstTitleButton = self.titlesView.subviews.firstObject;
    UIView *titleUnderLine = [[UIView alloc] init];
    titleUnderLine.fHeight = 2;
    titleUnderLine.fWidth = 65;
    titleUnderLine.fY = self.titlesView.fHeight - titleUnderLine.fHeight;
    titleUnderLine.cX = self.titlesView.fWidth/6;
    titleUnderLine.backgroundColor = [firstTitleButton  titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderLine];
    self.titleUnderLine = titleUnderLine;
}
#pragma mark -滑动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //算出按钮的索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.fWidth;
    UIButton *titleButton = self.titlesView.subviews[index];
    
    [self titleButtonClick:titleButton];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    return gestureRecognizer.state!= 0?YES:NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
