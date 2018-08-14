//
//  ZDStoreItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDStoreItem : NSObject
//分销名称
@property(nonatomic,strong)NSString *name;
//分销地址
@property(nonatomic,strong)NSString *addr;
//分销ID
@property(nonatomic,strong)NSString *id;
//是否被收藏
@property(nonatomic,strong)NSString *collect;
//时间
@property(nonatomic,strong)NSString *updateDate;
//默认开始日期
@property(nonatomic,strong)NSString *defaultSignStartTime;
//默认结束日期
@property(nonatomic,strong)NSString *signEndTime;
//签约状态
@property(nonatomic,strong)NSString *signStatus;
//分销责任人
@property(nonatomic,strong)NSString *dutyName;
//签约人类型
@property(nonatomic,strong)NSString *type;
//是否在保护期
@property(nonatomic,strong)NSString *protectType;
//门店创建者
@property(nonatomic,strong)NSString *storeCreatorName;
@end
