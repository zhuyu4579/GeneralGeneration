//
//  WZPhotoTypeNameView.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPhotoTypeNameView.h"
#import "WZAlbumsItem.h"
#import "WZPhotoNameCell.h"
static NSString * const ID = @"Cell";
@interface WZPhotoTypeNameView () <UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource>

@end
@implementation WZPhotoTypeNameView
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
    [self registerNib:[UINib nibWithNibName:@"WZPhotoNameCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    return self;
}


#pragma mark - UICollectionView DataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _arrays.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WZPhotoNameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if ([_selectIndexPath isEqual:indexPath]) {
        cell.name.textColor = [UIColor whiteColor];
        cell.name.backgroundColor = UIColorRBG(3, 133, 219);
    }
    WZAlbumsItem *item = self.arrays[indexPath.row];
    cell.item = item;
    return cell;
}
//点击cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZPhotoNameCell *cell1 =(WZPhotoNameCell *) [collectionView cellForItemAtIndexPath:_oldIndexPath];
    cell1.name.textColor = UIColorRBG(203, 203, 203);
    cell1.name.backgroundColor = [UIColor clearColor];
    
     WZPhotoNameCell *cell =(WZPhotoNameCell *) [collectionView cellForItemAtIndexPath:indexPath];
    _oldIndexPath = indexPath;
    cell.name.textColor = [UIColor whiteColor];
    cell.name.backgroundColor = UIColorRBG(3, 133, 219);
    NSMutableDictionary *dicty = [NSMutableDictionary dictionary];
    dicty[@"indexPath"] = indexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"indexPaths" object:nil userInfo:dicty];
}
@end
