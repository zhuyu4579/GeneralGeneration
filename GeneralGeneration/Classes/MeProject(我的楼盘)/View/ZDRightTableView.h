//
//  ZDRightTableView.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/25.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDRightTableView : UITableView
//数据模型
@property(nonatomic,strong)NSArray *areas;
//回调选择cell的城市编码
@property(nonatomic,strong)void(^cityBlock)(NSDictionary *citys);
@end
