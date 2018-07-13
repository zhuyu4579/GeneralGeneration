//
//  ZDPunchItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDPunchItem : NSObject
//打卡时间
@property(nonatomic,strong)NSString *clockDate;
//打卡类型
@property(nonatomic,strong)NSString *clockType;
//打卡位置
@property(nonatomic,strong)NSString *addr;
@end
