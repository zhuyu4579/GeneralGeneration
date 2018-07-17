//
//  WZLBCollectionView.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZLBCollectionView : UICollectionView
//数据源
@property(nonatomic,strong)NSArray *arrayDatas;
//楼盘ID
@property(nonatomic,strong)NSString *projectId;
@end
