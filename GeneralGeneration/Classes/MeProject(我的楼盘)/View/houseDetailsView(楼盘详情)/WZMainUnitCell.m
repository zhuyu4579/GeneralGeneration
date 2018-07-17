//
//  WZMainUnitCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZMainUnitCell.h"
#import "WZMainUnitItem.h"
#import <UIImageView+WebCache.h>
@implementation WZMainUnitCell
//参数赋值
-(void)setItem:(WZMainUnitItem *)item{
   
    [_houseImage sd_setImageWithURL:[NSURL URLWithString:item.pictures[0]] placeholderImage:[UIImage imageNamed:@"bb_5_pic"]];
    NSInteger room = [item.room integerValue];
    NSInteger living = [item.living integerValue];
    NSInteger toilet = [item.toilet integerValue];
    _mainUnitLabelOne.text = [NSString stringWithFormat:@"%ld室%ld厅%ld卫",(long)room,(long)living,(long)toilet];
    if (item.area) {
         _mainUnitLabelThree.text = [NSString stringWithFormat:@"%@平",item.area];
    }
    if (item.price) {
        _mianUnitLabelFour.text = [NSString stringWithFormat:@"%@万元",item.price];
    }
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _mainUnitLabelOne.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _mainUnitLabelOne.textColor = UIColorRBG(68, 68, 68);
    _mainUnitLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    _mainUnitLabelThree.textColor = UIColorRBG(153, 153, 153);
    _mianUnitLabelFour.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
    _mianUnitLabelFour.textColor = UIColorRBG(255, 105, 114);
}

@end
