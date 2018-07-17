//
//  WZDynamicCell.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/10.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZDynamicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *DynamicTitle;
@property (weak, nonatomic) IBOutlet UILabel *DynamicTime;
@property (weak, nonatomic) IBOutlet UILabel *DynamicContent;

@end
