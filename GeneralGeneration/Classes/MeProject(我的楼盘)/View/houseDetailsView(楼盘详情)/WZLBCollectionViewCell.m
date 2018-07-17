//
//  WZLBCollectionViewCell.m
//  KingBroker
//
//  Created by 朱玉隆 on 2018/6/8.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZLBCollectionViewCell.h"
#import "WZLunBoItem.h"
#import <UIImageView+WebCache.h>
@implementation WZLBCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(void)setItem:(WZLunBoItem *)item{
    _item = item;
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                 forHTTPHeaderField:@"Accept"];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.url] placeholderImage:[UIImage imageNamed:@"zlp_pic"]];
    _ID = item.id;
}
@end
