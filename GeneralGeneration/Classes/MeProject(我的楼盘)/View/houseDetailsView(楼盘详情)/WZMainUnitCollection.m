//
//  WZMainUnitCollection.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZMainUnitCollection.h"
#import "WZMainUnitCell.h"
#import "WZMainUnitItem.h"
static NSString * const ID = @"Mcell";
@interface WZMainUnitCollection ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@end
@implementation WZMainUnitCollection
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
   // self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.showsVerticalScrollIndicator = NO;
//    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor whiteColor];
    [self setCollectionViewLayout:layout];
    self.frame = frame;
    //注册cell
    [self registerNib:[UINib nibWithNibName:@"WZMainUnitCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self reloadData];
    return self;
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _collectDatas.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZMainUnitCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.layer.borderColor = UIColorRBG(242, 242, 242).CGColor;
    cell.layer.borderWidth = 1;
    WZMainUnitItem *item = [[WZMainUnitItem alloc] init];
    item = _collectDatas[indexPath.row];
    cell.item = item;
    return cell;
}

@end
