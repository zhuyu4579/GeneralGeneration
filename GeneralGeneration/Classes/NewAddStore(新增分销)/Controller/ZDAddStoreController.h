//
//  ZDAddStoreController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/28.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDAddStoreController : UIViewController
//分销名称
@property (strong, nonatomic) IBOutlet UITextField *storeName;
//公司全称
@property (strong, nonatomic) IBOutlet UITextField *comptyName;
//分销类型
@property (strong, nonatomic) IBOutlet UILabel *storeType;
//分销位置
@property (strong, nonatomic) IBOutlet UILabel *address;
//分销地址
@property (strong, nonatomic) IBOutlet UITextField *addr;
//分销人数
@property (strong, nonatomic) IBOutlet UITextField *totalPeople;
//负责人
@property (strong, nonatomic) IBOutlet UITextField *dutyName;
//联系电话
@property (strong, nonatomic) IBOutlet UITextField *telphone;
//公司简介
@property (strong, nonatomic) IBOutlet UITextView *remarks;
//选择按钮
@property (strong, nonatomic) IBOutlet UIButton *selectStoreType;
//分销位置按钮
@property (strong, nonatomic) IBOutlet UIButton *addrButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headHeight;
//选择类型
- (IBAction)selectStoreType:(UIButton *)sender;
//选择位置
- (IBAction)selectAddress:(UIButton *)sender;
@end
