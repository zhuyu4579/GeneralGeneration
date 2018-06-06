//
//  ZDAreasCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDAreasItem;
@interface ZDAreasCell : UITableViewCell
//名字
@property (strong, nonatomic) IBOutlet UILabel *name;
//ID
@property(nonatomic,strong)NSString *areasId;
//模型
@property(nonatomic,strong)ZDAreasItem *item;

@end
