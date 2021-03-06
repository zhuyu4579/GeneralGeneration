//
//  ZDContractProjectController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDContractProjectController : UIViewController
//分销ID
@property(nonatomic,strong)NSString *storeId;
//分销名称
@property (strong, nonatomic) NSString *storeName;
//公司全称
@property(nonatomic,strong)NSString *companyName;
//负责人
@property(nonatomic,strong)NSString *dutyName;
//电话
@property(nonatomic,strong)NSString *telphone;

@end
