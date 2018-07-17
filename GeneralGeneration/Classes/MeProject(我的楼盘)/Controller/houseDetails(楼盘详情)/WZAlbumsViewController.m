//
//  WZAlbumsViewController.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAlbumsViewController.h"
#import "UIView+Frame.h"
#import "WZAlbumsCollectionView.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "WZAlbumsItem.h"
@interface WZAlbumsViewController ()
@property(nonatomic,weak)UIView *nView;

@property(nonatomic,strong)WZAlbumsCollectionView *collec;

@property(nonatomic,strong)NSArray *array;
@end

@implementation WZAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavTitle];
    //创建相册view
    [self setUpAlbumsView];
    //数据的请求
    [self finsDates];
    
}

-(void)setNavTitle{
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"楼盘相册";
}
//请求数据
-(void)finsDates{
    
        [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9]];
        [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setMaximumDismissTimeInterval:2.0f];

        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *uuid = [ user objectForKey:@"uuid"];
    
        //创建会话请求
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer.timeoutInterval = 20;
        
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        [mgr.requestSerializer setValue:uuid forHTTPHeaderField:@"uuid"];
        //2.拼接参数
        NSMutableDictionary *paraments = [NSMutableDictionary dictionary];
        paraments[@"id"] = _ID;
        NSString *url = [NSString stringWithFormat:@"%@/proProjectPicture/pictureList",URL];
        [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqual:@"200"]) {
                NSDictionary *data = [responseObject valueForKey:@"data"];
                NSArray *rows = [data valueForKey:@"list"];
                _array = rows;
                _collec.albumArray = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:rows];
               // [UIView setAnimationsEnabled:NO];
                [UIView performWithoutAnimation:^{
                    //刷新界面
                    [_collec reloadData];
                    //[UIView setAnimationsEnabled:YES];
                }];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code ==-1001) {
                [SVProgressHUD showInfoWithStatus:@"网络不给力"];
            }
        }];
    
}

//创建相册
-(void)setUpAlbumsView{
    UIView *albumsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.fWidth, self.view.fHeight)];
    albumsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumsView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    layout.minimumLineSpacing = 16;
    layout.itemSize = CGSizeMake(165, 110);
    WZAlbumsCollectionView *albumsCV = [[WZAlbumsCollectionView alloc] initWithFrame:CGRectMake(0, 0, albumsView.fWidth, albumsView.fHeight) collectionViewLayout:layout];
    albumsCV.projectId = _ID;
    _collec = albumsCV;
    [albumsView addSubview:albumsCV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
