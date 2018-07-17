//
//  ZDMeCustCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDMeCustItem;
@interface ZDMeCustCell : UITableViewCell
//楼盘名称
@property (strong, nonatomic) IBOutlet UILabel *itemName;
//订单时间
@property (strong, nonatomic) IBOutlet UILabel *orderTime;
//客户名字
@property (strong, nonatomic) IBOutlet UILabel *customerName;
//客户电话
@property (strong, nonatomic) IBOutlet UILabel *cusPhone;
//经纪人姓名
@property (strong, nonatomic) IBOutlet UILabel *brokerName;
//经纪人电话
@property (strong, nonatomic) IBOutlet UILabel *brokerPhone;

@property (strong, nonatomic) IBOutlet UILabel *telphone;
@property (strong, nonatomic) IBOutlet UIButton *playPhone;
//状态展示
@property (strong, nonatomic) IBOutlet UILabel *status;
//拒单按钮
@property (strong, nonatomic) IBOutlet UIButton *refusalButton;
//订单Id
@property(nonatomic,strong)NSString *ID;
//订单状态
@property(nonatomic,strong)NSString *statu;
//经纪人ID
@property(nonatomic,strong)NSString *appUserId;
//数据模型
@property(nonatomic,strong)ZDMeCustItem *item;
//打电话
- (IBAction)playPhone:(UIButton *)sender;
//拒单
- (IBAction)refusal:(UIButton *)sender;

@end
