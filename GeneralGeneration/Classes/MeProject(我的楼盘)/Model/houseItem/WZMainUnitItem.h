//
//  WZMainUnitItem.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/4/17.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMainUnitItem : NSObject
//主键ID
@property(nonatomic,strong)NSString *id;
//户型图片
@property(nonatomic,strong)NSArray *pictures;
//户型类型
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *living;
@property(nonatomic,strong)NSString *toilet;
//面积
@property(nonatomic,strong)NSString *area;
//价格
@property(nonatomic,strong)NSString *price;
@end
