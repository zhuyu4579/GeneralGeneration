//
//  ZDMeCustCell.m
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/24.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "ZDMeCustCell.h"
#import "ZDMeCustItem.h"
#import "ZDRefusalController.h"
#import "UIButton+WZEnlargeTouchAre.h"
#import "UIViewController+WZFindController.h"
@implementation ZDMeCustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _itemName.textColor = UIColorRBG(68, 68, 68);
    _orderTime.textColor = UIColorRBG(204, 204, 204);
    _customerName.textColor = UIColorRBG(153, 153, 153);
    _cusTelphoneLabel.textColor = UIColorRBG(153, 153, 153);
    _cusPhone.textColor = UIColorRBG(3, 133, 219);
    _brokerName.textColor = UIColorRBG(153, 153, 153);
    _brokerPhone.textColor = UIColorRBG(153, 153, 153);
    _telphone.textColor = UIColorRBG(3, 133, 219);
    _status.textColor = UIColorRBG(3, 133, 219);
    //按钮
    _refusalButton.layer.cornerRadius = 10.0;
    _refusalButton.layer.masksToBounds = YES;
    [_cusPlayTelphone setEnlargeEdgeWithTop:44 right:44 bottom:10 left:44];
    [_playPhone setEnlargeEdgeWithTop:10 right:44 bottom:44 left:44];
    _refusalButton.layer.borderColor = UIColorRBG(3, 133, 219).CGColor;
    _refusalButton.layer.borderWidth = 1.0;
    [_refusalButton setTitleColor:UIColorRBG(3, 133, 219) forState:UIControlStateNormal];
}
-(void)setItem:(ZDMeCustItem *)item{
    _item = item;
    _itemName.text =item.projectName;
    _orderTime.text = item.updateDate;
    _customerName.text = [NSString stringWithFormat:@"客        户：%@",item.clientName];
    _telphones = item.missContacto;
    if ([_telphones containsString:@"*"]&& ![_telphones isEqual:@""]) {
        [_cusPlayTelphone setHidden:YES];
        [_cusPlayTelphone setEnabled:NO];
        _cusPhone.textColor = UIColorRBG(153, 153, 153);
    }
    _cusPhone.text = item.missContacto;
    _brokerName.text = [NSString stringWithFormat:@"经   纪  人：%@",[item.user valueForKey:@"realname"]];
    _brokerPhone.text = [NSString stringWithFormat:@"电         话："];
    _telphone.text = [item.user valueForKey:@"phone"];
    NSString *telphone = [item.user valueForKey:@"phone"];
    if ([telphone containsString:@"*"] && ![telphone isEqual:@""]) {
        [_playPhone setHidden:YES];
        [_playPhone setEnabled:NO];
        _telphone.textColor = UIColorRBG(153, 153, 153);
    }
    NSArray *statusArray = @[@"已报备",@"已上客",@"已成交",@"已失效",@"成交审核中"];
    int n = [item.dealStatus intValue];
    int m = [item.verify intValue];
    [_refusalButton setHidden:YES];
    //可以拒单状态1.3
    if ((n == 1 && m == 3)) {
        [_refusalButton setTitle:@"拒单" forState:UIControlStateNormal];
        [_refusalButton setHidden:NO];
    }
    //判断订单状态
    if(n == 1){
       _status.text = statusArray[0];
    }else if(n == 2){
       _status.text = statusArray[1];
    }else if(n == 3){
        if (m == 3) {
          _status.text = statusArray[2];
        }else{
           _status.text = statusArray[4];
        }
    }else if(n == 4){
        if (m == 3) {
           _status.text = statusArray[3];
        }
    }
    _source = item.source;
    if ([_source isEqual:@"2"]) {
        [_brokerName setHidden:YES];
        [_brokerPhone setHidden:YES];
        [_telphone setHidden:YES];
        [_playPhone setEnabled:NO];
        [_playPhone setHidden:YES];
        _sourceHeight.constant = 19;
    }
    _ID = item.id;
    _appUserId = item.appUserId;
    _statu = item.dealStatus;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setFrame:(CGRect)frame{
    frame.origin.y +=10;
    frame.size.height -=10;
    [super setFrame:frame];
}
- (IBAction)playPhone:(UIButton *)sender {
    
    NSString *phone = _telphone.text;
    
    if (![phone isEqual:@""]&&![phone isEqual:@"无"]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}

- (IBAction)cusplayPhone:(UIButton *)sender {
    NSString *phone = _cusPhone.text;
    
    if (![phone isEqual:@""]&&![phone isEqual:@"无"]) {
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", phone];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }
}

- (IBAction)refusal:(UIButton *)sender {
    ZDRefusalController *ref =[[ZDRefusalController alloc] init];
    UIViewController *Vc = [UIViewController viewController:[self superview]];
    ref.ID = _ID;
    [Vc.navigationController pushViewController:ref animated:YES];
}
@end
