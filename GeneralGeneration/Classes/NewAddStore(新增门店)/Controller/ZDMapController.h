//
//  ZDMapController.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/30.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDMapController : UIViewController
//返回数据
@property(nonatomic,strong)void(^addrBlock)(NSMutableDictionary *address);
@end
