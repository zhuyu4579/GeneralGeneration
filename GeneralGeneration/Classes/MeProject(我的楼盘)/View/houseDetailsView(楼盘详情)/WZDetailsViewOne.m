//
//  WZDetailsViewOne.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZDetailsViewOne.h"
#import <SVProgressHUD.h>
#import "UIButton+WZEnlargeTouchAre.h"
#import "UIViewController+WZFindController.h"
@implementation WZDetailsViewOne

+(instancetype)detailViewTwo{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
-(void)layoutSubviews{
    self.itemName.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    self.itemName.textColor = UIColorRBG(68, 68, 68);
    _price.textColor =UIColorRBG(255, 127, 19);
    
    self.itemLabel.backgroundColor = UIColorRBG(230, 244, 255);
    self.itemLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabel.textColor = UIColorRBG(40, 180, 230);
    self.itemLabelTwo.backgroundColor = UIColorRBG(230, 244, 255);
    self.itemLabelTwo.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabelTwo.textColor = UIColorRBG(40, 180, 230);
    self.itemLabelThree.backgroundColor = UIColorRBG(230, 244, 255);
    self.itemLabelThree.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.itemLabelThree.textColor = UIColorRBG(40, 180, 230);
    
    self.Commission.textColor = UIColorRBG(244, 102, 30);
    self.ineViewOne.backgroundColor = UIColorRBG(242, 242, 242);
    self.ineViewTwo.backgroundColor = UIColorRBG(242, 242, 242);
    self.ineViewThree.backgroundColor = UIColorRBG(242, 242, 242);
    self.addressTitle.textColor = UIColorRBG(153, 153, 153);
    self.phoneTitle.textColor = UIColorRBG(153, 153, 153);
    self.seeHouse.textColor = UIColorRBG(153, 153, 153);
    
    self.address.textColor = UIColorRBG(68, 68, 68);
    self.phone.textColor = UIColorRBG(68, 68, 68);
    self.companyName.textColor = UIColorRBG(68, 68, 68);
    self.chargeMan.textColor = UIColorRBG(68, 68, 68);
}
@end
