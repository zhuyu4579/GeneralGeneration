//
//  ZDStoreCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDStoreItem;
@interface ZDStoreCell : UITableViewCell
//分销名称
@property (strong, nonatomic) IBOutlet UILabel *storeName;
//分销地址
@property (strong, nonatomic) IBOutlet UILabel *storeAddress;
//分销ID
@property(nonatomic,strong)NSString *storeId;
//是否被收藏
@property(nonatomic,strong)NSString *collect;
//时间
@property(nonatomic,strong)NSString *updateDate;
//数据模型
@property(nonatomic,strong)ZDStoreItem *item;
//默认时间
@property(nonatomic,strong)NSString *defaultSignStartTime;
@end
