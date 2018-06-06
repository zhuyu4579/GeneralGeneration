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
//项目名
@property (strong, nonatomic) IBOutlet UILabel *projectName;
//项目地址
@property (strong, nonatomic) IBOutlet UILabel *projectAdreess;
//签约门店
@property (strong, nonatomic) IBOutlet UIButton *contractStore;
//已签约门店
@property (strong, nonatomic) IBOutlet UIButton *alreadyContractStore;

@property(nonatomic,strong)ZDProjectItem *item;

@property(nonatomic,strong)NSString *ID;
@end
