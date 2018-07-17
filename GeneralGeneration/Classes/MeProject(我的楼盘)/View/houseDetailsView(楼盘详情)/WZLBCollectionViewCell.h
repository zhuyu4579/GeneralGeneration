//
//  WZLBCollectionViewCell.h
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZLunBoItem;
@interface WZLBCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)WZLunBoItem *item;

@end
