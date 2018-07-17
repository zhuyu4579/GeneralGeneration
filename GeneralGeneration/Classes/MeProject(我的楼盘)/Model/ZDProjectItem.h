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
//楼盘ID
@property(nonatomic,strong)NSString *id;
//佣金
@property(nonatomic,strong)NSString *commission;

@end
