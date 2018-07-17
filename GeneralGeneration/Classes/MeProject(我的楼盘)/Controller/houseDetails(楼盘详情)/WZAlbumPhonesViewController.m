//
//  WZAlbumPhonesViewController.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/7.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//  相片浏览

#import "WZAlbumPhonesViewController.h"
#import "UIBarButtonItem+Item.h"
#import <Masonry.h>
#import "UIView+Frame.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "WZAlbumsViewController.h"
#import "WZAllPhotosCollectionView.h"
#import "WZAlbumsItem.h"
#import "WZPhotoTypeNameView.h"
#import "WZPhotoNameCell.h"
@interface WZAlbumPhonesViewController (){
    CGFloat _lastScale;
}
@property(nonatomic,strong)WZAllPhotosCollectionView *photosCV;
@property(nonatomic,strong)WZPhotoTypeNameView *photosName;
@property(nonatomic,strong)UILabel *page;
@property(nonatomic,strong)NSString *num;
@property(nonatomic,strong)NSIndexPath *oldIndexPath;
@property(nonatomic,strong)NSArray *list;
@end

@implementation WZAlbumPhonesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    //创建导航
    [self setNav];
    //设置图片显示区域
    [self showView];
    
    [self finsDates];
    
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
    paraments[@"id"] = _projectId;
    NSString *url = [NSString stringWithFormat:@"%@/proProjectPicture/pictureList",URL];
    [mgr GET:url parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *rows = [data valueForKey:@"list"];
            _list = rows;
            NSString *num = [data valueForKey:@"num"];
            _num = num;
            _page.text = [NSString stringWithFormat:@"1/%@",num];
            
                NSArray *array = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:rows];
                
                _photosCV.array = array;
                //[UIView setAnimationsEnabled:NO];
                [UIView performWithoutAnimation:^{
                    //刷新界面
                    [_photosCV reloadData];
                    //[UIView setAnimationsEnabled:YES];
                }];
                [self selectPhoto];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code ==-1001) {
            [SVProgressHUD showInfoWithStatus:@"网络不给力"];
        }
    }];
    
}

