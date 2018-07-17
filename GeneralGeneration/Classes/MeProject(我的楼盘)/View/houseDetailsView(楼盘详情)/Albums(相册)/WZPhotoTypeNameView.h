//
//  WZPhotoTypeNameView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZPhotoTypeNameView : UICollectionView

@property(nonatomic,strong)NSArray *arrays;

@property(nonatomic,strong)NSIndexPath *oldIndexPath;

@property(nonatomic,strong)NSIndexPath *selectIndexPath;
@end
