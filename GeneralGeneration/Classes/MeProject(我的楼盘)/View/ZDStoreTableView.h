//
//  ZDStoreTableView.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDStoreTableView : UITableView
//数据数组
@property(nonatomic,strong)NSArray *storeArray;
//回调数据
@property(nonatomic,strong)void(^storeBlock)(NSDictionary *storeDicty);
@end
