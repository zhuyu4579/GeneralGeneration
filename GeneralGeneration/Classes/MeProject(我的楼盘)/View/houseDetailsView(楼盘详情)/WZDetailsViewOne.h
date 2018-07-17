//
//  WZDetailsViewOne.h
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZDetailsViewOne : UIView
+(instancetype)detailViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelTwo;
@property (weak, nonatomic) IBOutlet UILabel *itemLabelThree;
@property (weak, nonatomic) IBOutlet UILabel *Commission;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *seeHouse;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *chargeMan;
@property (weak, nonatomic) IBOutlet UIView *ineViewOne;
@property (weak, nonatomic) IBOutlet UIView *ineViewTwo;
@property (weak, nonatomic) IBOutlet UIView *ineViewThree;
@property (strong, nonatomic) IBOutlet UIButton *commissionButton;

@end
