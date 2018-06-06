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
    _label.layer.borderColor = UIColorRBG(153, 153, 153).CGColor;
    _label.layer.borderWidth = 1.0;
    _followTime.textColor = UIColorRBG(153, 153, 153);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDFollowItem *)item{
    _item = item;
    _followTime.text = item.followTime;
    _followContent.text = item.content;
}
@end
