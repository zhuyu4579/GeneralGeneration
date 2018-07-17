//
//  WZAllPhotosCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAllPhotosCollectionView.h"
#import "WZAllPhotoCell.h"
#import "WZAlbumsItem.h"
#import <UIImageView+WebCache.h>
static NSString * const ID = @"Cell";
@interface WZAllPhotosCollectionView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,assign)NSIndexPath *currentIndexPath;

@end
@implementation WZAllPhotosCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
   
    self.frame = frame;
    self.bounces = YES;
    [self setCollectionViewLayout:layout];
    
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZAllPhotoCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    return self;
}


#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.array.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    WZAlbumsItem *model = self.array[section];
    return model.picCollect.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZAllPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZAlbumsItem *mdel = self.array[indexPath.section];
    NSDictionary *data = mdel.picCollect[indexPath.row];
    NSString *url = [data valueForKey:@"url"];
    NSString *IDs  = [data valueForKey:@"id"];
    
    //转换图片地址
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    cell.ID = IDs;
    return cell;
}
//分页效果
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = self.frame.size.width; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    targetContentOffset->x = currentOffset;
    
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:CGPointMake(newTargetOffset, 0)];
    _currentIndexPath = indexPath;
    _currentIndex = newTargetOffset/pageWidth +1;
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"index"] = [NSString stringWithFormat:@"%ld",(long)_currentIndex];
    dicty[@"indexPath"] = _currentIndexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexPath" object:nil userInfo:dicty];
}

@end
