//
//  ZDMapController.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDMapController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "UIView+Frame.h"
#import "POIAnnotation.h"
#import "AMapTipAnnotation.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "UIBarButtonItem+Item.h"
#import <SVProgressHUD.h>
@interface ZDMapController ()<MAMapViewDelegate, AMapSearchDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tips;

@property (nonatomic, strong) MAPointAnnotation *point;
//选择的位置坐标
@property(nonatomic,strong)NSString *points;
//选择的位置城市
@property(nonatomic,strong)NSString *address;
//区编码
@property(nonatomic,strong)NSString *adCode;
//位置显示
@property(nonatomic,strong)UILabel *district;
//地址显示
@property(nonatomic,strong)UILabel *township;
@end

@implementation ZDMapController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7]];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    self.view.backgroundColor = UIColorRBG(242, 242, 242);
    self.navigationItem.title = @"门店位置";
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithButton:self action:@selector(selectPoint) title:@"确定"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tips = [NSMutableArray array];
    
    [AMapServices sharedServices].apiKey = @"5486d7a852ad8a9b610fb3c62c506d11";
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(self.view.fX, 57, self.view.fWidth, self.view.fHeight-57)];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    //开启定位
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [_mapView setZoomLevel:16.1 animated:YES];
    
    UITapGestureRecognizer *press = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [_mapView addGestureRecognizer:press];
    _point = [[MAPointAnnotation alloc] init];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self initSearchController];
    [self initTableView];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)longPress:(UIGestureRecognizer *)gest{
    //创建点标记
    //清除旧的点
    [_mapView removeAnnotations:_mapView.annotations];
    //坐标转换
    CGPoint touchPoint = [gest locationInView:_mapView];
    CLLocationCoordinate2D touchMapCoordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    _point.coordinate = touchMapCoordinate;
    [_mapView setCenterCoordinate:touchMapCoordinate animated:YES];
    [_mapView addAnnotation:_point];
    
    //编译坐标的位置
     [self setLocationWithLatitude:touchMapCoordinate.latitude AndLongitude:touchMapCoordinate.longitude];
}

- (void)setLocationWithLatitude:(CLLocationDegrees)latitude AndLongitude:(CLLocationDegrees)longitude{
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%f",latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%f",longitude];
    _points = [NSString stringWithFormat:@"%@,%@",longitudeStr,latitudeStr];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
 
}
//反编译地址
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        AMapReGeocode *regeo = response.regeocode;
       //地址组成要素
        AMapAddressComponent *address = regeo.addressComponent;
        //省
        NSString *province = address.province;
        //市
        NSString *city = address.city;
       
        //区
        NSString *district = address.district;
       
         _district.text = district;
      
        //区编码
        NSString *adCode = address.adcode;
        _adCode = adCode;
        _address = [NSString stringWithFormat:@"%@%@%@",province,city,district];
        _township.text = regeo.formattedAddress;
    }
}
//确认按钮
-(void)selectPoint{

    if (!_points || !_address) {
        [SVProgressHUD showInfoWithStatus:@"选择的点有误！请重新选择"];
        return;
    }
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
     dicty[@"lnglat"] = _points;
     dicty[@"address"] = _address;
     dicty[@"adCode"] = _adCode;
    if (_addrBlock) {
        _addrBlock(dicty);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.searchController.active = NO;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_mapView.annotations.count == 1) {
        //当前位置的数据
        MAUserLocation *userLocation = _mapView.userLocation;
        
        CLLocation *location = userLocation.location;
        
        CLLocationCoordinate2D touchMapCoordinate = location.coordinate;
        [_mapView setCenterCoordinate:touchMapCoordinate animated:YES];
        //编译坐标的位置
        [self setLocationWithLatitude:touchMapCoordinate.latitude AndLongitude:touchMapCoordinate.longitude];
        
    }
}
#pragma mark - Utility

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    //tips.city     = @"杭州";
    tips.cityLimit = YES;
    
    [self.search AMapInputTipsSearch:tips];
}

- (void)searchPOIWithTip:(AMapTip *)tip
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.cityLimit = YES;
    request.keywords   = tip.name;
    //request.city  = @"杭州";
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]] || [annotation isKindOfClass:[AMapTipAnnotation class]] ||[annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"addr"];
        annotationView.fSize = CGSizeMake(28, 55);
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth   = 4.f;
        polylineRenderer.strokeColor = [UIColor magentaColor];
        
        return polylineRenderer;
    }
    
    return nil;
}

#pragma mark - AMapSearchDelegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }
    
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:NO];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //设置view的位置
    self.tableView.hidden = !searchController.isActive;
    
    [self searchTipsWithKey:searchController.searchBar.text];
    
    if (searchController.isActive && searchController.searchBar.text.length > 0)
    {
        searchController.searchBar.placeholder = searchController.searchBar.text;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    AMapTip *tip = self.tips[indexPath.row];
    
    if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
    {
        AMapTipAnnotation *annotation = [[AMapTipAnnotation alloc] initWithMapTip:tip];
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate];
        [self.mapView selectAnnotation:annotation animated:YES];
        CLLocationCoordinate2D touchMapCoordinate = annotation.coordinate;
        [_mapView setCenterCoordinate:touchMapCoordinate animated:YES];
        //编译坐标的位置
        [self setLocationWithLatitude:touchMapCoordinate.latitude AndLongitude:touchMapCoordinate.longitude];
    }
    else
    {
        [self searchPOIWithTip:tip];
    }
    
    self.searchController.active = NO;
}

#pragma mark - Initialization

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, self.view.frame.size.width, self.view.frame.size.height-57) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
}

- (void)initSearchController
{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.view.fWidth, 45)];
    [self.view addSubview:searchView];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"请输入关键字";
    self.searchController.searchBar.searchBarStyle =UISearchBarStyleMinimal;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    [self.searchController.searchBar sizeToFit];
    [searchView addSubview:self.searchController.searchBar];
    
    UIView *addrView = [[UIView alloc] initWithFrame:CGRectMake(15,self.view.fHeight -124-kApplicationStatusBarHeight, self.view.fWidth - 30 , 60)];
    addrView.backgroundColor = [UIColor whiteColor];
    addrView.layer.cornerRadius = 4.0;
    addrView.layer.shadowColor = [UIColor grayColor].CGColor;
    addrView.layer.shadowOpacity = 0.8f;
    addrView.layer.shadowRadius = 4.0f;
    addrView.layer.shadowOffset = CGSizeMake(0,0);
    [self.view addSubview:addrView];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 10, 22, 42);
    imageView.image = [UIImage imageNamed:@"addr"];
    [addrView addSubview:imageView];
    UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(42, 12, addrView.fWidth - 72, 16)];
    cityName.textColor = UIColorRBG(68, 68, 68);
    cityName.font = [UIFont systemFontOfSize:16];
    _district = cityName;
    [addrView addSubview:cityName];
    UILabel *addrsName = [[UILabel alloc] initWithFrame:CGRectMake(42, 36, addrView.fWidth -  62, 14)];
    addrsName.textColor = UIColorRBG(153, 153, 153);
    addrsName.font = [UIFont systemFontOfSize:14];
    _township = addrsName;
    [addrView addSubview:addrsName];
}
@end
