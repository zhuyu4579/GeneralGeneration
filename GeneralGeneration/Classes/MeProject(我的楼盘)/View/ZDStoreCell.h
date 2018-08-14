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
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *saveName;
@property(nonatomic,strong)NSString *dutyName;
//门店创建者
@property(nonatomic,strong)NSString *storeCreatorName;
//保护期内
@property(nonatomic,strong)NSString *protectType;
//分销ID
@property(nonatomic,strong)NSString *storeId;
@property(nonatomic,strong)NSString *signEndTime;
@property(nonatomic,strong)NSString *signStatus;
//是否被收藏
@property(nonatomic,strong)NSString *collect;
//时间
@property(nonatomic,strong)NSString *updateDate;
//数据模型
@property(nonatomic,strong)ZDStoreItem *item;
//默认时间
@property(nonatomic,strong)NSString *defaultSignStartTime;
@end
