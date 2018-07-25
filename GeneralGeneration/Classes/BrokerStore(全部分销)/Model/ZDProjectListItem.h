//
//  ZDProjectListItem.h
//  GeneralGeneration
//
//  Created by 朱玉隆 on 2018/4/29.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDProjectListItem : NSObject

@property(nonatomic,strong)NSString *projectId;

@property(nonatomic,strong)NSString *projectName;

@property(nonatomic,strong)NSString *validityTimeEnd;

@property(nonatomic,strong)NSString *serverName;
@end
