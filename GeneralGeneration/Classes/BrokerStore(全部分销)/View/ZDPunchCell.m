//
//  ZDPunchCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDPunchCell.h"
#import "ZDPunchItem.h"
@implementation ZDPunchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _pointButton.layer.cornerRadius= 5.0;
    _pointButton.layer.masksToBounds =YES;
    _pointButton.backgroundColor = UIColorRBG(178, 178, 178);
    _ineTop.backgroundColor = UIColorRBG(178, 178, 178);
    _ineBottom.backgroundColor = UIColorRBG(178, 178, 178);
    _titleLabel.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    _titleLabel.layer.borderWidth = 1.0;
    _titleLabel.layer.cornerRadius= 2.0;
    [_titleLabel setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _label.textColor = UIColorRBG(153, 153, 153);
    _punchContent.textColor = UIColorRBG(153, 153, 153);
    _punchContent.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDPunchItem *)item{
    _item  = item;
    _date.text = item.clockDate;
    NSString *type = item.clockType;
    if ([type isEqual:@"1"]) {
        [_titleLabel setTitle:@"店内" forState:UIControlStateNormal];
    }else{
        [_titleLabel setTitle:@"外勤" forState:UIControlStateNormal];
    }
    _punchContent.text = item.addr;
}
@end
