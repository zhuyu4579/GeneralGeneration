//
//  ZDSelectProjectController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSelectProjectController : UIViewController
//分销ID
@property(nonatomic,strong)NSString *storeId;
//回调数据
@property(nonatomic,strong)void(^projectBlocks)(NSDictionary *projects);
@end
