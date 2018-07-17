//
//  WZAllTableViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZAllTableViewCell.h"
#import "WZPeripheryItem.h"
@implementation WZAllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _distance.textColor = UIColorRBG(153, 153, 153);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(WZPeripheryItem *)item{
    _item = item;
    _name.text = item.name;
    _distance.text = item.distance;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    frame.origin.y += 1;
    [super setFrame:frame];
}
@end
