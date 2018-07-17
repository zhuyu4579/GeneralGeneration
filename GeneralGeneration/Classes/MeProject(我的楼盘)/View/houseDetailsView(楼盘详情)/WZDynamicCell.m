//
//  WZDynamicCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZDynamicCell.h"

@implementation WZDynamicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _DynamicTitle.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    _DynamicTitle.textColor = UIColorRBG(68, 68, 68);
    _DynamicTime.font = [UIFont fontWithName:@"PingFang-SC-Light" size:11];
    _DynamicTime.textColor = UIColorRBG(153, 153, 153);
    _DynamicContent.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
    _DynamicContent.textColor =  UIColorRBG(102, 102, 102);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
