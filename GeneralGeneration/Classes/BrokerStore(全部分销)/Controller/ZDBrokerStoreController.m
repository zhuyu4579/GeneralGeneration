//
//  ZDBrokerStoreController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDBrokerStoreController.h"
#import "UIBarButtonItem+Item.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import "ZDAllStoreController.h"
#import "ZDCollStoreController.h"
#import "ZDAddStoreController.h"

@interface ZDBrokerStoreController ()
//导航栏
@property (nonatomic, strong)UISegmentedControl *segmented;
//全部
@property(nonatomic,strong)ZDAllStoreController *allStore;
//收藏
@property(nonatomic,strong)ZDCollStoreController *collStore;

@end

@implementation ZDBrokerStoreController

- (void)viewDidLoad {
    [super viewDidLoad];
   //设置导航栏
    [self setUpNav];
   
}
//全部
-(ZDAllStoreController *)allStore{
    if (_allStore == nil) {
        _allStore = [[ZDAllStoreController alloc] init];
        _allStore.view.frame = CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-44-JF_BOTTOM_SPACE);
       
    }
    return _allStore;
}
//收藏
-(ZDCollStoreController *)collStore{
    if (_collStore == nil) {
        _collStore = [[ZDCollStoreController alloc] init];
        _collStore.view.frame = CGRectMake(0, kApplicationStatusBarHeight+44, self.view.fWidth, self.view.fHeight-kApplicationStatusBarHeight-44-JF_BOTTOM_SPACE);
    }
    return _collStore;
}
//设置导航栏
-(void)setUpNav{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"全部分销", @"我的分销"]];
    _segmented  = segmented;
    segmented.frame = CGRectMake(0, 0, 120, 25);
    // 设置整体的色调
    segmented.tintColor = UIColorRBG(3, 133, 219);
    segmented.layer.masksToBounds = YES;
    segmented.layer.cornerRadius = 15;
    segmented.layer.borderWidth = 1;
    segmented.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:UIColorRBG(3, 133, 219),NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName ,nil];
    [segmented setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    // 设置初始选中项
    
    segmented.selectedSegmentIndex = _status;
    
    [segmented addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];// 添加响应方法
  
    // 设置点击后恢复原样，默认为NO，点击后一直保持选中状态
    [segmented setMomentary:NO];
    self.navigationItem.titleView = segmented;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed: @"add"] highImage:[UIImage imageNamed:@"add"] target:self action:@selector(addStore)];

}
//选择控制器
-(void)selectItem:(UISegmentedControl *)segmend{
        _status = segmend.selectedSegmentIndex;
        if(segmend.selectedSegmentIndex == 0){
            [self.collStore.view removeFromSuperview];
            [self.view addSubview:self.allStore.view];
            [_allStore loadDatas];
            
        }else{
            [self.allStore.view removeFromSuperview];
            [self.view addSubview:self.collStore.view];
            [_collStore loadDatas];
        }
}
//新增分销
-(void)addStore{
    ZDAddStoreController *addStore =   [[ZDAddStoreController alloc] init];
    [self.navigationController pushViewController:addStore animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if (_status == 0) {
        [self.view addSubview:self.allStore.view];
        [_allStore loadDatas];
    }else{
        [self.view addSubview:self.collStore.view];
        [_collStore loadDatas];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