//设置导航
-(void)setNav{
    UIView *nav = [[UIView alloc] init];
    nav.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kApplicationStatusBarHeight);
        make.width.offset(self.view.fWidth);
        make.height.offset(44);
    }];
    //创建返回按钮
    UIButton *black = [[UIButton alloc] init];
    [black setImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
    [black addTarget:self action:@selector(black) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:black];
    [black mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav.mas_left);
        make.top.equalTo(nav.mas_top);
        make.width.offset(50);
        make.height.offset(44);
    }];
    //创建页数
    UILabel *page = [[UILabel alloc] init];
    page.textColor = [UIColor whiteColor];
    page.font = [UIFont systemFontOfSize:16];
    _page = page;
    [nav addSubview:page];
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nav.mas_centerX);
        make.centerY.equalTo(nav.mas_centerY);
        make.height.offset(16);
    }];
    //创建相册按钮
    UIButton *albums = [[UIButton alloc] init];
    [albums setTitle:@"相册" forState:UIControlStateNormal];
    [albums setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    albums.titleLabel.font = [UIFont systemFontOfSize:15];
    [albums addTarget:self action:@selector(allPhotos) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:albums];
    [albums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(nav.mas_right);
        make.top.equalTo(nav.mas_top);
        make.width.offset(65);
        make.height.offset(44);
    }];
    
}
-(void)showView{
    
    float n = [UIScreen mainScreen].bounds.size.width/375.0;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.fHeight - 280*n)/2.0, self.view.fWidth, 280*n)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    //缩放图片
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [view addGestureRecognizer:pinch];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *layouts = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layouts.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layouts.itemSize = CGSizeMake(view.fWidth, view.fHeight);
    layouts.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layouts.minimumLineSpacing = 0;
    WZAllPhotosCollectionView *allPhotos= [[WZAllPhotosCollectionView alloc]initWithFrame:CGRectMake(0, 0,view.fWidth, view.fHeight) collectionViewLayout:layouts];
    _photosCV = allPhotos;
    [view addSubview:allPhotos];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:@"indexPath" object:nil];
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.fHeight-50-JF_BOTTOM_SPACE, self.view.fWidth, 50+JF_BOTTOM_SPACE)];
    buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buttonView];
    //创建一个layout布局类
    UICollectionViewFlowLayout *layoutN = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为水平流布局
    layoutN.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layoutN.estimatedItemSize = CGSizeMake(65, 50);
    layoutN.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layoutN.minimumLineSpacing = 10;
    WZPhotoTypeNameView *photoName= [[WZPhotoTypeNameView alloc]initWithFrame:CGRectMake(0, 0,buttonView.fWidth, buttonView.fHeight) collectionViewLayout:layoutN];
    _photosName = photoName;
    [buttonView addSubview:photoName];
    //创造通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changes:) name:@"indexPaths" object:nil];
}
//缩放图片
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
    
    UIGestureRecognizerState state = [recognizer state];
    
    if(state == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        //获取最后的比例
        _lastScale = [recognizer scale];
    }
    
    if (state == UIGestureRecognizerStateBegan ||
        state == UIGestureRecognizerStateChanged) {
        //获取当前的比例
        CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        // Constants to adjust the max/min values of zoom
        //设置最大最小的比例
        const CGFloat kMaxScale = 3.0;
        const CGFloat kMinScale = 1.0;
        //设置
        
        //获取上次比例减去想去得到的比例
        CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
        newScale = MIN(newScale, kMaxScale / currentScale);
        newScale = MAX(newScale, kMinScale / currentScale);
        CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
        [recognizer view].transform = transform;
        // Store the previous scale factor for the next pinch gesture call
        //获取最后比例 下次再用
        _lastScale = [recognizer scale];
    }
    
}
//默认选择的照片
-(void)selectPhoto{
    int n = 0;
    int m = 0;
    for (int i = 0; i<_list.count; i++) {
        NSArray *picCollect = [_list[i] valueForKey:@"picCollect"];
        for (int j = 0; j<picCollect.count; j++) {
            NSString *ID = [picCollect[j] valueForKey:@"id"];
            if ([_photoId isEqual:ID]) {
                n = i;
                m = j;
                break;
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:m inSection:n];
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
    
    [_photosCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    UICollectionViewLayoutAttributes *attr = [self.photosCV.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    CGRect rect = attr.frame;
    rect.size = self.photosCV.frame.size;
    NSInteger page = rect.origin.x/self.view.fWidth +1;
    _page.text = [NSString stringWithFormat:@"%ld/%@",(long)page,_num];
    
    _oldIndexPath = indexPath1;
    _photosName.oldIndexPath = _oldIndexPath;
    _photosName.selectIndexPath = _oldIndexPath;
    
    _photosName.arrays = [WZAlbumsItem mj_objectArrayWithKeyValuesArray:_list];;
    [_photosName reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [_photosName scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
}
//1接收通知
-(void)change:(NSNotification *)notFi{
    NSDictionary *dicty = [notFi userInfo];
    _page.text = [NSString stringWithFormat:@"%@/%@",[dicty valueForKey:@"index"],_num];
    NSIndexPath *indexPath = [dicty valueForKey:@"indexPath"];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:indexPath.section inSection:0];
    [_photosName scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    WZPhotoNameCell *cell1 =(WZPhotoNameCell *) [_photosName cellForItemAtIndexPath:_oldIndexPath];
    cell1.name.textColor = UIColorRBG(203, 203, 203);
    cell1.name.backgroundColor = [UIColor clearColor];
    
    WZPhotoNameCell *cell =(WZPhotoNameCell *) [_photosName cellForItemAtIndexPath:indexPath1];
    cell.name.textColor = [UIColor whiteColor];
    cell.name.backgroundColor = UIColorRBG(3, 133, 219);
    _oldIndexPath = indexPath1;
    _photosName.oldIndexPath = _oldIndexPath;
}
//2接收通知
-(void)changes:(NSNotification *)notFi{
    NSDictionary *dicty = [notFi userInfo];
    NSIndexPath *indexPath = [dicty valueForKey:@"indexPath"];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];
    [_photosCV scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    UICollectionViewLayoutAttributes *attr = [self.photosCV.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath1];
    
    CGRect rect = attr.frame;
    rect.size = self.photosCV.frame.size;
    NSInteger page = rect.origin.x/self.view.fWidth +1;
    _page.text = [NSString stringWithFormat:@"%ld/%@",(long)page,_num];
    _oldIndexPath = indexPath;
    
}
-(void)black{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)allPhotos{
    if ([_type isEqual:@"0"]) {
        WZAlbumsViewController *albums =[[WZAlbumsViewController alloc] init];
        albums.ID = _projectId;
        [self.navigationController pushViewController:albums animated:YES];
    }else if([_type isEqual:@"1"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -不显示导航条
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


@end
