//
//  ZDMeCustItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDMeCustItem : NSObject
//订单Id
@property(nonatomic,strong)NSString *id;
//楼盘名称
@property(nonatomic,strong)NSString *projectName;
//订单修改时间
@property(nonatomic,strong)NSString *updateDate;
//客户名称
@property(nonatomic,strong)NSString *clientName;
//报备电话
@property(nonatomic,strong)NSString *missContacto;
//经纪人id
@property(nonatomic,strong)NSString *appUserId;
//经纪人/电话
@property(nonatomic,strong)NSDictionary *user;
//订单交易状态
@property(nonatomic,strong)NSString *dealStatus;
//订单审核状态
@property(nonatomic,strong)NSString *verify;
//订单来源
@property(nonatomic,strong)NSString *source;
@end
