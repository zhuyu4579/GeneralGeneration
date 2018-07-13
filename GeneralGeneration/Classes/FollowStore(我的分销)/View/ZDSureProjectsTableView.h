//
//  ZDSureProjectsTableView.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSureProjectsTableView : UITableView
//数据数组
@property(nonatomic,strong)NSArray *projectArray;
//回调数据
@property(nonatomic,strong)void(^projectBlock)(NSDictionary *projectDicty);
@end
