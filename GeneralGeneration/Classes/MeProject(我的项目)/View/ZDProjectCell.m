//
//  ZDProjectCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDProjectCell.h"
#import "ZDProjectItem.h"
#import "UIButton+WZEnlargeTouchAre.h"
@implementation ZDProjectCell
-(void)setItem:(ZDProjectItem *)item{
    _item = item;
    _ID = item.id;
    _projectName.text = item.name;
    _projectAdreess.text = item.address;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _projectName.textColor = UIColorRBG(102, 102, 102);
    _projectAdreess.textColor = UIColorRBG(153, 153, 153);
    _contractStore.layer.cornerRadius = 10.0;
    _contractStore.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_contractStore setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _contractStore.layer.borderWidth = 1.0;
    _alreadyContractStore.layer.cornerRadius = 10.0;
    _alreadyContractStore.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_alreadyContractStore setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _alreadyContractStore.layer.borderWidth = 1.0;
    [_contractStore setEnlargeEdgeWithTop:10 right:9 bottom:10 left:9];
    [_alreadyContractStore setEnlargeEdgeWithTop:10 right:9 bottom:10 left:9];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=10;
    frame.origin.y +=10;
    [super setFrame:frame];
}

@end
