//
//  ZDSelectProjectsController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/7/27.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSelectProjectsController : UITableViewController
//分销ID
@property(nonatomic,strong)NSString *storeId;
//回调数据
@property(nonatomic,strong)void(^projectBlocks)(NSDictionary *projects);

@end
