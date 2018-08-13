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
    _time.textColor = UIColorRBG(153, 153, 153);
    _dutyName.textColor = UIColorRBG(68, 68, 68);
    _status.backgroundColor = UIColorRBG(240, 246, 236);
    _status.textColor = UIColorRBG(111, 182, 244);
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
    _signEndTime = item.signEndTime;
    if (![_defaultSignStartTime isEqual:@""]) {
        _time.text = [NSString stringWithFormat:@"%@ 至 %@",_defaultSignStartTime,_signEndTime];
    }
    _signStatus = item.signStatus;
    if ([_signStatus isEqual:@"2"]) {
        _status.text = @" 已签约 ";
         _dutyName.text = [NSString stringWithFormat:@"责任经服：%@",item.serverName];
        if([item.type isEqual:@"0"]){
            _status.backgroundColor = UIColorRBG(255, 213, 195);
            _status.textColor = UIColorRBG(255, 180, 61);
        }
    }
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    frame.origin.y +=1;
    [super setFrame:frame];
}
@end
