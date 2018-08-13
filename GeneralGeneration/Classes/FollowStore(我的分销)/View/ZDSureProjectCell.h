//
//  ZDSureProjectCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDProjectItem;
@interface ZDSureProjectCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *projectName;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *dutyName;

@property(nonatomic,strong)NSString *projectId;
@property(nonatomic,strong)NSString *defaultSignStartTime;
@property(nonatomic,strong)NSString *signEndTime;
@property(nonatomic,strong)NSString *signStatus;
@property(nonatomic,strong)ZDProjectItem *item;
@end
