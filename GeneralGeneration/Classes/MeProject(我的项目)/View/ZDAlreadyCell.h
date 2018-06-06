//
//  ZDAlreadyCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDAlreadyItem;
@interface ZDAlreadyCell : UITableViewCell
//已签约门店名称
@property (strong, nonatomic) IBOutlet UILabel *StoreName;
//已签约门店地址
@property (strong, nonatomic) IBOutlet UILabel *StoreAdreess;
//已签约门店编码
@property(nonatomic,strong)NSString *storeId;
//数据数组
@property(nonatomic,strong)ZDAlreadyItem *item;

@end
