//
//  WZPhotoNameCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/9.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZAlbumsItem.h"
@interface WZPhotoNameCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *name;
@property(nonatomic,strong)WZAlbumsItem *item;
@end
