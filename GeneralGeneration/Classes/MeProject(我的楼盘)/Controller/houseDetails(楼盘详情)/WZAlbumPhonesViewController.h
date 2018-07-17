//
//  WZAlbumPhonesViewController.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/7.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAlbumPhonesViewController : UIViewController
//相册识别标记
@property(nonatomic,strong)NSString *type;
//楼盘ID
@property(nonatomic,strong)NSString *projectId;
//图片Id
@property(nonatomic,strong)NSString *photoId;
@end
