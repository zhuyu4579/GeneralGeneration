//
//  WZAlbumsCollectionView.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAlbumsCollectionView : UICollectionView
//数据数组字典
@property(nonatomic,strong)NSArray *albumArray;

@property(nonatomic,assign)NSString *isLoaded;
//楼盘ID
@property(nonatomic,assign)NSString *projectId;
@end
