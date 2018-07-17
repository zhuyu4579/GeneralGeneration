//
//  ZDSureProjectCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDSureProjectCell.h"
#import "ZDProjectItem.h"
@implementation ZDSureProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _projectName.textColor = UIColorRBG(68, 68, 68);
    _address.textColor = UIColorRBG(153, 153, 153);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setItem:(ZDProjectItem *)item{
    _item = item;
    _projectId = item.id;
    _projectName.text = item.name;
    _address.text = item.address;
    _defaultSignStartTime = item.defaultSignStartTime;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    frame.origin.y +=1;
    [super setFrame:frame];
}
@end
