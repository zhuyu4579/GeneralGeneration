//
//  ZDHousesCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDHousesCell.h"
#import "ZDHousesItem.h"
@implementation ZDHousesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _name.textColor = UIColorRBG(68, 68, 68);
    _address.textColor = UIColorRBG(153, 153, 153);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    frame.origin.y +=1;
    [super setFrame:frame];
}
-(void)setItem:(ZDHousesItem *)item{
    _item = item;
    _ID = item.id;
    _name.text = item.name;
    _address.text = item.address;
    _realTelFlag = item.realTelFlag;
}
@end
