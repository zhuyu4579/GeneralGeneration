//
//  ZDCityCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDCityItem;
@interface ZDCityCell : UITableViewCell
//城市名称
@property (strong, nonatomic) IBOutlet UILabel *cityName;
//城市编码
@property(nonatomic ,strong) NSString *cityId;
//区域数组
@property(nonatomic ,strong) NSArray *areas;
//数据模型
@property(nonatomic ,strong) ZDCityItem *item;
@end
