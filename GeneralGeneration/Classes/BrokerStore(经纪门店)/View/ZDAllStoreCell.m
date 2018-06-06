//
//  ZDAllStoreCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDAllStoreCell.h"
#import "ZDAllStoreItem.h"
#import "UIButton+WZEnlargeTouchAre.h"
@implementation ZDAllStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
   _storeName.textColor = UIColorRBG(102, 102, 102);
    _storeDate.textColor = UIColorRBG(204, 204, 204);
    _storeAddress.textColor = UIColorRBG(153, 153, 153);
    _contractProject.layer.cornerRadius = 10.0;
    _contractProject.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_contractProject setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _contractProject.layer.borderWidth = 1.0;
    
    _collect.layer.cornerRadius = 10.0;
    _collect.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_collect setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _collect.layer.borderWidth = 1.0;
    
    _readFollow.layer.cornerRadius = 10.0;
    _readFollow.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_readFollow setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _readFollow.layer.borderWidth = 1.0;
    
    [_contractProject setEnlargeEdgeWithTop:10 right:9 bottom:10 left:9];
    [_collect setEnlargeEdgeWithTop:10 right:9 bottom:10 left:9];
    [_readFollow setEnlargeEdgeWithTop:10 right:9 bottom:10 left:9];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDAllStoreItem *)item{
    _item = item;
    _storeName.text = item.name;
    _storeDate.text = item.updateDate;
    _storeAddress.text = item.address;
    _isCollect = item.collect;
    if ([_isCollect isEqual:@"0"]) {
        [_collect setTitle:@"加关注" forState:UIControlStateNormal];
    }else if([_isCollect isEqual:@"1"]){
         [_collect setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    _storeId = item.id;
    _dutyName = item.dutyName;
    _telphone = item.telphone;
    _companyName = item.companyName;
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=10;
    frame.origin.y +=10;
    [super setFrame:frame];
}
@end
