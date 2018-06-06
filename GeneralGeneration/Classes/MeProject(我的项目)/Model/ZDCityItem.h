//
//  ZDCityItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDCityItem : NSObject
//城市code
@property(nonatomic,strong)NSString *cityId;
//城市名称
@property(nonatomic,strong)NSString * cityName;
//城市区域
@property(nonatomic,strong)NSArray *areas;

@end

