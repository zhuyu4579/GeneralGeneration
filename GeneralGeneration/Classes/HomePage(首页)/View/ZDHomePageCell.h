//
//  ZDHomePageCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDPageItem;
@interface ZDHomePageCell : UICollectionViewCell
//图标
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
//名称
@property (strong, nonatomic) IBOutlet UILabel *name;
//tag
@property (strong, nonatomic)NSString *tags;
//模型
@property (strong, nonatomic)ZDPageItem *item;
//名字类型
@property(nonatomic,strong)NSString *ename;

@end
