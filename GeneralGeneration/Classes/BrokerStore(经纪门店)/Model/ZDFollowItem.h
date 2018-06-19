//
//  ZDFollowItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDFollowItem : NSObject
//跟进时间
@property(nonatomic,strong)NSString *followTime;
//跟进内容
@property(nonatomic,strong)NSString *content;
//跟进类型
@property(nonatomic,strong)NSString *followType;
//负责人姓名
@property(nonatomic,strong)NSString *followBy;
@end
