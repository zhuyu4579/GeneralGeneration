//
//  ZDCityCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDCityCell.h"
#import "ZDCityItem.h"
@implementation ZDCityCell
-(void)setItem:(ZDCityItem *)item{
    _item = item;
    _cityName.text = item.cityName;
    _cityId = item.cityId;
    _areas = item.areas;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     _cityName.textColor = UIColorRBG(102, 102, 102);
}

@end
