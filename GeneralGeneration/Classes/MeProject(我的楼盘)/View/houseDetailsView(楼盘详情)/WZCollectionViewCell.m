//
//  WZCollectionViewCell.m
//  WZJJ
//
//  Created by 朱玉隆 on 2018/4/11.
//  Copyright © 2018年 朱玉隆. All rights reserved.
//

#import "WZCollectionViewCell.h"
#import "UIView+Frame.h"

@interface WZCollectionViewCell ()

@end

@implementation WZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.fWidth , self.fHeight)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;

        [self.contentView addSubview:self.imageV];
    }
    return self;
}

@end
