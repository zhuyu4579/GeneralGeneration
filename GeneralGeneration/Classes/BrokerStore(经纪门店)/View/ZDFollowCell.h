//
//  ZDFollowCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/5/1.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDFollowItem;
@interface ZDFollowCell : UITableViewCell
//跟进时间
@property (strong, nonatomic) IBOutlet UILabel *followTime;
//图片
@property (strong, nonatomic) IBOutlet UIButton *label;
//跟进内容
@property (strong, nonatomic) IBOutlet UILabel *followContent;
//上面线
@property (strong, nonatomic) IBOutlet UIView *ineOne;
//下面线
@property (strong, nonatomic) IBOutlet UIView *ineTwo;
//数据模型
@property(nonatomic,strong)ZDFollowItem *item;
@end
