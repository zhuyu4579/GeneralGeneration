//
//  ZDAreasCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAreasCell.h"
#import "ZDAreasItem.h"
@implementation ZDAreasCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorRBG(245, 245, 245);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setItem:(ZDAreasItem *)item{
    _item = item;
    _name.text = item.areaName;
    
    _areasId = item.areaid;
    if ([item.flag isEqual:@"1"]) {
       _name.textColor = UIColorRBG(3, 133, 219);
    }else{
        _name.textColor = UIColorRBG(102, 102, 102);
    }
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    [super setFrame:frame];
}
@end
