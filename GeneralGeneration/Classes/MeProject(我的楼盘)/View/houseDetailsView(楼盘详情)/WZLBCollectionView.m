//
//  WZLBCollectionView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZLBCollectionView.h"
#import "WZLBCollectionViewCell.h"
#import "WZLunBoItem.h"
#import "WZAlbumPhonesViewController.h"
#import "UIViewController+WZFindController.h"
@interface WZLBCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>
@end
static NSString * const ID = @"cell";
@implementation WZLBCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
   
    self.backgroundColor = [UIColor whiteColor];
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
   [self registerNib:[UINib nibWithNibName:@"WZLBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    return self;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arrayDatas.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZLBCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    WZLunBoItem *item = _arrayDatas[indexPath.row];
    cell.item = item;
    return cell;
}
//点击图片
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZLBCollectionViewCell *cell = (WZLBCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    NSString *photoId = cell.ID;
    WZAlbumPhonesViewController *ap = [[WZAlbumPhonesViewController alloc] init];
    ap.type = @"0";
    ap.projectId = _projectId;
    ap.photoId = photoId;
    UIViewController *Vc = [UIViewController viewController:self.superview];
    [Vc.navigationController pushViewController:ap animated:YES];
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
    
}

@end
