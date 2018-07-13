//
//  ZDFollowCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDFollowCell.h"
#import "ZDFollowItem.h"

@implementation ZDFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label.layer.cornerRadius= 5.0;
    _label.layer.masksToBounds =YES;
    _followTime.textColor = UIColorRBG(33, 33, 33);
    _followContent.textColor = UIColorRBG(153, 153, 153);
    _followContent.numberOfLines = 0;
    _dutyName.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
    _label.backgroundColor = UIColorRBG(178, 178, 178);
    _ineOne.backgroundColor = UIColorRBG(178, 178, 178);
    _ineTwo.backgroundColor = UIColorRBG(178, 178, 178);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDFollowItem *)item{
    _item = item;
    _followTime.text = item.followTime;
    _followContent.text = item.content;
    _dutyName.text = item.followBy;
}
@end
