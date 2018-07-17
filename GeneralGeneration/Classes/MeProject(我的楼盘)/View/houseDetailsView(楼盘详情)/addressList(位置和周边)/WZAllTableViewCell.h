//
//  WZAllTableViewCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZPeripheryItem;
@interface WZAllTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property(nonatomic,strong)WZPeripheryItem *item;
@end
