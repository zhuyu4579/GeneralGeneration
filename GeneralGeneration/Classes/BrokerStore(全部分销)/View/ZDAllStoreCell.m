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
    
    _readFollow.layer.cornerRadius = 10.0;
    _readFollow.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_readFollow setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _readFollow.layer.borderWidth = 1.0;
    
    _punch.layer.cornerRadius = 10.0;
    _punch.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    [_punch setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
    _punch.layer.borderWidth = 1.0;
    
    [_contractProject setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [_collect setEnlargeEdge:44];
    [_readFollow setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
    [_punch setEnlargeEdgeWithTop:10 right:5 bottom:10 left:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setItem:(ZDAllStoreItem *)item{
    _item = item;
    _storeName.text = item.name;
    _storeDate.text = item.distance;
    _storeAddress.text = item.addr;
    _isCollect = item.collect;
    if ([_isCollect isEqual:@"0"]) {
        _collect.selected = NO;
    }else if([_isCollect isEqual:@"1"]){
        _collect.selected = YES;
    }
    _storeId = item.id;
    _dutyName = item.dutyName;
    _telphone = item.telphone;
    _companyName = item.companyName;
    _signProsDtos = item.signProsDtos;
    
    _collectItemOne.text = @"";
    _collectItemOne.backgroundColor = [UIColor clearColor];
    _collectItemOne.textColor = [UIColor clearColor];
    
    _collectItemTwo.text = @"";
    _collectItemTwo.backgroundColor = [UIColor clearColor];
    _collectItemTwo.textColor = [UIColor clearColor];
    
    _collectItemThree.text = @"";
    _collectItemThree.backgroundColor = [UIColor clearColor];
    _collectItemThree.textColor = [UIColor clearColor];
    
    _collectItemFrou.text = @"";
    _collectItemFrou.backgroundColor = [UIColor clearColor];
    _collectItemFrou.textColor = [UIColor clearColor];
    
    if (_signProsDtos.count!=0) {
        for (int i = 0; i<_signProsDtos.count; i++) {
            NSString *type = [_signProsDtos[i] valueForKey:@"type"];
            if (i==0) {
                
                if ([type isEqual:@"1"]) {
                    _collectItemOne.backgroundColor = UIColorRBG(255, 231, 195);
                    _collectItemOne.textColor = UIColorRBG(255, 180, 61);
                }else if([type isEqual:@"2"]){
                    _collectItemOne.backgroundColor = UIColorRBG(200, 228, 255);
                    _collectItemOne.textColor = UIColorRBG(3, 133, 219);
                }else{
                    _collectItemOne.backgroundColor = UIColorRBG(204, 204, 204);
                    _collectItemOne.textColor = UIColorRBG(153, 153, 153);
                }
                _collectItemOne.text = [NSString stringWithFormat:@" %@ ",[_signProsDtos[i] valueForKey:@"name"]];
            }else if(i==1){
                if ([type isEqual:@"1"]) {
                    _collectItemTwo.backgroundColor = UIColorRBG(255, 231, 195);
                    _collectItemTwo.textColor = UIColorRBG(255, 180, 61);
                }else{
                    _collectItemTwo.backgroundColor = UIColorRBG(200, 228, 255);
                    _collectItemTwo.textColor = UIColorRBG(3, 133, 219);
                }
                 _collectItemTwo.text = [NSString stringWithFormat:@" %@ ",[_signProsDtos[i] valueForKey:@"name"]];
            }else if(i==2){
                if ([type isEqual:@"1"]) {
                    _collectItemThree.backgroundColor = UIColorRBG(255, 231, 195);
                    _collectItemThree.textColor = UIColorRBG(255, 180, 61);
                }else{
                    _collectItemThree.backgroundColor = UIColorRBG(200, 228, 255);
                    _collectItemThree.textColor = UIColorRBG(3, 133, 219);
                }
                 _collectItemThree.text = [NSString stringWithFormat:@" %@ ",[_signProsDtos[i] valueForKey:@"name"]];
            }else if(i==3){
                if ([type isEqual:@"1"]) {
                    _collectItemFrou.backgroundColor = UIColorRBG(255, 231, 195);
                    _collectItemFrou.textColor = UIColorRBG(255, 180, 61);
                }else{
                    _collectItemFrou.backgroundColor = UIColorRBG(200, 228, 255);
                    _collectItemFrou.textColor = UIColorRBG(3, 133, 219);
                }
                 _collectItemFrou.text = [NSString stringWithFormat:@" %@ ",[_signProsDtos[i] valueForKey:@"name"]];
            }
        }
    }else if(_signProsDtos.count==0){
        _collectItemOne.backgroundColor = UIColorRBG(204, 204, 204);
        _collectItemOne.textColor = UIColorRBG(153, 153, 153);
        _collectItemOne.text = @" 暂无签约 ";
    }
}
-(void)setFrame:(CGRect)frame{
    frame.size.height -=10;
    frame.origin.y +=10;
    [super setFrame:frame];
}
@end
