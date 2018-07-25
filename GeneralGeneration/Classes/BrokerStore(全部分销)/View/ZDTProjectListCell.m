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
    _projectName.textColor = UIColorRBG(51, 51, 51);
    _time.textColor = UIColorRBG(153, 153, 153);
    _name.textColor = UIColorRBG(93, 176, 232);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDProjectListItem *)item{
    _item = item;
    _projectName.text = item.projectName;
    _projectId = item.projectId;
    _time.text = [NSString stringWithFormat:@"截止时间：%@",item.validityTimeEnd];
    _name.text = [NSString stringWithFormat:@"责任经服：%@",item.serverName];
    
}
@end
