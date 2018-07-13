//
//  ZDTProjectListCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDProjectListItem;
@interface ZDTProjectListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *projectName;

@property(nonatomic,strong)NSString *projectId;

@property(nonatomic,strong)ZDProjectListItem *item;
@end
