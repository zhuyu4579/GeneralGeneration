//
//  ZDAllStoreItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDAllStoreItem : NSObject
//分销名称
@property(nonatomic,strong)NSString *name;
//分销地址
@property(nonatomic,strong)NSString *addr;
//分销ID
@property(nonatomic,strong)NSString *id;
//时间
@property(nonatomic,strong)NSString *updateDate;
//负责人
@property(nonatomic,strong)NSString *dutyName;
//电话
@property(nonatomic,strong)NSString *telphone;
//公司名称
@property(nonatomic,strong)NSString *companyName;
//是否关注过
@property(nonatomic,strong)NSString *collect;
//距离
@property(nonatomic,strong)NSString *distance;
@end
