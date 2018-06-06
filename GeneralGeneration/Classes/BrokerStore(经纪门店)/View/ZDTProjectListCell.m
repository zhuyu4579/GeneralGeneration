//
//  ZDTProjectListCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDTProjectListCell.h"
#import "ZDProjectListItem.h"
@implementation ZDTProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _projectName.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDProjectListItem *)item{
    _item = item;
    _projectName.text = item.projectName;
    _projectId = item.projectId;
}
@end
