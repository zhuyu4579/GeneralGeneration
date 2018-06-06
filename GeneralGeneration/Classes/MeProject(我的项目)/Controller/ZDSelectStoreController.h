//
//  ZDSelectStoreController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/26.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDSelectStoreController : UIViewController
//项目ID
@property(nonatomic,strong)NSString *projectId;
//回调数据
@property(nonatomic,strong)void(^storeBlocks)(NSDictionary *stores);
@end
