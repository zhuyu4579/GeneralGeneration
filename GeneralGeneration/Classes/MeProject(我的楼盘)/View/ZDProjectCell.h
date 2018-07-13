//
//  ZDProjectCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDProjectItem;
@interface ZDProjectCell : UITableViewCell
//楼盘名
@property (strong, nonatomic) IBOutlet UILabel *projectName;
//楼盘地址
@property (strong, nonatomic) IBOutlet UILabel *projectAdreess;
//签约分销
@property (strong, nonatomic) IBOutlet UIButton *contractStore;
//已签约分销
@property (strong, nonatomic) IBOutlet UIButton *alreadyContractStore;
//佣金
@property (strong, nonatomic) IBOutlet UILabel *commsion;

@property(nonatomic,strong)ZDProjectItem *item;

@property(nonatomic,strong)NSString *ID;

@end
