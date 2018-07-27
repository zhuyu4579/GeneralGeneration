//
//  ZDHousesCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDHousesItem;
@interface ZDHousesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property(nonatomic,strong)NSString *realTelFlag;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)ZDHousesItem *item;

@end
