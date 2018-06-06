//
//  ZDHomePageCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/23.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDHomePageCell.h"
#import "ZDPageItem.h"
@implementation ZDHomePageCell
-(void)setItem:(ZDPageItem *)item{
    _item = item;
    _imageview.image = [UIImage imageNamed:item.imageName];
    _name.text = item.name;
    _tags = item.tag;
    _ename = item.enames;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
