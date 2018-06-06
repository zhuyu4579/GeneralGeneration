//
//  ZDAlreadyCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAlreadyCell.h"
#import "ZDAlreadyItem.h"
@implementation ZDAlreadyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _StoreName.textColor = UIColorRBG(68, 68, 68);
    _StoreAdreess.textColor = UIColorRBG(153, 153, 153);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
-(void)setItem:(ZDAlreadyItem *)item{
    _item = item;
    _storeId = item.id;
    _StoreName.text = item.name;
    _StoreAdreess.text = item.address;
}
@end
