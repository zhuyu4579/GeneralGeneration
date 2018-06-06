//
//  ZDAllStoreTableView.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDAllStoreTableView : UITableView
//所有门店数据
@property(nonatomic,strong)NSArray *storeArray;
//点击关注回调事件
@property(nonatomic,strong)void(^collectBolck)(NSString *storeId);

@end
