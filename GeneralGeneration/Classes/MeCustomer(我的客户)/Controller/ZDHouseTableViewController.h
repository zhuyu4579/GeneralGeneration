//
//  ZDHouseTableViewController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDHouseTableViewController : UITableViewController
//回调数据
@property(nonatomic,strong)void(^HouseBlocks)(NSDictionary *data);
@end
