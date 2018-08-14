//
//  ZDStoreCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDStoreCell.h"
#import "ZDStoreItem.h"
@implementation ZDStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _storeName.textColor = UIColorRBG(68, 68, 68);
    _storeAddress.textColor = UIColorRBG(153, 153, 153);
    _time.textColor = UIColorRBG(153, 153, 153);
    _status.backgroundColor = UIColorRBG(240, 246, 236);
    _status.textColor = UIColorRBG(111, 182, 244);
    _saveName.textColor = UIColorRBG(68, 68, 68);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDStoreItem *)item{
   _item = item;
    _storeName.text = item.name;
    _storeAddress.text = item.addr;
    _storeId = item.id;
    _collect = item.collect;
    _updateDate = item.updateDate;
    _defaultSignStartTime = item.defaultSignStartTime;
    _signEndTime = item.signEndTime;
    _time.text = @"";
    _status.text = @"";
    _saveName.text = @"";
    if (![_defaultSignStartTime isEqual:@""]) {
        _time.text = [NSString stringWithFormat:@"%@ 至 %@",_defaultSignStartTime,_signEndTime];
    }
    _dutyName = item.dutyName;
    _signStatus = item.signStatus;
    _storeCreatorName = item.storeCreatorName;
    _protectType = item.protectType;
    if ([_signStatus isEqual:@"2"]) {
        _status.text = @" 已签约 ";
        _saveName.text = [NSString stringWithFormat:@"责任经服：%@",item.dutyName];
        if([item.type isEqual:@"0"]){
            _status.backgroundColor = UIColorRBG(255, 213, 195);
            _status.textColor = UIColorRBG(255, 180, 61);
        }
    }else{
        if([_protectType isEqual:@"1"]){
             _status.text = @" 保护期 ";
            _status.backgroundColor = UIColorRBG(238, 238, 238);
            _status.textColor = UIColorRBG(204, 204, 204);
        }
    }
}

-(void)setFrame:(CGRect)frame{
    frame.size.height -=1;
    frame.origin.y +=1;
    [super setFrame:frame];
}
@end
