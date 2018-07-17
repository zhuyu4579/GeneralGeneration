//
//  WZPhotoNameCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZPhotoNameCell.h"
#import "WZAlbumsItem.h"
@implementation WZPhotoNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _name.textColor = UIColorRBG(203, 203, 203);
    
}
-(void)setItem:(WZAlbumsItem *)item{
    _item = item;
    NSArray *array = @[@"楼盘图",@"沙盘图",@"样板间图",@"位置及周边"];
    NSInteger type = [item.type integerValue];
    if (type != 5 ) {
        _name.text = [NSString stringWithFormat:@" %@(%lu) ",array[type-1],(unsigned long)item.picCollect.count];
    }else{
        _name.text = [NSString stringWithFormat:@" %@(%lu) ",item.name,(unsigned long)item.picCollect.count];
    }
}
-(void)setSelected:(BOOL)selected{
     [super setSelected:selected];
   
   
}

@end
