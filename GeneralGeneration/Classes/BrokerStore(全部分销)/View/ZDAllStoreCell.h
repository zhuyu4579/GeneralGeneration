//
//  ZDAllStoreCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDAllStoreItem;
@interface ZDAllStoreCell : UITableViewCell
//分销名称
@property (strong, nonatomic) IBOutlet UILabel *storeName;
//创建日期
@property (strong, nonatomic) IBOutlet UILabel *storeDate;
//分销地址
@property (strong, nonatomic) IBOutlet UILabel *storeAddress;
//签约楼盘
@property (strong, nonatomic) IBOutlet UIButton *contractProject;
//关注
@property (strong, nonatomic) IBOutlet UIButton *collect;
//写跟进
@property (strong, nonatomic) IBOutlet UIButton *readFollow;
//打卡
@property (strong, nonatomic) IBOutlet UIButton *punch;
//分销ID
@property(nonatomic,strong)NSString *storeId;
//负责人
@property(nonatomic,strong)NSString *dutyName;
//电话
@property(nonatomic,strong)NSString *telphone;
//公司名称
@property(nonatomic,strong)NSString *companyName;
//是否关注过
@property(nonatomic,strong)NSString *isCollect;
//数据模型
@property(nonatomic,strong)ZDAllStoreItem *item;

@end
