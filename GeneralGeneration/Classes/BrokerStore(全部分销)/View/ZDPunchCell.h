//
//  ZDPunchCell.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/6/15.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZDPunchItem;
@interface ZDPunchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *pointButton;
@property (strong, nonatomic) IBOutlet UIView *ineTop;
@property (strong, nonatomic) IBOutlet UIView *ineBottom;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIButton *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *punchContent;
@property(nonatomic,strong)ZDPunchItem *item;
@end
