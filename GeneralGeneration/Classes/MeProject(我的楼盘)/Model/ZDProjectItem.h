//
//  ZDProjectItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDProjectItem : NSObject
//楼盘名称
@property(nonatomic,strong)NSString *name;
//楼盘地址
@property(nonatomic,strong)NSString *address;
//默认时间
@property(nonatomic,strong)NSString *defaultSignStartTime;
//结束时间
@property(nonatomic,strong)NSString *signEndTime;
//楼盘ID
@property(nonatomic,strong)NSString *id;
//佣金
@property(nonatomic,strong)NSString *commission;
//签约状态
@property(nonatomic,strong)NSString *signStatus;
//责任经服
@property(nonatomic,strong)NSString *serverName;
//签约类型
@property(nonatomic,strong)NSString *type;
@end
